import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/app_styles.dart';
import '../../../../util/result.dart';
import '../../../../util/result_handler.dart';
import '../../data/di/my_string_dependency_injection.dart';
import '../../domain/entity/my_string_entity.dart';
import '../bloc/my_string_bloc.dart';
import '../bloc/my_string_event.dart';
import '../bloc/my_string_state.dart';
import '../viewmodel/my_string_viewmodel.dart';

/// This screen demonstrates how to apply MVVM Clean + Bloc architecture
/// to manage a simple string stored locally and remotely.
class MyStringScreen extends StatefulWidget {
  // Testability for widget testing
  final MyStringViewModel? injectedViewModel;
  final MyStringBloc? injectedBloc;

  const MyStringScreen({
    super.key,
    this.injectedViewModel,
    this.injectedBloc,
  });

  @override
  State<MyStringScreen> createState() => MyStringScreenState();
}

/// State class for MyStringScreen
/// - Manages lifecycle events
/// - Observes Bloc states
/// - Connects View <-> Bloc <-> ViewModel <-> UseCases
class MyStringScreenState extends State<MyStringScreen> with WidgetsBindingObserver {
  late final MyStringBloc bloc; // Bloc to manage "my_string" state

  @visibleForTesting
  MyStringBloc get exposedBloc => bloc; // For widget testing access

  final TextEditingController textEditController = TextEditingController(); // Controller for user input

  @override
  void initState() {
    super.initState();

    // Listen to app lifecycle (pause/resume)
    WidgetsBinding.instance.addObserver(this);

    // Inject testable Bloc/ViewModel or use default
    bloc = widget.injectedBloc ?? MyStringBloc();
    bloc.viewModel = widget.injectedViewModel ?? bloc.viewModel;

    // Load existing string from local store on app start
    bloc.viewModel.getMyStringFromLocal().then((result) {
      switch (result) {
        case Success<MyStringEntity>(:final data):
          bloc.add(UpdateMyStringFromLocalEvent(data.value));
          break;
        case Failure<MyStringEntity>(:final message):
          bloc.add(UpdateMyStringFromLocalEvent('Error loading: $message'));
          break;
      }
      textEditController.clear(); // Clear input field after loading
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textEditController.dispose();
    super.dispose();
  }

  /// React to app going to background/inactive
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveCurrentText(); // Save any text before app goes background
    }
  }

  /// Save current text optimistically when app goes background
  void _saveCurrentText() {
    final text = textEditController.text.trim();
    if (text.isNotEmpty) {
      bloc.viewModel.storeMyStringToLocal(text);
    }
  }

  /// User wants to update the string from TextField (optimistic UI)
  void updateFromUser() async {
    final newValue = textEditController.text.trim();
    final previousState = bloc.state; // Save previous state for rollback

    bloc.add(UpdateMyStringFromUserEvent(newValue)); // Optimistic update immediately

    // Try saving new value to local store
    await handleResult<void>(
      futureResult: bloc.viewModel.storeMyStringToLocal(newValue),
      onSuccess: (_) {
        textEditController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated from User')),
        );
      },
      onFailure: (message) {
        // Rollback to previous value if save failed
        if (previousState is MyStringSuccessState) {
          bloc.add(UpdateMyStringFromUserEvent(previousState.value));
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $message')),
        );
      },
    );
  }

  /// User wants to fetch a string from server (simulate network call)
  void updateFromServer() async {
    // Define a future function for fetching and storing
    Future<String> fetchAndStore() async {
      final result = await bloc.viewModel.getMyStringFromRemote();

      final value = await handleResultReturning<MyStringEntity, String>(
        futureResult: Future.value(result),
        onSuccess: (data) => data.value,
        onFailure: (message) => 'Error fetching from server: $message',
      );

      if (!value.startsWith('Error')) {
        await bloc.viewModel.storeMyStringToLocal(value);
      }

      return value;
    }

    // Dispatch event to Bloc
    final event = UpdateMyStringFromServerEvent(fetchAndStore);
    bloc.add(event);

    // Show loading message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fetching from Server...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MVVM Clean + Bloc'),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;
          final maxContentWidth = isLandscape ? 500.0 : 600.0;
          final horizontalPadding = isLandscape ? AppDimens.screenPadding * 2 : AppDimens.screenPadding;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: AppDimens.screenPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Display selected DI options
                    Text(
                      '$storeTypeSelected - $serverTypeSelected',
                      style: AppTextStyles.small,
                    ),
                    const SizedBox(height: AppDimens.screenPadding),

                    // Bloc UI
                    BlocBuilder<MyStringBloc, MyStringState>(
                      bloc: bloc,
                      builder: (context, state) {
                        final isLoading = state is MyStringLoadingState;

                        return Card(
                          elevation: AppDimens.cardElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimens.cardCornerRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppDimens.screenPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // User input TextField
                                TextField(
                                  enabled: !isLoading,
                                  controller: textEditController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter string',
                                    border: OutlineInputBorder(),
                                  ),
                                  onEditingComplete: () {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      updateFromUser();
                                    });
                                  },
                                ),

                                const SizedBox(height: AppDimens.buttonSpacing),

                                // Buttons: Update from User and Server
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        key: const Key('updateFromUserButton'),
                                        onPressed: isLoading ? null : updateFromUser,
                                        icon: const Icon(Icons.person),
                                        label: const Text('Update from User'),
                                      ),
                                    ),
                                    const SizedBox(width: AppDimens.buttonSpacing),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        key: const Key('updateFromServerButton'),
                                        onPressed: isLoading ? null : updateFromServer,
                                        icon: const Icon(Icons.cloud_download),
                                        label: const Text('Update from Server'),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppDimens.screenPadding * 2),

                                // Render content based on state
                                if (state is MyStringInitialState)
                                  Text('Enter or load a string to begin', style: AppTextStyles.italicHint)
                                else if (state is MyStringLoadingState)
                                  const Center(child: CircularProgressIndicator())
                                else if (state is MyStringSuccessState) ...[
                                    Text('Current Value:', style: AppTextStyles.medium),
                                    Text(state.value, style: AppTextStyles.large),
                                  ]
                                  else if (state is MyStringErrorState)
                                      Text('Error: ${state.message}', style: AppTextStyles.error)
                                    else
                                      const SizedBox.shrink(), // Defensive fallback
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

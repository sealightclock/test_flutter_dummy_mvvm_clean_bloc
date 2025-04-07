import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/theme/app_styles.dart'; // <-- NEW import for shared styles

import '../../data/di/my_string_dependency_injection.dart';
import '../../domain/entity/my_string_entity.dart';
import '../../util/result.dart';
import '../../util/result_handler.dart';
import '../factory/my_string_viewmodel_factory.dart';

class MyStringHomeScreen extends StatefulWidget {
  // Testability for widget testing
  final MyStringViewModel? injectedViewModel;
  final MyStringBloc? injectedBloc;

  const MyStringHomeScreen({
    super.key,
    this.injectedViewModel,
    this.injectedBloc,
  });

  @override
  State<MyStringHomeScreen> createState() => MyStringHomeScreenState();
}

/// For testing: expose the class
class MyStringHomeScreenState extends State<MyStringHomeScreen> {
  // Bloc to manage state.
  late final MyStringBloc bloc;
  @visibleForTesting
  MyStringBloc get exposedBloc => bloc;

  // ViewModel to communicate with Use Cases.
  late final MyStringViewModel viewModel;

  // Controller for TextField input.
  final TextEditingController textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Testability for widget testing
    // Use injected or default instances
    bloc = widget.injectedBloc ?? MyStringBloc();
    viewModel = widget.injectedViewModel ?? createViewModel();

    // Load value from local store at app start
    viewModel.getMyStringFromLocal().then((result) {
      switch (result) {
        case Success<MyStringEntity>(:final data):
          bloc.add(UpdateMyStringFromLocalEvent(data.value));
          break;
        case Failure<MyStringEntity>(:final message):
          bloc.add(UpdateMyStringFromLocalEvent('Error loading: $message'));
          break;
      }
      textEditController.clear();
    });
  }

  /// Handles user submitting a new string:
  /// [1] Save the string into the local store.
  /// [2] Only after successful save, update the Bloc state.
  /// [3] Clear the TextField and show a SnackBar.
  void updateFromUser() async {
    final value = textEditController.text.trim();

    await handleResult<void>(
      viewModel.storeMyStringToLocal(value),
      onSuccess: (_) {
        // Only after successful save to local storage:
        bloc.add(UpdateMyStringFromUserEvent(value));
        textEditController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated from User')),
        );
      },
      onFailure: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $message')),
        );
      },
    );
  }

  /// Handles user requesting a string from server:
  /// [1] Fetch string from server.
  /// [2] Save string to local store.
  /// [3] Update Bloc state.
  void updateFromServer() async {
    // This function will be passed into the Bloc event
    Future<String> fetchAndStore() async {
      // Step 1: Fetch from remote server
      final result = await viewModel.getMyStringFromRemote();

      // Step 2: Handle result
      final value = await handleResultReturning<MyStringEntity, String>(
        Future.value(result),
        onSuccess: (data) => data.value, // Just return the successful value
        onFailure: (message) => 'Error fetching from server: $message', // Return error message
      );

      // Step 3: If fetch succeeded, also store it locally
      if (!value.startsWith('Error')) {
        await viewModel.storeMyStringToLocal(value);
      }

      // Step 4: Always return the value (success or error)
      return value;
    }

    // Step 5: Create event with the fetch function
    final event = UpdateMyStringFromServerEvent(fetchAndStore);

    // Step 6: Add event to Bloc
    bloc.add(event);

    // Step 7: Show a SnackBar while loading
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
          // Calculate dynamic constraints and padding
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
                    // Display selected DI choices
                    Text(
                      '$storeTypeSelected - $serverTypeSelected',
                      style: AppTextStyles.small, // Shared small style
                    ),
                    const SizedBox(height: AppDimens.screenPadding),

                    // Bloc handles state-based UI
                    // Bundle widgets that need state sharing together:
                    BlocBuilder<MyStringBloc, MyStringState>(
                      bloc: bloc,
                      builder: (context, state) {
                        // Determine loading state
                        final isLoading = state is MyStringLoadingState;

                        // Since all of these widgets are used to handle
                        // 'my_string', it's better to group them into a card:
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
                                // Widget that needs the state of another widget
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

                                // Buttons Row
                                Row(
                                  children: [
                                    // Widget that needs the state of another widget
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        // Added key for easier widget UI unit testing:
                                        key: const Key('updateFromUserButton'),
                                        // 'null' means the widget is disabled.
                                        onPressed: isLoading ? null : updateFromUser,
                                        icon: const Icon(Icons.person),
                                        label: const Text('Update from User'),
                                      ),
                                    ),

                                    const SizedBox(width: AppDimens.buttonSpacing),

                                    // Widget that needs the state of another widget
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        // Added key for easier widget UI unit testing:
                                        key: const Key('updateFromServerButton'),
                                        // 'null' means the widget is disabled.
                                        onPressed: isLoading ? null : updateFromServer,
                                        icon: const Icon(Icons.cloud_download),
                                        label: const Text('Update from Server'),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppDimens.screenPadding * 2),

                                // Widget that has a state that needs to be shared
                                // with other widgets.
                                // Handle all known states.
                                // In this declarative UI context, Dart does allow
                                // if/else statements as elements inside a widget list.
                                if (state is MyStringInitialState)
                                  Text(
                                    'Enter or load a string to begin',
                                    style: AppTextStyles.italicHint, // Shared italic style
                                  )
                                else if (state is MyStringLoadingState)
                                  const Center(child: CircularProgressIndicator())
                                else if (state is MyStringSuccessState) ...[
                                    Text(
                                      'Current Value:',
                                      style: AppTextStyles.medium, // Shared medium style
                                    ),
                                    Text(
                                      state.value,
                                      style: AppTextStyles.large, // Shared large style
                                    ),
                                  ]
                                  else if (state is MyStringErrorState)
                                      Text(
                                        'Error: ${state.message}',
                                        style: AppTextStyles.error, // Shared error style
                                      )
                                    else
                                      // Optional fallback for unexpected states
                                      const SizedBox.shrink(), // Fallback empty widget
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

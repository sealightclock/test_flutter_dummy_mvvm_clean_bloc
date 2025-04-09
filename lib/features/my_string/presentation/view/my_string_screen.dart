import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/result.dart';
import '../../../../util/result_handler.dart';
import '../../data/di/my_string_dependency_injection.dart';
import '../../domain/entity/my_string_entity.dart';
import '../bloc/my_string_bloc.dart';
import '../factory/my_string_viewmodel_factory.dart';
import '../theme/app_styles.dart';
import '../viewmodel/my_string_viewmodel.dart';

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

/// For testing: expose the class
/// This State class now listens to App Lifecycle events (e.g., paused, resumed).
class MyStringScreenState extends State<MyStringScreen> with WidgetsBindingObserver {
  late final MyStringViewModel viewModel;
  late final MyStringBloc bloc; // Bloc instance (for widget tests only)

  // Controller for TextField input
  final TextEditingController textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Initialize ViewModel (injected for tests or created normally)
    viewModel = widget.injectedViewModel ?? createViewModel();

    // Initialize Bloc (injected for tests or created normally)
    bloc = widget.injectedBloc ?? MyStringBloc();

    // Load initial value from local store into UI
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

  @override
  void dispose() {
    // Unregister lifecycle observer
    WidgetsBinding.instance.removeObserver(this);

    textEditController.dispose();
    super.dispose();
  }

  /// Automatically reacts to app lifecycle changes (e.g., paused, resumed).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveCurrentText();
    }
  }

  /// Saves the current TextField value into local storage (optimistic save).
  void _saveCurrentText() {
    final text = textEditController.text.trim();
    if (text.isNotEmpty) {
      viewModel.storeMyStringToLocal(text);
    }
  }

  /// Handles "Update from User" button click.
  void updateFromUser() async {
    final newValue = textEditController.text.trim();
    final previousState = context.read<MyStringBloc>().state;

    // Optimistically update UI
    context.read<MyStringBloc>().add(UpdateMyStringFromUserEvent(newValue));

    await handleResult<void>(
      viewModel.storeMyStringToLocal(newValue),
      onSuccess: (_) {
        textEditController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated from User')),
        );
      },
      onFailure: (message) {
        // Rollback UI if save failed
        if (previousState is MyStringSuccessState) {
          context.read<MyStringBloc>().add(UpdateMyStringFromUserEvent(previousState.value));
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $message')),
        );
      },
    );
  }

  /// Handles "Update from Server" button click.
  void updateFromServer() async {
    Future<String> fetchAndStore() async {
      final result = await viewModel.getMyStringFromRemote();

      final value = await handleResultReturning<MyStringEntity, String>(
        Future.value(result),
        onSuccess: (data) => data.value,
        onFailure: (message) => 'Error fetching from server: $message',
      );

      if (!value.startsWith('Error')) {
        await viewModel.storeMyStringToLocal(value);
      }

      return value;
    }

    final event = UpdateMyStringFromServerEvent(fetchAndStore);

    context.read<MyStringBloc>().add(event);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fetching from Server...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyStringBloc>.value(
      value: bloc,
      child: Scaffold(
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
                      Text(
                        '$storeTypeSelected - $serverTypeSelected',
                        style: AppTextStyles.small,
                      ),
                      const SizedBox(height: AppDimens.screenPadding),

                      BlocBuilder<MyStringBloc, MyStringState>(
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
                                        const SizedBox.shrink(),
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
      ),
    );
  }
}

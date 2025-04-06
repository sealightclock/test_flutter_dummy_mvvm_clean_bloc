import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel.dart';

import '../../data/di/my_string_dependency_injection.dart';
import '../../domain/entity/my_string_entity.dart';
import '../../util/result.dart';
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
  State<MyStringHomeScreen> createState() => _MyStringHomeScreenState();
}

class _MyStringHomeScreenState extends State<MyStringHomeScreen> {
  // Bloc to manage state.
  late final MyStringBloc bloc;

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

    // Step 1: Save to local store first
    final result = await viewModel.storeMyStringToLocal(value);

    switch (result) {
      case Success():
      // Step 2: Only after successful saving, update Bloc
        bloc.add(UpdateMyStringFromUserEvent(value));

        textEditController.clear(); // Clear after successful submission

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated from User')),
        );
        break;
      case Failure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $message')),
        );
        break;
    }
  }

  /// Handles user requesting a string from server:
  /// [1] Fetch string from server.
  /// [2] Save string to local store.
  /// [3] Update Bloc state.
  void updateFromServer() async {
    Future<String> fetchAndStore() async {
      final result = await viewModel.getMyStringFromRemote();
      switch (result) {
        case Success<MyStringEntity>(:final data):
          await viewModel.storeMyStringToLocal(data.value);
          return data.value;
        case Failure<MyStringEntity>(:final message):
          return 'Error fetching from server: $message';
      }
    }

    final event = UpdateMyStringFromServerEvent(fetchAndStore);
    bloc.add(event);

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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Display selected DI choices
                    Text(
                      '$storeTypeSelected - $serverTypeSelected',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),

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
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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

                                const SizedBox(height: 16),

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

                                    const SizedBox(width: 12),

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

                                const SizedBox(height: 32),

                                // Widget that has a state that needs to be shared
                                // with other widgets.
                                // Handle all known states.
                                // In this declarative UI context, Dart does allow
                                // if/else statements as elements inside a widget list.
                                if (state is MyStringInitialState)
                                  const Text(
                                    'Enter or load a string to begin', // Or any default UI
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  )
                                else if (state is MyStringLoadingState)
                                  const Center(child: CircularProgressIndicator())
                                else if (state is MyStringSuccessState) ...[
                                    Text(
                                      'Current Value:',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      state.value,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]
                                  else if (state is MyStringErrorState)
                                      Text(
                                        'Error: ${state.message}',
                                        style: const TextStyle(color: Colors.red),
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

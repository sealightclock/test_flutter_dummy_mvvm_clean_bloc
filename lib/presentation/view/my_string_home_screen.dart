import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel.dart';

import '../../data/di/my_string_dependency_injection.dart';
import '../factory/my_string_viewmodel_factory.dart';

class MyStringHomeScreen extends StatefulWidget {
  const MyStringHomeScreen({super.key});

  @override
  State<MyStringHomeScreen> createState() => _MyStringHomeScreenState();
}

class _MyStringHomeScreenState extends State<MyStringHomeScreen> {
  // Bloc to manage state.
  late final MyStringBloc bloc;

  // ViewModel to communicate with Use Cases.
  late final MyStringViewModel viewModel;

  // This is to control the TextField:
  final TextEditingController textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Create Bloc
    bloc = MyStringBloc();

    // Create ViewModel
    viewModel = createViewModel();

    // At app launch, we want to load the value from the local store.
    // [1] Get the value from the local store, then:
    // [2]   Load the value into the state.
    // [3]   Clear the TextField
    //
    // You can see that ViewModel and Bloc work together:
    // - ViewModel communicates with the Domain layer (Use Cases).
    // - Bloc communicates with the View layer (UI) via events and states.
    viewModel.getMyStringFromLocal().then((value) {
      bloc.add(UpdateMyStringFromLocalEvent(value));
      textEditController.clear();
    });
  }

  /// When the user submits the string, we want to:
  /// [1] Get the value from the TextField.
  /// [2] Load the value into the state.
  /// [3] Store the value into the local store.
  /// [4] Clear the TextField.
  // You can see that ViewModel and Bloc work together:
  // - ViewModel communicates with the Domain layer (Use Cases).
  // - Bloc communicates with the View layer (UI) via events and states
  void updateFromUser() {
    final value = textEditController.text.trim();
    bloc.add(UpdateMyStringFromUserEvent(value));
    viewModel.storeMyStringToLocal(value);
    textEditController.clear(); // Clear after submission
  }

  /// When the user requests the string from the server, we want to:
  /// [1] Load the value into the state, but wait until:
  /// [2]   Get the value from the server.
  /// [3]   Store the value into the local store.
  // You can see that ViewModel and Bloc work together:
  // - ViewModel communicates with the Domain layer (Use Cases).
  // - Bloc communicates with the View layer (UI) via events and states
  void updateFromServer() async {
    // Step 1: Define the async callback that fetches from the server and saves locally
    Future<String> fetchAndStore() async {
      final String valueFromServer = await viewModel.getMyStringFromRemote();
      viewModel.storeMyStringToLocal(valueFromServer);
      return valueFromServer;
    }

    // Step 2: Build the event using the callback
    final MyStringEvent event = UpdateMyStringFromServerEvent(fetchAndStore);

    // Step 3: Add the event to the bloc
    bloc.add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter MVVM Clean + Bloc')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Display DI choices:
                Text('$storeTypeSelected - $serverTypeSelected'),

                // Boundle widgets that need state sharing together:
                BlocBuilder<MyStringBloc, MyStringState>(
                  bloc: bloc,
                  builder: (context, state) {
                    // Loading state: disable all widgets that may further
                    // change the data:
                    final isLoading = state is MyStringLoadingState;

                    return Column(
                      children: [
                        // Widget that needs the state of another widget
                        TextField(
                          enabled: !isLoading,
                          controller: textEditController,
                          decoration: const InputDecoration(labelText: 'Enter string'),
                          onEditingComplete: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              updateFromUser();
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Widget that needs the state of another widget
                        ElevatedButton(
                          // 'null' means the widget is disabled.
                          onPressed: isLoading ? null : updateFromUser,
                          child: const Text('Update from User'),
                        ),

                        const SizedBox(height: 16),

                        // Widget that needs the state of another widget
                        ElevatedButton(
                          onPressed: isLoading ? null : updateFromServer,
                          child: const Text('Update from Server'),
                        ),

                        const SizedBox(height: 32),

                        // Widget that has a state that needs to be shared
                        // with other widgets.
                        // Handle all known states.
                        // In this declarative UI context, Dart does allow
                        // if/else statements as elements inside a widget list.
                        if (state is MyStringInitialState)
                          const Text('Enter or load a string to begin') // Or any default UI
                        else if (state is MyStringLoadingState)
                          const CircularProgressIndicator()
                        else if (state is MyStringLoadedState)
                          Text(
                            'Value:\n${state.value}',
                            style: const TextStyle(fontSize: 18),
                          )
                        else if (state is MyStringErrorState)
                          Text(
                            'Error:\n${state.message}',
                            style: const TextStyle(color: Colors.red),
                          )
                        else
                          // Optional fallback for unexpected states
                          const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


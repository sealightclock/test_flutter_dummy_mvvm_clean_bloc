import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel.dart';

import '../../data/di/my_string_dependency_injection.dart';
import '../../data/repository/my_string_repository_impl.dart';
import '../../domain/usecase/local/get_my_string_from_local_use_case.dart';
import '../../domain/usecase/local/store_my_string_to_local_use_case.dart';
import '../../domain/usecase/remote/get_my_string_from_remote_use_case.dart';

class MyStringHomeScreen extends StatefulWidget {
  const MyStringHomeScreen({super.key});

  @override
  State<MyStringHomeScreen> createState() => _MyStringHomeScreenState();
}

class _MyStringHomeScreenState extends State<MyStringHomeScreen> {
  late final MyStringViewModel _viewModel;
  late final MyStringBloc _bloc;
  // This is to control the TextField:
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Create Bloc
    _bloc = MyStringBloc();

    // Create ViewModel
    _viewModel = _createViewModel();

    // At app launch, we want to load the value from the local store.
    // [1] Get the value from the local store, then:
    // [2]   Load the value into the state.
    // [3]   Clear the TextField
    _viewModel.getMyStringFromLocal().then((value) {
      _bloc.add(UpdateMyStringFromUser(value));
      _controller.clear();
    });
  }

  /// This creates the ViewModel from ground up:
  /// Data Sources -> Repository -> Use Cases -> ViewModel
  MyStringViewModel _createViewModel() {
    // Create Data Sources using DI
    final localDataSource = createLocalDataSource(storeTypeSelected);
    final remoteDataSource = createRemoteDataSource(serverTypeSelected);

    // Create Repository
    final repository = MyStringRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    // Create Use Cases
    final getLocalUseCase = GetMyStringFromLocalUseCase(repository: repository);
    final storeLocalUseCase = StoreMyStringToLocalUseCase(repository: repository);
    final getRemoteUseCase = GetMyStringFromRemoteUseCase(repository: repository);

    // Finally, create ViewModel
    return MyStringViewModel(
      getLocalUseCase: getLocalUseCase,
      storeLocalUseCase: storeLocalUseCase,
      getRemoteUseCase: getRemoteUseCase,
    );
  }

  /// When the user submits the string, we want to:
  /// [1] Get the value from the TextField.
  /// [2] Load the value into the state.
  /// [3] Store the value into the local store.
  /// [4] Clear the TextField.
  void _updateFromUser() {
    final value = _controller.text.trim();
    _bloc.add(UpdateMyStringFromUser(value));
    _viewModel.storeMyStringToLocal(value);
    _controller.clear(); // Clear after submission
  }

  /// When the user requests the string from the server, we want to:
  /// [1] Load the value into the state, but wait until:
  /// [2]   Get the value from the server.
  /// [3]   Store the value into the local store.
  void _updateFromServer() {
    _bloc.add(UpdateMyStringFromServer(() async {
      final value = await _viewModel.getMyStringFromRemote();
      _viewModel.storeMyStringToLocal(value);
      return value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('test_flutter_dummy_mvvm_clean_bloc')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Display DI choices:
                Text('$storeTypeSelected - $serverTypeSelected'),

                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Enter string'),
                  onEditingComplete: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _updateFromUser();
                    });
                  }, // Keyboard submit
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _updateFromUser,
                  child: const Text('Update from User'),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _updateFromServer,
                  child: const Text('Update from Server'),
                ),

                const SizedBox(height: 32),

                BlocBuilder<MyStringBloc, MyStringState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is MyStringLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is MyStringLoaded) {
                      return Text('Value:\n${state.value}', style: const
                      TextStyle(fontSize: 18));
                    } else if (state is MyStringError) {
                      return Text('Error:\n${state.message}', style: const
                      TextStyle(color: Colors.red));
                    }
                    return const Text('Enter or load a string to begin');
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

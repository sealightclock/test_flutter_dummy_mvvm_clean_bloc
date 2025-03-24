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
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Create ViewModel using DI
    final localDataSource = createLocalDataSource(storeTypeSelected);
    final remoteDataSource = createRemoteDataSource(serverTypeSelected);

    final repository = MyStringRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    final getLocalUseCase = GetMyStringFromLocalUseCase(repository);
    final storeLocalUseCase = StoreMyStringToLocalUseCase(repository);
    final getRemoteUseCase = GetMyStringFromRemoteUseCase(repository: repository);

    _viewModel = MyStringViewModel(
      getLocalUseCase: getLocalUseCase,
      storeLocalUseCase: storeLocalUseCase,
      getRemoteUseCase: getRemoteUseCase,
    );

    _bloc = MyStringBloc();

    _viewModel.getMyStringFromLocal().then((value) {
      // Show the saved value in the state, but leave the input field empty
      _controller.clear();
      _bloc.add(UpdateMyStringFromUser(value));
    });
  }

  void _updateFromUser() {
    final value = _controller.text.trim();

    _bloc.add(UpdateMyStringFromUser(value));
    _viewModel.storeMyStringToLocal(value);
    _controller.clear(); // Clear after submission
  }

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
                  onSubmitted: (_) => _updateFromUser(), // Keyboard submit clears as well
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

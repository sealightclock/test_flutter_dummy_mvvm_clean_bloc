import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/get_my_string_from_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/store_my_string_to_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/remote/get_my_string_from_remote_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/intent/my_string_intent.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel_intent.dart';

import '../../data/di/my_string_dependency_injection.dart';
import '../../data/repository/my_string_repository_impl.dart';

class MyStringHomeScreen extends StatefulWidget {
  const MyStringHomeScreen({super.key}); // Fix: Added key parameter to avoid
  // a warning about a named 'key' parameter

  @override
  MyStringHomeScreenState createState() => MyStringHomeScreenState();
}

class MyStringHomeScreenState extends State<MyStringHomeScreen> {
  late MyStringViewModel viewModel;
  late TextEditingController _controller;
  bool _isDataLoaded = false; // Ensures UI updates after data loads

  @override
  void initState() {
    super.initState();

    final localDataSource = createLocalDataSource(storeTypeSelected);
    final remoteDataSource = createRemoteDataSource(serverTypeSelected);

    final repository = MyStringRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    final getLocalUseCase = GetMyStringFromLocalUseCase(repository);
    final storeLocalUseCase = StoreMyStringToLocalUseCase(repository);
    final getRemoteUseCase = GetMyStringFromRemoteUseCase(repository: repository);

    viewModel = MyStringViewModel(
      getLocalUseCase: getLocalUseCase,
      storeLocalUseCase: storeLocalUseCase,
      getRemoteUseCase: getRemoteUseCase,
    );

    _controller = TextEditingController();

    /// Ensure UI updates properly after data loads
    viewModel.loadInitialValue().then((_) {
      setState(() {
        _isDataLoaded = true;
        // Clear controller text for immediate use:
        _controller.clear();
      });
    });
  }

  /// Handles updating value from user input.
  void _handleUserUpdate() {
    setState(() {
      viewModel.handleIntent(UpdateFromUserIntent(_controller.text));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Flutter App with MVI')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isDataLoaded
              ? Column(
            children: [
              Text('$storeTypeSelected - $serverTypeSelected'),

              TextField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Enter value'),
                onSubmitted: (value) => _handleUserUpdate(), // 👈 Handles Return key
              ),

              ElevatedButton(
                onPressed: _handleUserUpdate,
                child: const Text('Update from User'),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    viewModel.handleIntent(UpdateFromServerIntent()).then((_) {
                      setState(() {});
                    });
                  });
                },
                child: viewModel.isLoadingDataFromRemoteServer
                    ? const CircularProgressIndicator()
                    : const Text('Update from Server'),
              ),

              const SizedBox(height: 20),

              Text(
                'Current Value:\n${viewModel.myString}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          )
              : const Center(child: CircularProgressIndicator()), // Show loading only initially
        ),
      ),
    );
  }
}

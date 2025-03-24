import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/view/my_string_home_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel.dart';

import 'data/di/my_string_dependency_injection.dart';
import 'data/repository/my_string_repository_impl.dart';
import 'domain/usecase/local/get_my_string_from_local_use_case.dart';
import 'domain/usecase/local/store_my_string_to_local_use_case.dart';
import 'domain/usecase/remote/get_my_string_from_remote_use_case.dart';

void main() {
  final localDataSource = createLocalDataSource(storeTypeSelected);
  final remoteDataSource = createRemoteDataSource(serverTypeSelected);

  final repository = MyStringRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  final getLocalUseCase = GetMyStringFromLocalUseCase(repository);
  final storeLocalUseCase = StoreMyStringToLocalUseCase(repository);
  final getRemoteUseCase = GetMyStringFromRemoteUseCase(repository: repository);

  final viewModel = MyStringViewModel(
    getLocalUseCase: getLocalUseCase,
    storeLocalUseCase: storeLocalUseCase,
    getRemoteUseCase: getRemoteUseCase,
  );

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final dynamic viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Clean + Bloc Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: MyStringHomeScreen(viewModel: viewModel),
    );
  }
}

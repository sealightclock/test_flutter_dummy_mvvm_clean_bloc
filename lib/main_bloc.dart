import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/data/di/my_string_dependency_injection.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/get_my_string_from_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/store_my_string_to_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/remote/get_my_string_from_remote_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/view/my_string_home_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel.dart';

void main() {
  final repository = MyStringDependencyInjection.provideRepository();

  final viewModel = MyStringViewModel(
    getLocalUseCase: GetMyStringFromLocalUseCase(repository),
    storeLocalUseCase: StoreMyStringToLocalUseCase(repository),
    getRemoteUseCase: GetMyStringFromRemoteUseCase(repository),
  );

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final MyStringViewModel viewModel;

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

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
  final MyStringViewModel viewModel;

  const MyStringHomeScreen({super.key, required this.viewModel});

  @override
  State<MyStringHomeScreen> createState() => _MyStringHomeScreenState();
}

class _MyStringHomeScreenState extends State<MyStringHomeScreen> {
  late MyStringViewModel viewModel;
  late final MyStringBloc _bloc;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = MyStringBloc();

    widget.viewModel.loadMyStringFromLocal().then((value) {
      _controller.text = value;
      _bloc.add(UpdateMyStringFromUser(value));
    });
  }

  void _updateFromUser() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) {
      _bloc.add(UpdateMyStringFromUser(value));
      widget.viewModel.saveMyStringToLocal(value);
    }
  }

  void _updateFromServer() {
    _bloc.add(UpdateMyStringFromServer(() async {
      final value = await widget.viewModel.fetchMyStringFromRemote();
      widget.viewModel.saveMyStringToLocal(value);
      return value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My String Manager')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Enter string'),
                  onSubmitted: (_) => _updateFromUser(),
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
                      return Text('Value: ${state.value}', style: const TextStyle(fontSize: 18));
                    } else if (state is MyStringError) {
                      return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
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

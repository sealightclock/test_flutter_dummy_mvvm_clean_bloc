import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../account/presentation/bloc/account_bloc.dart';
import '../../../account/presentation/bloc/account_event.dart';

/// Simple Account screen with Logout functionality using Bloc
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _logout(BuildContext context) {
    final accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(const AccountLogoutRequestedEvent());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => AccountBloc(authBloc: BlocProvider.of<AuthBloc>(context)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: Center(
          child: ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
      ),
    );
  }
}

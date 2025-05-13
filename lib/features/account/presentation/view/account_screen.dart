import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/util/enums/feedback_type_enum.dart';
import '../../../../app/util/feedback/global_feedback_handler.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';

/// Top-level AccountScreen widget that provides AccountBloc
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => AccountBloc(authBloc: BlocProvider.of<AuthBloc>(context)),
      child: const AccountScreenBody(),
    );
  }
}

/// Actual Account Screen body with Logout button
class AccountScreenBody extends StatelessWidget {
  const AccountScreenBody({super.key});

  void _logout(BuildContext context) {
    final accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(const AccountLogoutEvent());

    showFeedback(context, 'Logged out successfully', FeedbackType.info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true, // ✅ Fixes left-alignment flicker during app launch
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ),
    );
  }
}

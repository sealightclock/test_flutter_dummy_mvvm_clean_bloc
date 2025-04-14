import 'package:equatable/equatable.dart';

/// Sealed class for Account states
sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

/// Initial state for Account screen
class AccountInitialState extends AccountState {
  const AccountInitialState();
}

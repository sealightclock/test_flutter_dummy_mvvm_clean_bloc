import 'package:equatable/equatable.dart';

/// Sealed class for Account events
sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

/// Event when user taps the Logout button
class AccountLogoutRequestedEvent extends AccountEvent {
  const AccountLogoutRequestedEvent();
}

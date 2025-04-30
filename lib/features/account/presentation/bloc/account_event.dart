/// Sealed class for Account events
sealed class AccountEvent {
  const AccountEvent();
}

/// Event when user taps the Logout button
class AccountLogoutRequestedEvent extends AccountEvent {
  const AccountLogoutRequestedEvent();
}

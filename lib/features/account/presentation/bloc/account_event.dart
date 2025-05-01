/// Sealed class for Account events
sealed class AccountEvent {
  const AccountEvent();
}

/// Event when user taps the Logout button
class AccountLogoutEvent extends AccountEvent {
  const AccountLogoutEvent();
}

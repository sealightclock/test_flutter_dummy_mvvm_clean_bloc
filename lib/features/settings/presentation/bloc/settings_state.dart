import 'package:equatable/equatable.dart';
import '../../domain/entity/settings_entity.dart';

/// All possible states for the Settings feature.
///
/// This includes:
/// - Initial: before settings are loaded
/// - Loaded: settings loaded successfully
/// - Error: something went wrong
sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// State before any settings are loaded (used briefly on app start)
class SettingsInitial extends SettingsState {}

/// State when settings have been successfully loaded or updated
class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// State when there was a failure loading or saving settings
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

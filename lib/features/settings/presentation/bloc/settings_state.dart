import 'package:equatable/equatable.dart';
import '../../domain/entity/settings_entity.dart';

/// All possible states for the Settings feature.
///
/// This includes:
/// - Initial: before settings are loaded
/// - LoadedOrUpdated: settings loaded/updated successfully
/// - Error: something went wrong
sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// State before any settings are loaded (used briefly on app start)
class SettingsInitialState extends SettingsState {}

/// State when settings have been successfully loaded or updated
class SettingsLoadedOrUpdatedState extends SettingsState {
  final SettingsEntity settings;

  const SettingsLoadedOrUpdatedState(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// State when there was a failure loading or saving settings
class SettingsErrorState extends SettingsState {
  final String message;

  const SettingsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

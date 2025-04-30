import '../../domain/entity/settings_entity.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

class SettingsLoadEvent extends SettingsEvent {}

class SettingsUpdateEvent extends SettingsEvent {
  final SettingsEntity newSettings;
  const SettingsUpdateEvent(this.newSettings);
}

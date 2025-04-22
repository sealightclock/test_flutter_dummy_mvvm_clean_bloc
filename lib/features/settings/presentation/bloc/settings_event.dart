import 'package:equatable/equatable.dart';
import '../../domain/entity/settings_entity.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsLoadEvent extends SettingsEvent {}

class SettingsUpdateEvent extends SettingsEvent {
  final SettingsEntity newSettings;
  const SettingsUpdateEvent(this.newSettings);
  @override
  List<Object?> get props => [newSettings];
}

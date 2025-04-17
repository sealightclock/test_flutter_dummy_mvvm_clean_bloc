import 'package:equatable/equatable.dart';
import '../../domain/entity/settings_entity.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateSettingsEvent extends SettingsEvent {
  final SettingsEntity newSettings;
  const UpdateSettingsEvent(this.newSettings);
  @override
  List<Object?> get props => [newSettings];
}

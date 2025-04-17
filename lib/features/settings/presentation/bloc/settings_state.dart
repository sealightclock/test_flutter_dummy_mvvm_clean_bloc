import 'package:equatable/equatable.dart';
import '../../domain/entity/settings_entity.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;
  const SettingsLoaded(this.settings);
  @override
  List<Object?> get props => [settings];
}

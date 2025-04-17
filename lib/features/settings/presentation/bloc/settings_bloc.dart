import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../factory/settings_viewmodel_factory.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final viewModel = SettingsViewModelFactory.create();

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingsEvent>((event, emit) async {
      final settings = await viewModel.getSettings();
      emit(SettingsLoaded(settings));
    });

    on<UpdateSettingsEvent>((event, emit) async {
      await viewModel.saveSettings(event.newSettings);
      emit(SettingsLoaded(event.newSettings));
    });
  }
}

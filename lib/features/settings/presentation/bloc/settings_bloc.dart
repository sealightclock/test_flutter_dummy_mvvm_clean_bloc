import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../factory/settings_viewmodel_factory.dart';

/// Bloc class to manage Settings feature logic and state.
///
/// It communicates with ViewModel to load and update settings from Hive.
/// Emits [SettingsLoaded] state with new values to update the UI.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // Use late-initialized ViewModel created via factory
  late final viewModel = SettingsViewModelFactory.create();

  SettingsBloc() : super(SettingsInitial()) {
    // Load settings from Hive on app launch
    on<LoadSettingsEvent>((event, emit) async {
      final settings = await viewModel.getSettings();
      emit(SettingsLoaded(settings));
    });

    on<UpdateSettingsEvent>((event, emit) async {
      await viewModel.saveSettings(event.newSettings);
      emit(SettingsLoaded(event.newSettings));

      // 👇 Force full app rebuild after saving new settings
      await Future.delayed(Duration(milliseconds: 300));
      restartApp();
    });
  }
}

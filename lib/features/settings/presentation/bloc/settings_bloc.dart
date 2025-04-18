import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart'; // Needed for restartApp() global method
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../factory/settings_viewmodel_factory.dart';

/// Bloc class to manage Settings feature logic and state.
///
/// This handles both:
/// 1. Loading user settings from Hive (e.g., on app launch)
/// 2. Updating settings when user interacts with the Settings screen
///
/// It uses a ViewModel that encapsulates business logic and Hive storage.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // Create the ViewModel using a factory (which handles DI setup)
  late final viewModel = SettingsViewModelFactory.create();

  SettingsBloc() : super(SettingsInitial()) {
    // ----------------------------------------------------------------------------
    // EVENT: LoadSettingsEvent
    //
    // Triggers on app start. Loads current settings from Hive and emits them.
    // ----------------------------------------------------------------------------
    on<LoadSettingsEvent>((event, emit) async {
      final settings = await viewModel.getSettings();
      emit(SettingsLoaded(settings)); // Success: update UI with loaded settings
    });

    // ----------------------------------------------------------------------------
    // EVENT: UpdateSettingsEvent
    //
    // Triggers when user changes dark mode or font size.
    // Saves new settings to Hive, then emits updated state.
    //
    // EXTRA: We force a full app rebuild to apply theme/font changes immediately.
    // This is a workaround until Flutter supports partial rebuild of MaterialApp.
    // ----------------------------------------------------------------------------
    on<UpdateSettingsEvent>((event, emit) async {
      await viewModel.saveSettings(event.newSettings); // Save to Hive
      emit(SettingsLoaded(event.newSettings));         // Emit new state to UI

      // --------------------------------------------------------------------------
      // Force full app rebuild to apply new theme settings
      // --------------------------------------------------------------------------
      await Future.delayed(Duration(milliseconds: 300)); // UX: Slight delay for save
      restartApp(); // Calls method in main.dart via global key to rebuild app root
    });
  }
}

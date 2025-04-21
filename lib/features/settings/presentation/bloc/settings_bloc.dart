import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart'; // Needed for triggerAppRebuild()
import '../../../../util/result.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../factory/settings_viewmodel_factory.dart';

/// BLoC that manages app settings such as dark mode and font size.
///
/// It loads initial settings from Hive and handles user-triggered updates.
/// After saving new settings, it triggers a UI rebuild using [triggerAppRebuild].
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // ViewModel encapsulates logic and uses Result for safe error handling
  late final viewModel = SettingsViewModelFactory.create();

  SettingsBloc() : super(SettingsInitial()) {
    // System event: Load settings from local store (Hive)
    on<LoadSettingsEvent>((event, emit) async {
      final result = await viewModel.getSettings();
      switch (result) {
        case Success(:final data):
          emit(SettingsLoaded(data)); // Show loaded settings
        case Failure(:final message):
          emit(SettingsError('Failed to load settings: $message'));
      }
    });

    // User event: Save new settings and refresh UI immediately
    on<UpdateSettingsEvent>((event, emit) async {
      final result = await viewModel.saveSettings(event.newSettings);
      switch (result) {
        case Success():
          emit(SettingsLoaded(event.newSettings)); // Update UI immediately
          await Future.delayed(const Duration(milliseconds: 300));
          triggerAppRebuild(); // Trigger theme/font rebuild
        case Failure(:final message):
          emit(SettingsError('Failed to save settings: $message'));
      }
    });
  }
}

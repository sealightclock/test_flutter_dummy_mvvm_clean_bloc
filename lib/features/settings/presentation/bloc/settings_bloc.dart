import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart'; // Needed for triggerAppRebuild()
import '../../../../util/result.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../factory/settings_viewmodel_factory.dart';
import '../viewmodel/settings_viewmodel.dart';

/// BLoC that manages app settings such as dark mode and font size.
///
/// It loads initial settings from Hive and handles user-triggered updates.
/// After saving new settings, it triggers a UI rebuild using [triggerAppRebuild].
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // ViewModel encapsulates logic and uses Result for safe error handling
  late SettingsViewModel viewModel;

  SettingsBloc() : super(SettingsInitialState()) {
    viewModel = SettingsViewModelFactory.create();

    on<SettingsEvent>((event, emit) async {
      switch (event) {
        case SettingsLoadEvent():
        // System event: Load settings from local store (Hive)
          final result = await viewModel.getSettings();

          switch (result) {
            case Success(:final data):
              emit(SettingsLoadedOrUpdatedState(data)); // Show loaded settings
              break;

            case Failure(:final message):
              emit(SettingsErrorState('Failed to load settings: $message'));
              break;
          }
          break;

        case SettingsUpdateEvent():
        // User event: Save new settings and refresh UI immediately
          final result = await viewModel.saveSettings(event.newSettings);
          switch (result) {
            case Success():
              emit(SettingsLoadedOrUpdatedState(event.newSettings)); // Update UI
              // immediately
              await Future.delayed(const Duration(milliseconds: 300));
              triggerAppRebuild(); // Trigger theme/font rebuild
              break;

            case Failure(:final message):
              emit(SettingsErrorState('Failed to save settings: $message'));
              break;
          }
          break;
      }
    });
  }
}

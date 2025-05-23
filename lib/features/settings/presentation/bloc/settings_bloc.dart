import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/result.dart';
import '../../../../main.dart'; // TODO: This is anti-pattern: Feature code
// should not depend on main.dart.
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../viewmodel/settings_viewmodel_factory.dart';
import '../viewmodel/settings_viewmodel.dart';

/// BLoC that manages core settings such as dark mode and font size.
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
            case Success(data: final settings):
              if (state is! SettingsLoadedOrUpdatedState ||
                  (state as SettingsLoadedOrUpdatedState).settings != settings) {
                emit(SettingsLoadedOrUpdatedState(settings));
              }
              break;

            case Failure(:final message):
              if (state is! SettingsErrorState ||
                  (state as SettingsErrorState).message != message) {
                emit(SettingsErrorState('Failed to load settings: $message'));
              }
              break;
          }
          break;

        case SettingsUpdateEvent():
        // User event: Save new settings and refresh UI immediately
          final result = await viewModel.saveSettings(event.settings);
          switch (result) {
            case Success():
              if (state is! SettingsLoadedOrUpdatedState ||
                  (state as SettingsLoadedOrUpdatedState).settings != event
                      .settings) {
                emit(SettingsLoadedOrUpdatedState(event.settings));
              }
              // immediately
              await Future.delayed(const Duration(milliseconds: 300));
              // TODO: This is anti-pattern: Feature code should not depend
              //  on main.dart.
              triggerAppRebuild(); // Trigger theme/font rebuild
              break;

            case Failure(:final message):
              if (state is! SettingsErrorState ||
                  (state as SettingsErrorState).message != message) {
                emit(SettingsErrorState('Failed to save settings: $message'));
              }
              break;
          }
          break;
      }
    });
  }
}

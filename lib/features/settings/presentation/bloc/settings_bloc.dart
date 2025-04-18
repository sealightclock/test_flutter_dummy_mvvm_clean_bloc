import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart'; // Needed for triggerAppRebuild()
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../factory/settings_viewmodel_factory.dart';

/// BLoC that manages app settings such as dark mode and font size.
///
/// It loads the initial settings from Hive, and handles user-triggered updates.
/// After any change, it triggers a UI rebuild via [triggerAppRebuild].
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final viewModel = SettingsViewModelFactory.create();

  SettingsBloc() : super(SettingsInitial()) {
    // System event: Load settings from Hive when the app starts
    on<LoadSettingsEvent>((event, emit) async {
      final settings = await viewModel.getSettings();
      emit(SettingsLoaded(settings));
    });

    // User event: Save new settings and refresh the UI immediately
    on<UpdateSettingsEvent>((event, emit) async {
      await viewModel.saveSettings(event.newSettings);
      emit(SettingsLoaded(event.newSettings));

      // Trigger rebuild to apply new theme or font size
      await Future.delayed(const Duration(milliseconds: 300));
      triggerAppRebuild();
    });
  }
}

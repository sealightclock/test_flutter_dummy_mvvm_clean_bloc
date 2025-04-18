import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../theme/app_styles.dart';
import '../../domain/entity/settings_entity.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(LoadSettingsEvent()),
      child: const SettingsScreenBody(),
    );
  }
}

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true, // ✅ Fixes left-alignment flicker during app launch
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return _buildSettingsForm(context, state.settings);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildSettingsForm(BuildContext context, SettingsEntity settings) {
    final bloc = BlocProvider.of<SettingsBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settings.darkMode,
            onChanged: (enabled) {
              final updated = settings.copyWith(darkMode: enabled);
              bloc.add(UpdateSettingsEvent(updated));
            },
          ),
          const SizedBox(height: 16),
          const Text('Font Size'),
          Row(
            children: [14.0, 16.0, 18.0].map((size) {
              return Expanded(
                child: RadioListTile<double>(
                  title: Text('${size.toInt()}'),
                  value: size,
                  groupValue: settings.fontSize,
                  onChanged: (value) {
                    final updated = settings.copyWith(fontSize: value);
                    bloc.add(UpdateSettingsEvent(updated));
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

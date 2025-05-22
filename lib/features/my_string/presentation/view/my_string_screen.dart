import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/feedback_type_enum.dart';
import '../../../../core/feedback/global_feedback_handler.dart';
import '../../../../core/result/result.dart';
import '../../../../core/result/result_handler.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/di/di_config.dart';
import '../../../../shared/enums/app_tab_enum.dart';
import '../bloc/my_string_bloc.dart';
import '../bloc/my_string_event.dart';
import '../bloc/my_string_state.dart';
import '../model/my_string_model.dart';

/// This screen demonstrates how to apply MVVM Clean + Bloc architecture
/// to manage a simple string stored locally and remotely.
class MyStringScreen extends StatelessWidget {
  // Allow injecting a custom Bloc for testing purposes only.
  final MyStringBloc? injectedBloc;

  const MyStringScreen({
    super.key,
    this.injectedBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyStringBloc>(
      create: (_) => injectedBloc ?? MyStringBloc(),
      child: const MyStringScreenBody(),
    );
  }
}

/// Actual screen body that interacts with the Bloc
class MyStringScreenBody extends StatefulWidget {
  const MyStringScreenBody({super.key});

  @override
  State<MyStringScreenBody> createState() => MyStringScreenBodyState();
}

class MyStringScreenBodyState extends State<MyStringScreenBody> with WidgetsBindingObserver {
  late MyStringBloc bloc;

  @visibleForTesting
  MyStringBloc get exposedBloc => bloc; // Exposed for widget testing if needed

  final TextEditingController textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    bloc = BlocProvider.of<MyStringBloc>(context);

    bloc.viewModel.getMyStringFromLocal().then((result) {
      switch (result) {
        case Success<MyStringModel>(:final data):
          bloc.add(MyStringUpdateFromLocalEvent(MyStringModel(value: data.value)));
          break;
        case Failure<MyStringModel>(:final message):
          bloc.add(MyStringUpdateFromLocalEvent(MyStringModel(value: 'Error loading: $message')));
          break;
      }
      textEditController.clear();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textEditController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveCurrentText();
    }
  }

  void _saveCurrentText() {
    final text = textEditController.text.trim();
    if (text.isNotEmpty) {
      bloc.viewModel.storeMyStringToLocal(MyStringModel(value: text));
    }
  }

  void updateFromUser() async {
    final newValue = textEditController.text.trim();
    final previousState = bloc.state;

    bloc.add(MyStringUpdateFromUserEvent(MyStringModel(value: newValue)));

    await handleResult<void>(
      futureResult: bloc.viewModel.storeMyStringToLocal(MyStringModel(value: newValue)),
      onSuccess: (_) {
        textEditController.clear();
      },
      onFailure: (message) {
        if (previousState is MyStringSuccessState) {
          bloc.add(MyStringUpdateFromUserEvent(previousState.value));
        }
        showFeedback(context, 'Failed to save: $message, rolling back.', FeedbackType.error);
      },
    );
  }

  void updateFromServer() async {
    Future<MyStringModel> fetchAndStore() async {
      final result = await bloc.viewModel.getMyStringFromRemote();

      final value = await handleResultReturning<MyStringModel, String>(
        futureResult: Future.value(result),
        onSuccess: (data) => data.value,
        onFailure: (message) => 'Error fetching from server: $message',
      );

      if (!value.startsWith('Error')) {
        await bloc.viewModel.storeMyStringToLocal(MyStringModel(value: value));
      }

      return MyStringModel(value: value);
    }

    bloc.add(MyStringUpdateFromServerEvent(fetchAndStore));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTab.myString.title),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;
          final maxContentWidth = isLandscape ? 500.0 : 600.0;
          final horizontalPadding = isLandscape ? AppDimens.screenPadding * 2 : AppDimens.screenPadding;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: AppDimens.screenPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: _buildBody(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<MyStringBloc, MyStringState>(
      builder: (context, state) {
        final isLoading = state is MyStringLoadingState;

        return Card(
          elevation: AppDimens.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.cardCornerRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppConstants.localStoragePrefix + DiConfig.localStore.label,
                    style: AppTextStyles.small),
                Text(AppConstants.remoteServerPrefix + DiConfig.remoteServer.label,
                    style: AppTextStyles.small),
                const Divider(height: 24),
                TextField(
                  enabled: !isLoading,
                  controller: textEditController,
                  decoration: const InputDecoration(
                    labelText: AppConstants.enterStringLabel,
                    border: OutlineInputBorder(),
                  ),
                  onEditingComplete: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      updateFromUser();
                    });
                  },
                ),
                const SizedBox(height: AppDimens.buttonSpacing),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        key: const Key('updateFromUserButton'),
                        onPressed: isLoading ? null : updateFromUser,
                        icon: const Icon(Icons.person),
                        label: const Text(AppConstants.updateFromUserLabel),
                      ),
                    ),
                    const SizedBox(width: AppDimens.buttonSpacing),
                    Expanded(
                      child: ElevatedButton.icon(
                        key: const Key('updateFromServerButton'),
                        onPressed: isLoading ? null : updateFromServer,
                        icon: const Icon(Icons.cloud_download),
                        label: const Text(AppConstants.updateFromServerLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.screenPadding * 2),

                // ─────────────────────────────────────────────────────────────
                // 🧠 State-based UI: render based on current MyStringState
                // ─────────────────────────────────────────────────────────────
                if (state is MyStringInitialState)
                  Text(AppConstants.initialHintText, style: AppTextStyles.italicHint)
                else
                  if (state is MyStringLoadingState)
                    const Center(child: CircularProgressIndicator())
                  else
                    if (state is MyStringSuccessState) ...[
                      Text(AppConstants.currentValueLabel, style: AppTextStyles.medium),

                      // ✅ Mark final value with a Key so it can be tested easily
                      Text(
                        state.value.value,
                        key: const Key('myStringDisplayText'), // 👈 Added Key
                        style: AppTextStyles.large,
                      ),
                    ]
                    else
                      if (state is MyStringErrorState)
                        Text('Error: ${state.message}', style: AppTextStyles.error)
                      else
                        const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}

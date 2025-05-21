# test_flutter_dummy_mvvm_clean_bloc

## Introduction

This is a dummy Flutter app built with the "MVVM Clean + Bloc" architecture, for testing and
learning purposes.

Initially, it handled a single string: 'my_string' in a single feature. More recently, it
handles more features that use the same "MVVM Clean + Bloc" architecture.

Refer to file "CONTRIBUTING.md" for guidelines for developing a Flutter app.

## Technologies used

This Flutter app uses the following technologies:

### Basic technologies

These are some of the latest technologies used in developing a multiplatform app:

- Flutter: for multiplatform app development.
- Dart: main programming language for Flutter app development.

### Specialized technologies

This Flutter app uses the following specialized technologies:

- MVVM Clean + Bloc: for clean architecture with Bloc for state management of each feature.
- SharedPreferences / Hive: for storing data locally to achieve data persistence.
- Dio / Http: for making HTTP requests to remote servers.

## UI/UX

The UI should be intuitive. 'my_string' can be modified by:

- user input
- backend server
- local storage at app launch

## Source file structure for "my_string" feature

The file structure for this "my_string" feature is as follows:

lib/

### features/my_string/

#### -- **presentation**/

---- **view**/

------ my_string_screen.dart

---- **bloc**/

------ my_string_bloc.dart

------ my_string_event.dart

------ my_string_state.dart

---- **viewmodel**/

------ my_string_viewmodel.dart

---- factory/

------ my_string_viewmodel_factory.dart

#### -- ***domain***/

---- **entity**/

------ my_string_entity.dart

---- **usecase**/

------ get_my_string_from_local_use_case.dart

------ store_my_string_to_local_use_case.dart

------ get_my_string_from_remote_use_case.dart

#### -- ***data***/

---- **repository**/

------ my_string_repository.dart

------ my_string_repository_impl.dart

---- **datasource**/

------ local/

-------- my_string_local_data_source.dart

-------- shared_prefs/

---------- my_string_shared_prefs_data_source.dart

-------- hive/

---------- my_string_hive_dto.dart

---------- my_string_hive_dto.g.dart (auto-generated for Hive adaptor)

---------- my_string_hive_data_source.dart

------ remote/

-------- my_string_remote_data_source.dart

-------- dio/

---------- my_string_dio_api.dart

---------- my_string_dio_data_source.dart

-------- http/

---------- my_string_http_api.dart

---------- my_string_http_data_source.dart

-------- simulator/

---------- my_string_simulator_data_source.dart

------ di/

-------- my_string_di.dart (for dependency injection)

(together with some additional files/directories that are not specific to the MVVM Clean + Bloc
architecture)

which reflects the chosen design pattern "MVVM Clean + Bloc".

## Testing

### Manual testing

This Flutter app needs to be tested on both Android and iOS devices with the following
combinations of configurations:

(Hive, SharedPreferences) x

(Http, Dio, Simulator) x

('Enter string', 'Update from User', 'Update from Server') x

(Screen rotation, App relaunch, App upgrade, App removal then reinstall)

It has been tested on Android devices (both physical and emulator ones).

It has been tested on iOS Simulators.

### Automated testing

The following tests have been created:

- Unit tests
- Widget tests
- Integration tests

#### Testability Infrastructure

The source code has been slightly modified to accommodate automated testing with widget and
integration tests. These additions are not for production features.

The "MVVM Clean + Bloc" architecture also helps to support unit testing.

## Scalability

With the "MVVM Clean + Bloc" architecture, it is relatively easy to add more features to the app.

More recently, more features have been added to the app to demonstrate the
scalability of this architecture.

All of these features, including:

- "auth"
- "my_string"
- "account"
- "settings"
- "ble"
- "vehicle_status"

have been implemented using the same "MVVM Clean + Bloc" design pattern and a similar file
structure. Some minor features may be implemented using a simplified version of the "MVVM Clean +
Bloc" architecture.

## Source file structure for "my_string" feature

The file structure for the entire app is as follows:

lib/

-- main.dart

-- app.dart

-- root_screen.dart

-- features/

-- shared/

-- core/

It also follows a layered structure:

main.dart -> app.dart -> root_screen.dart -> features/ -> shared/ -> core/.

The "shared" directory houses app-level shared code, such as constants.

The "core" directory contains core code that can be used even by outside apps, such as
Permission Manager. This is a candidate for a separate library.

This project is evolving based on our understanding of Flutter, especially of the "MVVM Clean +
Bloc" architecture.

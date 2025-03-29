# test_flutter_dummy_mvvm_clean_bloc

## Introduction
This is a dummy Flutter app built with the "MVVM Clean + Bloc" architecture, for testing and 
learning purposes.

It handles a single string: 'my_string'.

## Technologies used
This Flutter app uses the following technologies:

### Basic technologies
These are the latest technologies used in developing a multiplatform app:
- Flutter: for multiplatform app development
- Dart: main programming language for Flutter app development

### Specialized technologies
This Flutter app uses the following specialized technologies:
- MVVM Clean + Bloc: for clean architecture with Bloc for state management
- SharedPreferences / Hive: for storing data locally to achieve data persistence.
- Dio / Http: for making HTTP requests to remote servers

## UI/UX
The UI should be intuitive. 'my_string' can be modified by:
- the user input
- the backend server
- the local storage

## Source file structure
The file structure is as follows:

### -- **presentation**/

---- **view**/

------ my_string_home_screen.dart

---- **bloc**/ 

------ my_string_bloc.dart

------ my_string_event.dart

------ my_string_state.dart

---- **viewmodel**/

------ my_string_viewmodel.dart

---- factory/

------ my_string_viewmodel_factory.dart

### -- ***domain***/ 

---- **entity**/

------ my_string_entity.dart

------ my_string_entity.g.dart

---- **usecase**/

------ local/

-------- get_my_string_from_local_use_case.dart

-------- store_my_string_to_local_use_case.dart

------ remote/

-------- get_my_string_from_remote_use_case.dart

### -- ***data***/

---- **repository**/

------ my_string_repository.dart

------ my_string_repository_impl.dart

---- local/

------ my_string_local_data_source.dart

------ my_string_shared_prefs_data_source.dart

------ my_string_hive_data_source.dart

---- remote/

------ my_string_dio_api.dart

------ my_string_http_api.dart

------ my_string_remote_data_source.dart

------ my_string_simulator_data_source.dart

------ my_string_dio_data_source.dart

------ my_string_http_data_source.dart

---- **di**/

------ my_string_dependency_injection.dart

(together with some additional files/directories that are not specific to the MVVM Clean + Bloc 
architecture)

which reflects the chosen design pattern "MVVM Clean + Bloc".

## Testing
This Flutter app needs to be tested on both Android and iOS devices with the following 
combinations of configurations:

(Hive, SharedPreferences) x

(Http, Dio, Simulator) x

('Update from User', 'Update from Server') x

(Screen rotation, App relaunch, App upgrade, App removal then reinstall)

It has been tested on Android devices (both physical and emulator ones).

It will still need to be tested on iOS devices.


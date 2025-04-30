# Guidelines for Developing a Flutter App

## Introduction

This document lists some guidelines for developing a Flutter app, based on the MVVM Clean + Bloc 
architecture. Most of these guidelines will be grouped into the architecture's layers; some will 
be handled specifically.

Refer to file "README.md" for an example where these guidelines have been applied.

## Presentation Layer

The Presentation layer contains View, Bloc, and ViewModel.

### View

The View usually represents a screen.

#### [GUIDELINE] Screen class

A Screen class should not see ViewModel (except when mocking for testing) and its lower-level 
classes. It should only see Bloc-related classes.

When adding or refactoring screens, please follow:

[1] Small/simple screens (login, settings, etc.):

Use a single StatefulWidget.

Example: AuthScreen, AccountScreen.

[2] Feature/complex screens (expected to grow):

Create a StatelessWidget wrapper to provide Bloc.

Move the real logic into a StatefulWidget body.

Example: MyStringScreen + MyStringScreenBody, SettingsScreen + SettingsScreenBody.

Why: Cleaner separation of concerns, easier lifecycle management, and much easier widget testing.

Tip: Even if a screen starts small, prefer the split if you expect it to expand over time.

#### [GUIDELINE] User Feedback

Use the global feedback handler located at lib/util/global_feedback_handler.dart.

Always call:

`showFeedback(context, message, FeedbackType.type);`

Supported FeedbackType values:

•	error: For critical issues.

•	warning: For recoverable problems.

•	info: For normal user notifications.

This ensures consistent Snackbar behavior, styling, and UX across the app.

### Bloc

This layer contains Bloc, Event and State classes.

#### [GUIDELINE] Bloc class

A Bloc class should own ViewModel which handles business logic.

Use switch/case to handle all the events.

Bloc is a good place to check for app permissions (Internet, Bluetooth, Location, etc.).

#### [GUIDELINE] Event class

A base Event class should be sealed.

Typical events: Load, Update.

A derived Event class should be renamed <Feature><Specific>Event.

#### [GUIDELINE] State class

A base State class should be sealed and should extend Equatable for comparison purposes.

Typical states: Initial, Loading, Success (Loaded), Error.

A derived State class should be renamed <Feature><Specific>State.

### ViewModel

A ViewModel class should only see UseCase classes.

#### [GUIDELINE] ViewModelFactory
Use a factory to facilitate the creation of a ViewModel instance, as it's built in multiple 
steps, up from DataSource, Repository to UseCase.

ViewModel is a good place to request app permissions (Internet, Bluetooth, Location, etc.).

## Domain Layer

The Domain layer contains Entity and UseCase classes.

### Entity

The constructor of an Entity class should use named parameters to avoid confusion.

In general, an Entity class should have a Hive adapter whose code can be generated using 
bash command:

`flutter packages pub run build_runner build --delete-conflicting-outputs`

#### [GUIDELINE] Entity conversion

Some Entity classes may be used by all the (Presentation, Domain, Data) layers. However, different 
layers may have different versions of a same entity. Conversions of the entity 
between layers may be needed and should be done in the ViewModel or in the Repository.

### UseCase

A UseCase class should only see Repository classes.

Use call(), rather than execute(), to run a UseCase. This makes the UseCase class look like 
a function.

#### [GUIDELINE] Return value of a UseCase function

Wrap the return value of a UseCase function into a Result<T> class with Success or Failure so that 
the Presentation layer (View or Bloc) can handle the result easily.

## Data Layer

The Data layer contains Repository and DataSource classes.

### Repository

A Repository class should only see DataSource classes.

#### [GUIDELINE] Data processing for the Domain layer

Data processing for the Domain layer, such as throttling, should be done in the Repository class.

### DataSource

A DataSource class usually deal with one specific type, such as local storage, remote server, or 
testing/simulated data.

DataSource streams raw updates (as fast as they arrive). 

When using a package or API to access data, try to initialize it inside the DataSource class 
rather than in the main() or other top-level functions.

#### [GUIDELINE] Local storage

For local storage, prefer Hive over SharedPreferences and databases.

Consider one Hive Box per feature. Use a utility class for all the features to avoid code 
duplication (i.e., apply the DRY principle).

#### [GUIDELINE] Remote server

For remote server access, prefer Http over Dio and other packages.

## Special Handling

Some topics need special handling and will be addressed here.

### App Permissions

The handling of app permissions is challenging. Fortunately, it can also be fit into the 
MVVM Clean + Bloc architecture.

#### [GUIDELINE] Specify app permissions in AndroidManifest.xml or Info.plist.

Failure to do so may result in crashes or silent failures which are very hard to debug.

#### [GUIDELINE] Handle app permissions early.

In View, check whether required permissions have been granted before processing an event.

In ViewModel (and possibly in Bloc), request and grant app permissions if not yet done.

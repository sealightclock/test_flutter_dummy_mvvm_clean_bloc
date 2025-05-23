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

A Screen (View) class should not see ViewModel and its lower-level classes. It should only see
Bloc-related classes: View -> Bloc.

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

Use the global feedback handler in file "global_feedback_handler.dart".

Always call:

`showFeedback(context, message, FeedbackType.type);`

Supported FeedbackType values:

• error: For critical issues.

• warning: For recoverable problems.

• info: For normal user notifications.

This ensures consistent Snackbar behavior, styling, and UX across the app.

### Bloc

This layer contains Bloc, Event and State classes.

#### [GUIDELINE] Bloc class

A Bloc class should own ViewModel which handles business logic: Bloc -> ViewModel.

Use switch/case to handle all the events: Bloc -> Event -> State.

Do not emit a state if it's the same as the current state. This prevents unnecessary UI rebuilding.

#### [GUIDELINE] Event class

A base Event class should be sealed.

Typical events: Load (for read), Update (for write).

A derived Event class should be renamed <Feature><Specific>Event.

#### [GUIDELINE] State class

A base State class should be sealed and should extend Equatable for comparison purposes.

Typical states: Initial, Loading/Loaded, Updating/Updated, Success, Error.

A derived State class should be renamed <Feature><Specific>State.

### ViewModel

A ViewModel class should only see UseCase classes: ViewModel -> UseCase.

There should be a same number of ViewModel functions and UseCases.

#### [GUIDELINE] ViewModelFactory

Use a factory to facilitate the creation of a ViewModel instance, as it's built in multiple
steps, up from DataSource, Repository to UseCase.

## Domain Layer

The Domain layer contains Entity and UseCase classes.

### Entity

The constructor of an Entity class should use named parameters to avoid confusion.

In general, an Entity class should have a Hive adapter whose code can be generated using
bash command:

`flutter packages pub run build_runner build --delete-conflicting-outputs`

#### [GUIDELINE] Entity conversion between layers may be needed.

Some Entity classes may be used by all the (Presentation, Domain, Data) layers. However, different
layers may have different versions of a same entity. Conversions of the entity
between layers may be needed and should be done in the ViewModel or in the Repository. A 
proposed file structure for different Entity classes is as follows:

presentation/

-- model/

---- <feature>_model.dart

domain/

-- entity/

---- <feature_entity.dart

data/

-- dto/

---- <feature_dto.dart

### UseCase

A UseCase class should only see Repository classes: UseCase -> Repository.

Use call(), rather than execute(), to run a UseCase. This makes the UseCase class look like
a function.

#### [GUIDELINE] Return value of a UseCase function

In general, especially for a single-result operation, wrap the return value of a UseCase function
into a Result<T> class with Success<T> or Failure<String> so that the Presentation layer (View
or Bloc) can handle the result easily rather than having to deal with exceptions.

However, there are some exceptions to this guideline. For example, a Stream return value should
not be wrapped into Result<T>; instead, it should be returned as is so that the Presentation
layer can listen to the stream.

## Data Layer

The Data layer contains Repository and DataSource classes.

### Repository

A Repository class should only see DataSource classes: Repository -> DataSource.

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

### Top-level Functions

Try to build top-level functions as small as possible and follow the following flow:

main.dart: main() -> MyApp()

app.dart: MyApp() -> MaterialApp() -> RootScreen()

root_screen.dart: RootScreen() -> <Feature>Screen()

Set up the app's file structure as follows:

lib/

-- main.dart

-- app.dart

-- root_screen.dart

-- features/

-- shared/

-- core/

### App Permissions

The handling of app permissions is challenging: It is not a product feature, rather, it sits on
the framework layer so can not fit into any of the components of the MVVM Clean + Bloc architecture.

#### [GUIDELINE] Specify app permissions in AndroidManifest.xml and Info.plist.

Failure to do so may result in crashes or silent failures which are very hard to debug.

#### [GUIDELINE] Handle app permissions early.

In View, check whether required permissions have been granted before processing an event.

Use a centralized PermissionManager to handle app permissions, like a platform service. Plug
PermissionManager into ViewModel just like a special UseCase.

#### [GUIDELINE] Be careful when using package "permission_handler".

It has been noticed that, while package "permission_handler" is flexible, it will silently fail
on iOS Simulator when dealing with location permissions. Use "geolocator" package's own
permission API instead.

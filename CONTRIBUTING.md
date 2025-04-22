# Guidelines for Developing a Flutter App

This document lists some guidelines for developing a Flutter app, based on the MVVM Clean + Bloc 
architecture.

## Presentation Layer

### View

#### Screen class

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

#### User Feedback

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

#### Bloc class

A Bloc class should own ViewModel which handles business logic.

Use switch/case to handle all the events.

#### Event class

A base Event class should be sealed and should extend Equatable for comparison purposes.

Typical events: Load, Update.

A derived Event class should be renamed <Feature><Specific>Event.

#### State class

A base State class should be sealed and should extend Equatable for comparison purposes.

Typical states: Initial, Loading, Success (Loaded), Error.

A derived State class should be renamed <Feature><Specific>State.

### ViewModel

A ViewModel class should only see UseCase classes.

Use a factory to facilitate the creation of a ViewModel instance, as it's built in multiple 
steps, up from DataSource, Repository to UseCase.

## Domain Layer

### Entity

In general, an Entity class should have a Hive adapter whose code can be generated using 
bash command:

`flutter packages pub run build_runner build --delete-conflicting-outputs`

Some Entity classes may be used by all the layers.

Different layers may have different presentations of a same entity. Conversions of the entity 
between layers may be needed and should be done in the ViewModel or in the Repository.

### UseCase

A UseCase class should only see Repository classes.

Use call(), rather than execute(), to execute a UseCase. This makes the UseCase class look like 
a function.

Wrap the return value of a UseCase function into a Result<T> class with Success or Failure so that 
the Presentation layer (View or Bloc) can handle the result easily.

## Data Layer

### Repository

A Repository class should only see DataSource classes.

### DataSource

A DataSource class usually deal with one specific type, such as local storage, remote server, or 
testing/simulated data.

When using a package or API to access data, try to initialize it inside the DataSource class 
rather than in the main() function.

For local storage access via Hive, consider one Hive Box per feature. Use a utility class for 
all the features to avoid code duplication (the DRY principle).

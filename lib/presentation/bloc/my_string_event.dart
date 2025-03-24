part of 'my_string_bloc.dart';

abstract class MyStringEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMyString extends MyStringEvent {}

class UpdateMyStringFromUser extends MyStringEvent {
  final String newValue;

  UpdateMyStringFromUser(this.newValue);

  @override
  List<Object?> get props => [newValue];
}

class UpdateMyStringFromServer extends MyStringEvent {
  final Future<String> Function() fetchFromServer;

  UpdateMyStringFromServer(this.fetchFromServer);

  @override
  List<Object?> get props => [];
}

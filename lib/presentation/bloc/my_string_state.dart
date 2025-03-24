part of 'my_string_bloc.dart';

abstract class MyStringState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyStringInitial extends MyStringState {}

class MyStringLoading extends MyStringState {}

class MyStringLoaded extends MyStringState {
  final String value;

  MyStringLoaded(this.value);

  @override
  List<Object?> get props => [value];
}

class MyStringError extends MyStringState {
  final String message;

  MyStringError(this.message);

  @override
  List<Object?> get props => [message];
}

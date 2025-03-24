import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_string_event.dart';
part 'my_string_state.dart';

class MyStringBloc extends Bloc<MyStringEvent, MyStringState> {
  MyStringBloc() : super(MyStringInitial()) {
    on<LoadMyString>((event, emit) {
      emit(MyStringLoading());
    });

    on<UpdateMyStringFromUser>((event, emit) {
      emit(MyStringLoaded(event.newValue));
    });

    on<UpdateMyStringFromServer>((event, emit) async {
      emit(MyStringLoading());
      try {
        final value = await event.fetchFromServer();
        emit(MyStringLoaded(value));
      } catch (e) {
        emit(MyStringError('Failed to fetch from server: $e'));
      }
    });
  }
}

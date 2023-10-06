import 'package:bloc/bloc.dart';
import 'package:mashtoz_flutter/domens/blocs/update_home_event.dart';
import 'package:mashtoz_flutter/domens/blocs/update_home_state.dart';

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(ScreenUpdatedState(false)) {
    on<UpdateScreenEvent>((event, emit) {
      // Handle the event here and update the state accordingly
      emit(ScreenUpdatedState(event.isTrue));
    });
  }
}

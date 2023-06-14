import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:mashtoz_flutter/domens/blocs/Login/login_state.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/email.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/passowrd.dart';

import '../../repository/user_data_provider.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._userDataProvider) : super(const LoginState());

  final UserDataProvider _userDataProvider;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    print(email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> loginWithCredentials() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      bool isSuccess = await _userDataProvider.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      if (isSuccess) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void logOut(){
    emit(state.copyWith(status: FormzStatus.pure));
  }
}

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:mashtoz_flutter/domens/blocs/register_bloc/register_state.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/full_name.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/passowrd.dart';

import '../../models/user_input_data_validation/email.dart';
import '../../repository/user_data_provider.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._userDataProvider) : super(const RegisterState());

  final UserDataProvider _userDataProvider;

  void fullaNameChanged(String value) {
    final fullName = FullName.dirty(value);
    print(fullName);
    emit(state.copyWith(
      fullName: fullName,
      status: Formz.validate([
        fullName,
        state.email,
        state.password,
      ]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    print(email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.fullName,
        email,
        state.password,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    print(password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.fullName,
        state.email,
        password,
      ]),
    ));
  }

  Future<void> signUpCredentials() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      var isSuccess = await _userDataProvider.signUp(
        email: state.email.value,
        password: state.password.value,
        fullName: state.fullName.value,
      );

      if (isSuccess['success']) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage: isSuccess['errors']));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void logOut() {
    emit(state.copyWith(status: FormzStatus.pure));
  }
}

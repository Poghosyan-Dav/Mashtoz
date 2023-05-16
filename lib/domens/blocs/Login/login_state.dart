import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/email.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/passowrd.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final String? errorMessage;
  final Password password;
  final FormzStatus status;

  @override
  List<Object?> get props => [email, password, status, errorMessage];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
  }) {
    print("from Login State : $status");
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/email.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/full_name.dart';
import 'package:mashtoz_flutter/domens/models/user_input_data_validation/passowrd.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final String? errorMessage;
  final FullName fullName;
  final Password password;
  final FormzStatus status;

  @override
  List<Object?> get props => [fullName, email, password, status, errorMessage];

  RegisterState copyWith({
    FullName? fullName,
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
  }) {
    print("from Login State : $status");
    return RegisterState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

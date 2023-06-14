import 'package:formz/formz.dart';

enum EmailValidator { invalid }

class Email extends FormzInput<String, EmailValidator> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\s*$',
  );

  @override
  EmailValidator? validator(String? value) {
    return _emailRegExp.hasMatch(value!) ? null : EmailValidator.invalid;
  }
}


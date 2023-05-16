import 'package:formz/formz.dart';

enum PassowrdValidatorError { invalid,short }

class Password extends FormzInput<String, PassowrdValidatorError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static RegExp _passwordRegex = RegExp(r".{4,}$");
  static RegExp _passwordShortRegex = RegExp(r"^.{1,4}$");
  @override
  PassowrdValidatorError? validator(String? value) {
    if(!_passwordRegex.hasMatch(value!)){
      return  PassowrdValidatorError.short;
    }
    return null;
  }

}

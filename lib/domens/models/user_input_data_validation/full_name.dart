import 'package:formz/formz.dart';

enum FullNameValidator { invalid }

class FullName extends FormzInput<String, FullNameValidator> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _fullNameArm =
      RegExp(r"^[ա-ֆԱ-Ֆ]+(([',. -][ա-ֆԱ-Ֆ ])?[ա-ֆԱ-Ֆ ]*)*$");
  static final RegExp _fullNameEn =
      RegExp(r"^(?:[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z ]*)*){0,1}$");
  static final RegExp _fullNameRus =
      RegExp(r"^[а-яА-Я]+(([',. -][а-яА-Я ])?[а-яА-Я ]*)*$");

  @override
  FullNameValidator? validator(String? value) {
    if (_fullNameArm.hasMatch(value!)) {
      return null;
    } else if (_fullNameEn.hasMatch(value)) {
      return null;
    } else if (_fullNameRus.hasMatch(value)) {
      return null;
    }
    return FullNameValidator.invalid;
  }
}

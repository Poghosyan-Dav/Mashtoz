import 'package:formz/formz.dart';

enum FullNameValidator { invliad }

class FullName extends FormzInput<String, FullNameValidator> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _fullNameEn = RegExp(
      r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
  static final RegExp _fullNameRus = RegExp(
      r"^[а-яА-Я]+(([',. -][а-яА-Я ])?[а-яА-Я]*)*$");
  static final RegExp _fullNameArm = RegExp(
      r"^[ա-ֆԱ-Ֆ]+(([',. -][ա-ֆԱ-Ֆ ])?[ա-ֆԱ-Ֆ]*)*$");
  @override
  FullNameValidator? validator(String? value) {
    if(value!.contains(RegExp(r'^[ա-ֆԱ-Ֆ]'))){
      return _fullNameArm.hasMatch(value ?? '')
          ? null
          : FullNameValidator.invliad;
    }else if(value!.contains(RegExp(r'^[а-яА-Я]'))){
      return _fullNameRus.hasMatch(value ?? '')
          ? null
          : FullNameValidator.invliad;
    }
    return _fullNameEn.hasMatch(value ?? '')
        ? null
        : FullNameValidator.invliad;
  }
}

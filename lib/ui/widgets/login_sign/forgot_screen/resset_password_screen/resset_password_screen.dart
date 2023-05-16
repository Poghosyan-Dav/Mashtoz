import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/login_sign/login_screen/login_screen.dart';

class RessetPasswordScreen extends StatefulWidget {
  const RessetPasswordScreen({Key? key, required this.smsCode})
      : super(key: key);

  final String smsCode;

  @override
  State<RessetPasswordScreen> createState() =>
      _RessetPasswordScreenState(smsCode: smsCode);
}

class _RessetPasswordScreenState extends State<RessetPasswordScreen> {
  _RessetPasswordScreenState({required this.smsCode});

  final formKey = GlobalKey<FormState>();
  final passwordConfirmcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final String smsCode;
  final userDataProvder = UserDataProvider();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(
          83,
          66,
          76,
          1,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 39),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(top: 3.5),
                      splashRadius: 0.1,
                      iconSize: 23,
                      alignment: Alignment.topCenter,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Padding(
                        padding: EdgeInsets.only(right: double.infinity),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Palette.textLineOrBackGroundColor,
                        ),
                      ),
                    ),
                    Container(
                      height: 47,
                      padding: const EdgeInsets.only(right: 40.0, bottom: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Նոր գաղտնաբառ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'GHEAGrapalat',
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400,
                              color: Palette.textLineOrBackGroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.0),
                      TextFormField(
                        controller: passwordcontroller,
                        cursorColor: Palette.cursor,
                        style:
                            TextStyle(color: Palette.textLineOrBackGroundColor),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.textLineOrBackGroundColor)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.textLineOrBackGroundColor)),
                          labelText: 'Նոր գաղտնաբառ',
                          labelStyle: TextStyle(
                            fontFamily: 'GHEAGrapalat',
                            fontSize: 14,
                            letterSpacing: 1,
                            color: Palette.labelText,
                          ),
                          focusColor: Palette.labelText,
                        ),
                        validator: (value) {
                          if (!value!.contains(RegExp(r'[A-Z,a-z,0-9]{6}'))) {
                            return 'Մուտքագրված հասցեն սխալ է';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40.0),
                      TextFormField(
                        controller: passwordConfirmcontroller,
                        cursorColor: Palette.cursor,
                        style:
                            TextStyle(color: Palette.textLineOrBackGroundColor),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.textLineOrBackGroundColor)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.textLineOrBackGroundColor)),
                          labelText: 'Կրկնել գաղտնաբառը',
                          labelStyle: TextStyle(
                            fontFamily: 'GHEAGrapalat',
                            fontSize: 14,
                            color: Palette.labelText,
                          ),
                          focusColor: Palette.labelText,
                        ),
                        validator: (value) {
                          if (!value!.contains(RegExp(
                            r'[A-Z,a-z,0-9]{6}',
                          ))) {
                            return 'Մուտքագրված հասցեն սխալ է';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 47,
                          child: RawMaterialButton(
                            onPressed: () {
                              if (passwordcontroller.text
                                  .contains(passwordConfirmcontroller.text)) {
                                final password = passwordcontroller.text;
                                final passwordConfirm =
                                    passwordConfirmcontroller.text;
                                if (formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );
                                  userDataProvder.passwordReset(
                                    code: smsCode,
                                    password: password,
                                    passwordConfirm: passwordConfirm,
                                    closure: (success) {
                                      if (success == true) {
                                        print('Reset Screen');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Invalid Data')),
                                        );
                                      }
                                    },
                                  );
                                }
                                ;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Invalid Data')),
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(
                                  width: 47,
                                  height: 50,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/login_button.png"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

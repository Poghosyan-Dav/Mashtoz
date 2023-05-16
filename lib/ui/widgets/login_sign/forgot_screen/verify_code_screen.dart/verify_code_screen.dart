import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/login_sign/forgot_screen/resset_password_screen/resset_password_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  String currentText = "";
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  var smsCode;
  final textController = TextEditingController();
  final userDataProvder = UserDataProvider();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromRGBO(
            83,
            66,
            76,
            1,
          ),
          body: Container(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 39.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Expanded(
                      child: Container(
                        height: 47,
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'Մուտքագրեք կոդը',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'GHEAGrapalat',
                                letterSpacing: 1,
                                fontWeight: FontWeight.w400,
                                color: Palette.textLineOrBackGroundColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 57,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 70,
                  child: Align(
                    alignment: Alignment.center,
                    child: const Text(
                      'Մուտքագրեք էլ. փոստին ուղարկված \nվեցանիշ թիվը',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'GHEAGrapalat',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          color: Palette.textLineOrBackGroundColor),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: PinCodeTextField(
                          appContext: context,
                          textStyle: TextStyle(
                              color: Palette.textLineOrBackGroundColor),
                          pinTheme: PinTheme(
                              borderRadius: BorderRadius.zero,
                              activeFillColor: Palette.whenTapedButton,
                              inactiveColor: Palette.disable,
                              inactiveFillColor: Colors.green,
                              selectedFillColor: Colors.deepPurple,
                              selectedColor: Palette.whenTapedButton,
                              activeColor: Palette.textLineOrBackGroundColor),
                          cursorColor: Palette.main,
                          length: 6,
                          keyboardType: TextInputType.phone,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          animationDuration: Duration(milliseconds: 300),
                          controller: textController,
                          errorAnimationController: errorController,
                          onCompleted: (v) {
                            print("Completed");
                          },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          validator: (v) {
                            if (v!.length < 6) {
                              return "I'm from validator";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 47,
                          child: RawMaterialButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final smsCode = textController.text;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(microseconds: 200),
                                      content: Text('Processing Data')),
                                );
                                userDataProvder.sendCode(smsCode, (success) {
                                  if (success == true) {
                                    print('Forgot_screen');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RessetPasswordScreen(
                                                smsCode: smsCode,
                                              )),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(microseconds: 200),
                                          content: Text('Invald Data')),
                                    );
                                  }
                                });
                              }
                              if (currentText.length != 6) {
                                errorController!.add(ErrorAnimationType
                                    .shake); // Triggering error shake animation
                                setState(() => hasError = true);
                              } else {
                                errorController!.add(ErrorAnimationType
                                    .shake); // Triggering error shake animation
                                setState(() => hasError = false);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // mainAxisSize: MainAxisSize.min,
                              children: const [
                                Align(
                                  child: SizedBox(
                                    width: 47,
                                    height: 50,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/login_button.png"),
                                    ),
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

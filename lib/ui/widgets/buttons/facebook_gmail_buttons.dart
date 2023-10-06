import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mashtoz_flutter/auth_service.dart';
import 'package:mashtoz_flutter/config/palette.dart';

import '../login_sign/singup_screen/singup_screen.dart';

class CoupleButtons extends StatelessWidget {
  CoupleButtons({Key? key, required this.isLogin}) : super(key: key);
  final bool isLogin;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Ink(
              child: InkWell(
                onTap: () async {
                  print('gmail taped');
                  AuthService service = new AuthService();
                  try {
                    await service.signInwithGoogle(context, isLogin);
                    //Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
                  } catch (e) {
                    if (e is FirebaseAuthException) {
                      showMessage(e.message!, context);
                    }
                    //AuthService().signInWithGoogle(context);
                  }
                },
                child: SizedBox(
                  child: SvgPicture.asset('assets/images/gmail.svg'),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Ink(
              child: InkWell(
                onTap: () async {
                  print('gmail taped');
                  AuthService service = new AuthService();
                  try {
                    await service.signInWithFacebook(context, isLogin);
                  } catch (e) {
                    if (e is FirebaseAuthException) {
                      showMessage(e.message!, context);
                    }
                  }
                },
                child: SvgPicture.asset('assets/images/Facebook.svg'),
              ),
            ),
          ],
        ));
  }

  void showMessage(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

class ComplexButton extends StatelessWidget {
  final bool isLogin;
  ComplexButton({Key? key, required this.isLogin});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60.0,
            color: Palette.barColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SignUpButton(),
                  Expanded(
                      child: CoupleButtons(
                    isLogin: isLogin,
                  )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ComplexButton2 extends StatelessWidget {
  final bool isLogin;
  ComplexButton2({Key? key, required this.isLogin});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60.0,
            color: Palette.barColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SignUpButton2(),
                  Expanded(
                      child: CoupleButtons(
                    isLogin: isLogin,
                  )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignupScreen()));
      },
      child: const Text(
        'Գրանցվել հիմա',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'GHEAGrapalat',
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
      style: TextButton.styleFrom(padding: const EdgeInsets.only(right: 40)),
    );
  }
}

class SignUpButton2 extends StatelessWidget {
  const SignUpButton2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        'Մուտք գործել',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'GHEAGrapalat',
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
      style: TextButton.styleFrom(padding: const EdgeInsets.only(right: 40)),
    );
  }
}

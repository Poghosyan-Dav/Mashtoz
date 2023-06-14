import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/blocs/Login/login_bloc.dart';
import 'package:mashtoz_flutter/domens/blocs/Login/login_state.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/home_screen.dart';
import 'package:provider/provider.dart';

import '../../../../domens/models/user_input_data_validation/passowrd.dart';
import '../../../../tab_provider.dart';
import '../forgot_screen/forgot_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final tabProvider = Provider.of<TabProvider>(context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          tabProvider.login();
          context.read<LoginCubit>().logOut();
          if (tabProvider.currentIndex == 4) {
            Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),(Route<dynamic> route) => false);
          } else {
            Future.delayed(const Duration(milliseconds: 200),(){
              Navigator.of(context).pop();
            }).then((_) {
              if(mounted) {
                tabProvider.userIsSign();
              }
            });



          }

        }
        else if (state.status.isSubmissionFailure) {
          print('cik isSubmissionFailure');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Login Failure'),
              ),
            );
        }
        // else if (state.status.isSubmissionInProgress) {
        //   ScaffoldMessenger.of(context)
        //     ..hideCurrentSnackBar()
        //     ..showSnackBar(
        //       SnackBar(
        //         content: Container(
        //           height: 23,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: <Widget>[
        //               Container(
        //                 height: 20,
        //                 width: 20,
        //                 child: CircularProgressIndicator(
        //                   valueColor:
        //                       AlwaysStoppedAnimation<Color>(Palette.main),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     );
        // }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
            child: Column(
              children: [
                SizedBox(height: screenSize.height / 10),
                const _LoginIput(),
                SizedBox(height: screenSize.height / 19),
                const PasswordInput(),
                SizedBox(height: screenSize.height / 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _ForgotButton(),
                      _LoginButton(),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginIput extends StatelessWidget {
  const _LoginIput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        print("Login input ${state.email.invalid}");
        return TextFormField(
          cursorColor: Palette.cursor,
          style: TextStyle(color: Palette.textLineOrBackGroundColor),
          decoration: InputDecoration(
            focusedBorder: const UnderlineInputBorder(
                borderSide:
                BorderSide(color: Palette.textLineOrBackGroundColor)),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                BorderSide(color: Palette.textLineOrBackGroundColor)),
            labelText: 'էլ. փոստ',
            labelStyle: const TextStyle(
              fontFamily: 'GHEAGrapalat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
              color: Palette.labelText,
            ),
            focusColor: Palette.labelText,
            errorText: state.email.invalid && !state.email.value.isEmpty ? 'Մուտքագրված հասցեն սխալ է' : null,
          ),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
        );
      },
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isHiddenPassword = true;

  void _togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          print("password input ${state.email.invalid}");
          return TextFormField(
            cursorColor: Palette.cursor,
            style: TextStyle(color: Palette.textLineOrBackGroundColor),
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 1))),
              enabledBorder: const UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 1))),
              labelText: 'Գաղտնաբառ',
              labelStyle: const TextStyle(
                  fontFamily: 'GHEAGrapalat',
                  fontSize: 14,
                  letterSpacing: 1,
                  color: Color.fromRGBO(189, 189, 189, 1),
                  fontWeight: FontWeight.w400),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: InkWell(
                  onTap: _togglePassword,
                  child: !isHiddenPassword
                      ? const Icon(
                    Icons.visibility,
                    color: Palette.textLineOrBackGroundColor,
                  )
                      : const Icon(
                    Icons.visibility_off,
                    color: Palette.textLineOrBackGroundColor,
                  ),
                ),
              ),
              errorText:
              state.password.error == PassowrdValidatorError.short && !state.password.value.isEmpty ?"նվազագույն երկարությունը 8": null,
            ),
            obscureText: isHiddenPassword,
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
          );
        });
  }
}

class _LoginButton extends StatefulWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  bool _isActive = false;
  bool? isTap = false;
  void isActive() {
    setState(() {
      _isActive = !_isActive;
    });
  }

  UserDataProvider userDataProvider = UserDataProvider();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return GestureDetector(
            onTap: ()  {

              if (state.status.isValidated) {
                context.read<LoginCubit>().loginWithCredentials();

                setState(() {
                  isTap = true;
                });
                isActive();
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    duration: Duration(milliseconds: 500),
                    content: Text(
                      'Տվյալները գտնված չեն։',
                    )));
                setState(() {
                  isTap=false;
                });
              }
              // userDataProvider.logOut();
            },
            child: SizedBox(
              width: 47,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        /// bottom
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              spreadRadius: -1,
                              blurRadius: 1,
                              offset: Offset(7, 5),
                            ),
                          ]),
                        ),
                        Container(
                          width: 37,
                          height: 40,
                          color: state.status.isValidated
                              ? Palette.main
                              : Palette.disableButton,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 26,
                            child:
                            SvgPicture.asset('assets/images/Vector 81.svg'),
                          ),
                        ),

                        /// top
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        });
  }
}

class _ForgotButton extends StatelessWidget {
  const _ForgotButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('moraceleq gaxtnabary');
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ForgotScreen()));
      },
      child: const Text(
        'Մոռացե՞լ եք գաղտնաբառը',
        style: TextStyle(
            fontSize: 10,
            fontFamily: 'GHEAGrapalat',
            color: Palette.main,
            //letterSpacing: 1,
            fontWeight: FontWeight.w400),
      ),
      style: TextButton.styleFrom(
        primary: Colors.amber,
        padding: const EdgeInsets.only(right: 40),
      ),
    );
  }
}

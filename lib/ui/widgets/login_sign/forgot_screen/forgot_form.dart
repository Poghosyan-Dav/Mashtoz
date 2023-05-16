import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/login_sign/forgot_screen/verify_code_screen.dart/verify_code_screen.dart';

class ForgotForm extends StatefulWidget {
  const ForgotForm({Key? key}) : super(key: key);

  @override
  _ForgotFormState createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final userDataProvder = UserDataProvider();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 40.0),
                TextFormField(
                  controller: controller,
                  cursorColor: Palette.cursor,
                  style: TextStyle(color: Palette.textLineOrBackGroundColor),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Palette.textLineOrBackGroundColor)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Palette.textLineOrBackGroundColor)),
                    labelText: 'էլ. փոստ',
                    labelStyle: TextStyle(
                      fontFamily: 'GHEAGrapalatAccountPageAccountPage',
                      fontSize: 14,
                      color: Palette.labelText,
                    ),
                    focusColor: Palette.labelText,
                  ),
                  validator: (value) {
                    if (!value!.contains(RegExp(
                        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'))) {
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => VerifyCodeScreen(
                        //             userEmail: '',
                        //           )),
                        // );
                        if (formKey.currentState!.validate()) {
                          final _email = controller.text;

                          userDataProvder.forgotPasswordPost(_email, (success) {
                            if (success == true) {
                              print('Forgot_screen');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyCodeScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    content: Text(' Սխալ տվյալներ։')),
                              );
                            }
                          });
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
                              image:
                                  AssetImage("assets/images/login_button.png"),
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
    );
  }
}

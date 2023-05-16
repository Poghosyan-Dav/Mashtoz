import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/config/palette.dart';

import 'forgot_form.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(
          83,
          66,
          76,
          1,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const SizedBox(height: 39),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.only(top: 1.5),
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
                      // const SizedBox(
                      //   width: 35,
                      // ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: const Text(
                              'Մոռացել եք\n գաղտնաբառը',
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
                    height: 35,
                  ),
                  const Text(
                    'Մուտքագրեք ձեր հաշվում լրացված\n էլեկտրոնային փոստի հասցեն',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'GHEAGrapalat',
                        color: Palette.textLineOrBackGroundColor),
                  ),
                  const ForgotForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

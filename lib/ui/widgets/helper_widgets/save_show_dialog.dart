import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:provider/provider.dart';

import '../../../config/palette.dart';
import '../../../tab_provider.dart';
import '../login_sign/login_screen/login_screen.dart';

class SaveShowDialog extends StatefulWidget {
  final bool? isShow;
  Map<String, dynamic>? data;

  SaveShowDialog({Key? key, this.isShow, this.data}) : super(key: key);

  @override
  State<SaveShowDialog> createState() => _SaveShowDialogState();
}

class _SaveShowDialogState extends State<SaveShowDialog> {
  File? file;
  bool videoEnable = false;
  Map<String, bool>? isSign;
  final _userDataProvider = UserDataProvider();

  @override
  void initState() {
    _userDataProvider.saveFavorite(widget.data!).then((value) {
      setState(() {
        setState(() {
          isSign = value;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);

    if (widget.isShow == true && isSign?['success'] == false ||
        isSign?['error'] == false) {
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(35.0, 20.0, 35.0, 24.0),
        alignment: Alignment.center,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            width: width,
            height: 190,
            child: Column(
              children: [
                const Expanded(
                  child: Text(
                    'Տվյալ նյութը պահելու \nհամար անհրաժեշտ է \nմուտք գործել',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Փակել',
                          style: TextStyle(
                              fontFamily: 'GHEAGrapalat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: Color.fromRGBO(122, 108, 115, 1)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => const LoginScreen()))
                              .then((_) => Navigator.of(context).pop());
                        },
                        child: Container(
                            color: Palette.main,
                            height: 40,
                            width: 100,
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Մուտք',
                                  style: TextStyle(
                                      fontFamily: 'GHEAGrapalat',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                      color: Palette.textLineOrBackGroundColor),
                                ))),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }),
        contentTextStyle: const TextStyle(
            fontFamily: 'GHEAGrapalat',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
            color: Color.fromRGBO(97, 109, 135, 1)),
      );
    }

    if (isSign?['success'] == true || tabProvider.userHasLogin == true) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: AlertDialog(
          alignment: Alignment.center,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
          content: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Փակել',
              style: TextStyle(
                  fontFamily: 'GHEAGrapalat',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: Color.fromRGBO(122, 108, 115, 1)),
            ),
          ),
        ),
      );
    }
    if (isSign?['already'] == true) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: AlertDialog(
          alignment: Alignment.center,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          icon: Flexible(child: Text('Դուք արդեն պահպանել եք այն')),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Փակել',
                  style: TextStyle(
                      fontFamily: 'GHEAGrapalat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: Color.fromRGBO(122, 108, 115, 1)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const Center(
        child: CircularProgressIndicator(
      color: Palette.main,
    ));
  }
  // _showToast() {
  //
  //     Fluttertoast.showToast(
  //       msg: "This is Long Toast",
  //       toastLength: Toast.LENGTH_LONG,
  //       fontSize: 18.0,
  //     );
  //
  // }
}

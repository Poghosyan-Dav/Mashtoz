import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mashtoz_flutter/ui/utils/log_out_changenotifire.dart';
import 'package:mashtoz_flutter/ui/widgets/buttons/facebook_gmail_buttons.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
    const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return WillPopScope(
      onWillPop: ()async{
        // switch(HomeScreenState.currentIndex){
        //   case 0 : context.read<BottomColorNotifire>().setColor(
        //       Palette.textLineOrBackGroundColor);
        //   HomeScreenState.icons = BottomIcons.home;
        //
        //   HomeScreenState.isLibrary = false;
        //
        //   HomeScreenState.isHome = true;
        //   HomeScreenState.isSearch = false;
        //   HomeScreenState.isItalian = false;
        //   HomeScreenState.isAccount = false;
        //   break;
        //   case 1 : context.read<BottomColorNotifire>().setColor(
        //       Palette.libraryBacgroundColor);
        //   HomeScreenState.icons = BottomIcons.library;
        //
        //   HomeScreenState.isLibrary = true;
        //
        //   HomeScreenState.isHome = false;
        //   HomeScreenState.isSearch = false;
        //   HomeScreenState.isItalian = false;
        //   HomeScreenState.isAccount = false;
        //   break;
        //   case 2 : context.read<BottomColorNotifire>().setColor(
        //       Palette.searchBackGroundColor);
        //   HomeScreenState.icons = BottomIcons.search;
        //
        //   HomeScreenState.isLibrary = false;
        //
        //   HomeScreenState.isHome = false;
        //   HomeScreenState.isSearch = true;
        //   HomeScreenState.isItalian = false;
        //   HomeScreenState.isAccount = false;
        //   break;
        //   case 3 : context.read<BottomColorNotifire>().setColor(
        //       Palette.textLineOrBackGroundColor);
        //   HomeScreenState.icons = BottomIcons.italian;
        //
        //   HomeScreenState.isLibrary = false;
        //
        //   HomeScreenState.isHome = false;
        //   HomeScreenState.isSearch = false;
        //   HomeScreenState.isItalian = true;
        //   HomeScreenState.isAccount = false;
        //   break;
        //   case 4 : context.read<BottomColorNotifire>().setColor(
        //       Palette.textLineOrBackGroundColor);
        //   HomeScreenState.icons = BottomIcons.account;
        //
        //   HomeScreenState.isLibrary = false;
        //
        //   HomeScreenState.isHome = false;
        //   HomeScreenState.isSearch = false;
        //   HomeScreenState.isItalian = false;
        //   HomeScreenState.isAccount = true;
        //   break;
        // }

        return true;
      },
      child: LoadingOverlay(
          isLoading:context.watch<UserLogOutNotifier>().userLogOut,
      opacity: 0.0,
      progressIndicator: CircularProgressIndicator(),

        child: Scaffold(
          resizeToAvoidBottomInset: false,

          backgroundColor: const Color.fromRGBO(
            83,
            66,
            76,
            1,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Column(
                              children:  [
                                const  SizedBox(height: 30),
                                const Center(
                                  child: SizedBox(
                                    width: 142,
                                    height: 98,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/mashtoz_org.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                LoginForm(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 55.0),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ComplexButton(isLogin: true,)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

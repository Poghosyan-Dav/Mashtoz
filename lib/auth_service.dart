import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/ui/utils/log_out_changenotifire.dart';
import 'package:mashtoz_flutter/ui/utils/showSnackBar.dart';
import 'package:mashtoz_flutter/ui/widgets/login_sign/login_screen/login_screen.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/bottom_bars_pages/account_page.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/home_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SessionDataProvider _sessionDataProvider = SessionDataProvider();
  final UserDataProvider _userDataProvider = UserDataProvider();
  Future<bool> hasToken() async {
    String? token = await _sessionDataProvider.readsAccessToken();
    if (token != null) {
      // Check if the token has expired
      Map<String, dynamic> decodedToken = json.decode(
          ascii.decode(
              base64.decode(base64.normalize(token.split(".")[1]))
          )
      );
      if (DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000).isBefore(DateTime.now())) {
        // Token has expired, log the user out
        await _sessionDataProvider.deleteAllToken();
        return false;
      }
      // Token is valid, the user is logged in
      return true;
    }
    // Token not found, the user is not logged in
    return false;
  }


  // void hasSignInfo(BuildContext context,FirebaseAuth user,OAuthCredential oAuthCredential){
 //   Future.delayed(Duration(seconds: 2),(){
 //     context.read<LoginCubit>().emailChanged("matucox.matucox@gmail.com");
 //     context.read<LoginCubit>().passwordChanged("matucox");
 //
 //    }).whenComplete(() => context.read<LoginCubit>().loginWithCredentials());
 //
 // }

  Future<Widget> handleAuthState() async {
    bool isSign = await hasToken();
    User? result = FirebaseAuth.instance.currentUser;
    print("handleAuthState $isSign");
    return (result != null && isSign == true) || isSign  == true ? const AccountPage() : LoginScreen();
  }

  // signInWithGoogle(BuildContext context) async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn(
  //       scopes: <String>["email"]).signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //    if(googleAuth!=null){
  //
  //    }
  //   var userSign = await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //   if(userSign!=null){
  //     bool isSign =  hasToken();
  //
  //   // if(!isSign)  Future.delayed(Duration(seconds: 2),(){
  //   //     context.read<RegisterCubit>().emailChanged('matucox.matucox@gmail.com');
  //   //     context.read<RegisterCubit>().fullaNameChanged('matucox.matucox@gmail.com');
  //   //     context.read<RegisterCubit>().passwordChanged("matucox");
  //   //     context.read<RegisterCubit>().signUpCredentials();
  //   //   }).whenComplete(() {
  //   //
  //   //
  //   // });
  //
  //    return userSign;
  //   }
  // }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
   Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
     required bool fromLogin,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;
    if(fromLogin){
      if (user != null) {
        print(user.email);
      bool isTrue =  await _userDataProvider.signInWithEmailAndPassword(email: '${user.email}',password: '${user.uid}');
      if(isTrue){
        context.read<UserLogOutNotifier>().userSignWigGoogle(true, context);

      } else{
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Login Failure'),
            ),
          );
      }

      } else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  LoginScreen(
            ),
          ),
        );
      }
    }else{
      if(user != null){
        bool isTrue =   await  _userDataProvider.createUserWithNAmeEmailAndPassword(email: '${user.email}',fullName: '${user.displayName}',
            password: '${user.uid}'
        );
        if(isTrue){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(
              ),
            ),
          );
        } else{
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('User account signed in'),
              ),
            );
        }

      } else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  LoginScreen(
            ),
          ),
        );
      }
    }


    return firebaseApp;
  }
  Future<String?> signInwithGoogle(BuildContext context,bool fromLogin) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) =>initializeFirebase(context: context,fromLogin: fromLogin));
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
    return null;
  }
  Future<void> signInWithFacebook(BuildContext context,bool fromLogin) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if(loginResult!=null){
        final OAuthCredential? facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
        await _auth?.signInWithCredential(facebookAuthCredential!).then((value) => initializeFirebase(context: context,fromLogin: fromLogin));
        print('ddddddadasionnnn :${loginResult.message}');
      }


    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      print(e.message);
      // Displaying the error message
    }
  }
}

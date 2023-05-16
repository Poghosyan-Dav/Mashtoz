import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mashtoz_flutter/domens/blocs/Login/login_bloc.dart';
import 'package:mashtoz_flutter/domens/blocs/register_bloc/register_bloc.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/models/book_data/content_list.dart';
import 'package:mashtoz_flutter/domens/models/user.dart';
import 'package:mashtoz_flutter/ui/utils/showSnackBar.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';

class UserDataProvider {
  final sessionDataProvider = SessionDataProvider();
  final FirebaseAuth? auth;
  User get user => auth!.currentUser!;
  bool isTrue = false;
  UserDataProvider({
    this.auth,
  });
  static const maxAccesSeconds = 3600;

  static const maxRefreshSeconds = 216000000;
  int seconds = maxAccesSeconds;
  bool isAcces_Token_TimerActive = false;
  bool isRefresh_Token_TimerActive = false;

  void startAccessTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        print(seconds);
      } else {
        timer.cancel();
        isAcces_Token_TimerActive = true;

        print('timer cancel');
      }
    });
  }

  void startRefreshTimer() {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        print(seconds);
      } else {
        timer.cancel();
        isRefresh_Token_TimerActive = true;

        print('timer cancel');
      }
    });
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context, bool isLogin) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        await auth?.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await auth!.signInWithCredential(credential);

          // if you want to do specific task like storing information in firestore
          // only for new users using google sign in (since there are no two options
          // for google sign in and google sign up, only one as of now),
          // do the following:

          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {
              var user = userCredential.user;
              isLogin
                  ? context
                      .read<LoginCubit>()
                      .emailChanged('mesrop.mashtoc@gmail.com')
                  : context
                      .read<RegisterCubit>()
                      .fullaNameChanged(user!.displayName!);
              isLogin
                  ? context.read<LoginCubit>().passwordChanged('mashtoc1234')
                  : context.read<RegisterCubit>().passwordChanged(user!.uid);
              if (isLogin == false) {
                context
                    .read<RegisterCubit>()
                    .emailChanged('mesrop.mashtoc@gmail.com');
              }

              isLogin
                  ? context.read<LoginCubit>().loginWithCredentials()
                  : context.read<RegisterCubit>().signUpCredentials();
              print('mnuma jogenq voncenq anum');
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }



  //Sign Up
  Future<bool> signUp(
      {required String email,
      required String password,
      required String fullName}) async {
    bool isSuscces = false;

    isSuscces = await createUserWithNAmeEmailAndPassword(
        email: email, password: password, fullName: fullName);

    return isSuscces;
  }

  //Login
  Future<bool> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    bool isSuscces = false;
    try {
      isSuscces =
          await signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
    return isSuscces;
  }

  //Log out
  Future<void> logOut() async {
    try {
      await sessionDataProvider.deleteAllToken();
    } catch (e) {
      print(e);
    }
  }

  //Login
  Future<bool> signInWithEmailAndPassword(
      {String? email, String? password}) async {
    Map userData = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(Api.loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
      var body = jsonDecode(response.body);
      var token = body['access_token'];
      print(token);
      // sessionDataProvider.deleteAllToken();
      if (response.statusCode == 200) {
        print('success');
        var access_token = body['access_token'];
        var refresh_token = body['refresh_token'];
        sessionDataProvider.setAccessToken(access_token);
        sessionDataProvider.setRefreshToken(refresh_token);
        return true;
      } else {
        print("failed");
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  //Signup
  Future<bool> createUserWithNAmeEmailAndPassword(
      {String? email, String? password, String? fullName}) async {
    Map userData = {
      'email': email,
      'password': password,
      'full_name': fullName,
    };

    try {
      var response = await http.post(
        Uri.parse(Api.resgisterUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var access_token = body['access_token'];
        var refresh_token = body['refresh_token'];
        sessionDataProvider.setAccessToken(access_token);
        sessionDataProvider.setRefreshToken(refresh_token);
        startAccessTimer();
        startRefreshTimer();

        return true;
      } else {
        print("failed");
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  //Forgot Password post
  Future<bool> forgotPasswordPost(String email, Function closure) async {
    Map userEmail = {'email': email};

    try {
      var response = await http.post(
        Uri.parse(Api.forgotPassword),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userEmail),
      );
      var data = jsonDecode(response.body);
      var message = data['message'];
      if (response.statusCode == 200 && message.contains('passwords.sent')) {
        closure(true);
      } else {
        closure(false);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  //Send Code for password_resset
  void sendCode(String code, Function closure) async {
    Map smsCode = {'code': code};
    try {
      final response = await http.post(
        Uri.parse(Api.checkCode),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(smsCode),
      );
      var body = json.decode(response.body);
      //var responseCode = body['code'];
      var message = body['message'];
      print(response.body);
      if (response.statusCode == 200 &&
          message.toString().contains('Password reset code is valid')) {
        closure(true);
      } else {
        closure(false);
      }
    } catch (error) {
      print(error);
    }
  }

  //Password Resset
  Future<bool> passwordReset(
      {required String code,
      required String password,
      required String passwordConfirm,
      Function? closure}) async {
    Map resetPassword = {
      'code': code,
      'password': password,
      'password_confirmation': passwordConfirm
    };

    try {
      var response = await http.post(
        Uri.parse(Api.resetPassword),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(resetPassword),
      );

      if (response.statusCode == 200) {
        closure!(true);
      } else {
        closure!(false);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  //Fetch User Info
  Future<Users?> fetchUserInfo() async {
    var token = await sessionDataProvider.readsAccessToken();
    var user;
    try {
      var response = await http.get(
        Uri.parse(Api.userInfo),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $token'
        },
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('success');
        Map.from(body).forEach((key, value) {
          user = Users.fromJson(body);
        });
        return user;
      } else if (response.statusCode == 401 || isAcces_Token_TimerActive) {
        // Access token expired or invalid, refresh token and try again
        var isTrue = await refreshToken();
        if (isTrue) {
          return await fetchUserInfo();
        }
      } else {
        print("failed");
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  //Contact Form
  Future<bool> userContactForm(Map parameters) async {
    try {
      var response = await http.post(
        Uri.parse(Api.contactform),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(parameters),
      );
      var success = json.decode(response.body)['success'];
      if (response.statusCode == 200 && success == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

//Get Favorites
  Future<List<UserAccount>> getFavorites() async {
    var token = await sessionDataProvider.readsAccessToken();
    try {
      var response = await http.get(
        Uri.parse(Api.getFavorites),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        },
      );
      var data = json.decode(response.body)['data'];
      if (response.statusCode == 200) {
        print('success');
        var dd = (data as List).map((e) => UserAccount.fromJson(e)).toList();
        return dd;
        // return userAccont;
      } else if (response.statusCode == 401 || isAcces_Token_TimerActive) {
        bool isTrue = await refreshToken();
        if (isTrue) {
          // If refresh token was successful, retry the original request
          return await getFavorites();
        } else {
          // If refresh token failed, log user out and navigate to login page
          sessionDataProvider.deleteAllToken();
          // navigate to login page
        }
      } else {
        print("failed");
      }
    } catch (e) {
      print(e);
    }
    return [];
  }


  //Save Favorite
  Future<Map<String,bool>> saveFavorite(Map parameters) async {
    var token = await sessionDataProvider.readsAccessToken();
    try {
      var response = await http.post(
        Uri.parse(Api.saveFavorite),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $token'
        },
        body: json.encode(parameters),
      );
       var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('success');
        var statusCode = response.statusCode ;
        return {'success':true};

      } else if (isAcces_Token_TimerActive || response.statusCode == 401) {
        bool isTrue = await refreshToken();

        if (isTrue) {
          return await saveFavorite(parameters); // Call saveFavorite recursively after refreshing token
        } else {
          return {'error':false};
        }
      } else if (response.statusCode == 400){
        var statusCode = response.statusCode ;
        return {'already':true};


      }else {
        print("failed");
        return {'error':false};
      }
    } catch (e) {
      print(e);
      return {'error':false};
    }
  }


  //Delete Favorite
  Future<Object> deleteFavorite(Map<String,dynamic> parameters) async {
    var token = await sessionDataProvider.readsAccessToken();
    try {
      var response = await http.delete(
        Uri.parse(Api.updateFavorite),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $token'
        },
        body: json.encode(parameters),
      );
      var success = json.decode(response.body)['message'];
      if (response.statusCode == 200) {
        print('Delete $success');
        return true;
      } else if (isAcces_Token_TimerActive || response.statusCode == 401) {
        bool isTrue = await refreshToken();

        if (isTrue) {
          return await saveFavorite(parameters); // Call saveFavorite recursively after refreshing token
        } else {
          return false;
        }
      }else {
        print('Delete $success');
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> refreshToken() async {
    final refresh_token = await sessionDataProvider.readRefreshToken();
    final access_token = await sessionDataProvider.readsAccessToken();
    if (refresh_token != null) {
      try {
        final client = http.Client();
        final response = await client.post(Uri.parse(Api.refreshToken),
            headers: {
              'Authorization': 'bearer $access_token',
              'Content-Type': "application/json",
            },
            body: <String, dynamic>{'refresh_token': '$refresh_token'}).timeout(Duration(seconds: 30));

        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);
          var new_access_token = body['access_token'];
          if (new_access_token == null) {
            // Invalid response, handle error
            print('Invalid response body: $body');
            return false;
          }
          sessionDataProvider.setAccessToken(new_access_token);
          return true;
        } else if (response.statusCode == 401) {
          // Unauthorized, token expired or invalid
          var body = jsonDecode(response.body);
          if (body['error'] == 'invalid_grant') {
            // Refresh token expired or invalid, prompt user to log in again
            sessionDataProvider.deleteAllToken();
          } else {
            // Access token expired or invalid, refresh token still valid, try again
            await Future.delayed(Duration(seconds: 5)); // Wait for 5 seconds before retrying
            return await refreshToken();
          }
        } else {
          // Other error, handle appropriately
          print('Request failed with status code: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        // Network or server error, handle appropriately
        print('Request failed: $e');
        return false;
      }
    }
    return false;
  }



  Future<bool> postFCMToken(Map parameters) async {
    try {
      var response = await http.post(
        Uri.parse(api_url + '/notifications/create-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(parameters),
      );
      var success = json.decode(response.body)['success'];
      if (response.statusCode == 200 && success == true) {
        print('success');
        return true;
      } else {
        print("failed");
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<String?> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      return deviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    return '';
  }
}

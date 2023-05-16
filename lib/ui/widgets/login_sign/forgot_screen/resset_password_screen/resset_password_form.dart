// import 'package:flutter/material.dart';
// import 'package:mashtoz_flutter/config/palette.dart';
// import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
// import 'package:mashtoz_flutter/ui/widgets/login_sign/forgot_screen/verify_code_screen.dart/verify_code_screen.dart';

// class RessetPasswordForm extends StatefulWidget {

//   const RessetPasswordForm({Key? key}) : super(key: key);

//   @override
//   _RessetPasswordFormState createState() => _RessetPasswordFormState();
// }

// class _RessetPasswordFormState extends State<RessetPasswordForm> {
//   final userDataProvder = UserDataProvider();

//   final formKey = GlobalKey<FormState>();
//   final controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   SizedBox(height: 40.0),
//                   TextFormField(
//                     // controller: controller,
//                     cursorColor: Palette.cursor,
//                     style: TextStyle(color: Palette.textLineOrBackGroundColor),
//                     decoration: InputDecoration(
//                       focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Palette.textLineOrBackGroundColor)),
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Palette.textLineOrBackGroundColor)),
//                       labelText: 'Նոր գաղտնաբառ',
//                       labelStyle: TextStyle(
//                         fontFamily: 'GHEAGrapalat',
//                         fontSize: 14,
//                         color: Palette.labelText,
//                       ),
//                       focusColor: Palette.labelText,
//                     ),
//                     validator: (value) {
//                       if (!value!.contains(RegExp(r'[A-Z,a-z,0-9]{6}'))) {
//                         return 'Մուտքագրված հասցեն սխալ է';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 40.0),
//                   TextFormField(
//                     // controller: controller,
//                     cursorColor: Palette.cursor,
//                     style: TextStyle(color: Palette.textLineOrBackGroundColor),
//                     decoration: InputDecoration(
//                       focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Palette.textLineOrBackGroundColor)),
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Palette.textLineOrBackGroundColor)),
//                       labelText: 'Կրկնել գաղտնաբառը',
//                       labelStyle: TextStyle(
//                         fontFamily: 'GHEAGrapalat',
//                         fontSize: 14,
//                         color: Palette.labelText,
//                       ),
//                       focusColor: Palette.labelText,
//                     ),
//                     validator: (value) {
//                       if (!value!.contains(RegExp(
//                         r'[A-Z,a-z,0-9]{6}',
//                       ))) {
//                         return 'Մուտքագրված հասցեն սխալ է';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 40.0),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: SizedBox(
//                       width: 47,
//                       child: RawMaterialButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => VerifyCodeScreen(
//                                       userEmail: '',
//                                     )),
//                           );
//                           if (formKey.currentState!.validate()) {
//                             final _email = controller.text;
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Processing Data')),
//                             );
//                             userDataProvder.forgotPasswordPost(_email,
//                                 (success) {
//                               if (success == true) {
//                                 userDataProvder.sendCode(_email, (sucess) {
//                                   if (success == true) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               VerifyCodeScreen(
//                                                 userEmail: _email,
//                                               )),
//                                     );
//                                   }
//                                 });
//                               }
//                             });
//                           }
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           // mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             SizedBox(
//                               width: 47,
//                               height: 50,
//                               child: Image(
//                                 image: AssetImage(
//                                     "assets/images/login_button.png"),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

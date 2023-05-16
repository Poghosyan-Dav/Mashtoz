// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:mashtoz_flutter/config/palette.dart';

// import 'book_page.dart';

// class ReadScreenMenu extends StatefulWidget {
//   const ReadScreenMenu({Key? key, required this.isVisibility})
//       : super(key: key);

//   final bool isVisibility;

//   @override
//   State<ReadScreenMenu> createState() =>
//       _ReadScreenMenuState(isVisibility: isVisibility);
// }

// class _ReadScreenMenuState extends State<ReadScreenMenu> {
//   _ReadScreenMenuState({required this.isVisibility});

//   bool isBovandakMenu = false;
//   bool isFavorite = false;
//   bool isSettings = false;
//   bool isShare = false;
//   final bool isVisibility;
//   bool isYoutubeActive = false;

//   Widget hideMenuAppBar() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Stack(children: [
//             SizedBox(
//                 height: 20,
//                 width: 50,
//                 child: Center(
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: SvgPicture.asset(
//                       'assets/images/arrow.svg',
//                       width: 20,
//                     ),
//                   ),
//                 )),
//           ]),
//         ),
//         Expanded(
//           flex: 5,
//           child: Container(
//               child: InkWell(
//             onTap: () => setState(() {
//               isBovandakMenu = !isBovandakMenu;
//               print("BovandakMenu :: $isBovandakMenu");
//             }),
//             child: SvgPicture.asset(
//               'assets/images/bovandakutyun_menu.svg',
//               color: isBovandakMenu ? Palette.whenTapedButton : null,
//               width: 30,
//             ),
//           )),
//         ),
//         Expanded(
//           child: SizedBox(
//             // height: 120,
//             // width: 32,
//             child: Stack(children: [
//               SizedBox(
//                   height: 80,
//                   width: 50,
//                   child: Center(
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           isFavorite = !isFavorite;
//                           print("Favorite :: $isFavorite");
//                         });
//                       },
//                       child: SvgPicture.asset(
//                         'assets/images/favorite.svg',
//                         width: 20,
//                       ),
//                     ),
//                   )),
//             ]),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget hideBottomBarMenu() {
//     final mediaQuery = MediaQuery.of(context).size;
//     return Stack(
//       children: [
//         Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.only(top: 10.0),
//               color: isBovandakMenu
//                   ? Color.fromRGBO(31, 31, 31, 0.5)
//                   : Palette.textLineOrBackGroundColor,
//               height: 181,
//               width: double.infinity,
//               child: Column(children: [
//                 SizedBox(height: 10.0),
//                 hideMenuAppBar(),
//                 SizedBox(
//                     width: 200,
//                     child: Text(
//                       'Սբ. Թերեզա Հիսուս Մանկան (1873-1897)',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           color: Color.fromRGBO(25, 4, 18, 1),
//                           fontSize: 12,
//                           letterSpacing: 0,
//                           fontWeight: FontWeight.normal,
//                           height: 1),
//                     )),
//                 SizedBox(
//                   height: 17.0,
//                 ),
//                 SizedBox(
//                     width: 200,
//                     child: Text(
//                       'ԵՐԳԵԼ ՏԻՐՈՋ ՈՂՈՐՄՈՒԹՅՈՒՆԸ',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           color: Color.fromRGBO(25, 4, 18, 1),
//                           fontSize: 12,
//                           letterSpacing: 0,
//                           fontWeight: FontWeight.bold,
//                           height: 1),
//                     )),
//               ]),
//             ),
//             isVisibility
//                 ? Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       color: isYoutubeActive
//                           ? Color.fromRGBO(31, 31, 31, 0.5)
//                           : Palette.textLineOrBackGroundColor,
//                       height: 80,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 child: InkWell(
//                               onTap: () => setState(
//                                   () => isYoutubeActive = !isYoutubeActive),
//                               child: SvgPicture.asset(
//                                 'assets/images/youtube.svg',
//                                 color: isYoutubeActive
//                                     ? Palette.whenTapedButton
//                                     : null,
//                               ),
//                             )),
//                             SizedBox(width: 80),
//                             Expanded(child: Text('11/365')),
//                             Expanded(
//                                 child: SvgPicture.asset(
//                                     'assets/images/share.svg')),
//                             Expanded(
//                                 child: SvgPicture.asset(
//                                     'assets/images/settings.svg')),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 : Container(),
//             isBovandakMenu
//                 ? Positioned(
//                     top: 90,
//                     child: Container(
//                       color: Palette.textLineOrBackGroundColor,
//                       height: mediaQuery.height,
//                       width: mediaQuery.width,
//                       child: Column(
//                         children: [
//                           Container(
//                             color: Palette.whenTapedButton,
//                             height: 3.0,
//                           ),
//                           GlobalBovandakLists(),
//                         ],
//                       ),
//                     ),
//                   )
//                 : Container(),
//             isYoutubeActive ? youtubrShow() : Container()
//           ],
//         ),
//       ],
//     );
//   }

//   Widget youtubrShow() {
//     final mediaQuery = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 80.0),
//       child: Container(
//         color: Color.fromRGBO(31, 31, 31, 0.5),
//         child: Stack(
//           children: [
//             Positioned(
//               top: mediaQuery.height / 4,
//               child: Container(
//                 color: Palette.textLineOrBackGroundColor,
//                 height: 500,
//                 width: mediaQuery.width,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.all(12.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 20.0),
//                             Text(
//                               'Կայքին օգնելու համար կարող եք դիտել / \n\nունկնդրել այս տեսանյութը։\n\nՇնորհակալություն կանխավ։',
//                               style: TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 95.0),
//                             Container(
//                                 color: Colors.red.shade500,
//                                 height: 250,
//                                 width: 400,
//                                 child: Center(child: Text('Youtube link'))),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       color: Palette.whenTapedButton,
//                       height: 3.0,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget favoriteShow() {
//     final mediaQuery = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 80.0),
//       child: Container(
//         color: Color.fromRGBO(31, 31, 31, 0.5),
//         child: Stack(
//           children: [
//             Positioned(
//               top: 90,
//               child: Container(
//                 color: Palette.textLineOrBackGroundColor,
//                 height: mediaQuery.height,
//                 width: mediaQuery.width,
//                 child: Column(
//                   children: [
//                     Container(
//                       color: Palette.whenTapedButton,
//                       height: 3.0,
//                     ),
//                     GlobalBovandakLists(),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context).size;
//     return isVisibility
//         ? Stack(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(top: 10.0),
//                     color: isBovandakMenu
//                         ? Color.fromRGBO(31, 31, 31, 0.5)
//                         : Palette.textLineOrBackGroundColor,
//                     height: 181,
//                     width: double.infinity,
//                     child: Column(children: [
//                       SizedBox(height: 10.0),
//                       hideMenuAppBar(),
//                       SizedBox(
//                           width: 200,
//                           child: Text(
//                             'Սբ. Թերեզա Հիսուս Մանկան (1873-1897)',
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                                 color: Color.fromRGBO(25, 4, 18, 1),
//                                 fontSize: 12,
//                                 letterSpacing: 0,
//                                 fontWeight: FontWeight.normal,
//                                 height: 1),
//                           )),
//                       SizedBox(
//                         height: 17.0,
//                       ),
//                       SizedBox(
//                           width: 200,
//                           child: Text(
//                             'ԵՐԳԵԼ ՏԻՐՈՋ ՈՂՈՐՄՈՒԹՅՈՒՆԸ',
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                                 color: Color.fromRGBO(25, 4, 18, 1),
//                                 fontSize: 12,
//                                 letterSpacing: 0,
//                                 fontWeight: FontWeight.bold,
//                                 height: 1),
//                           )),
//                     ]),
//                   ),
//                   isVisibility
//                       ? Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             color: isYoutubeActive
//                                 ? Color.fromRGBO(31, 31, 31, 0.5)
//                                 : Palette.textLineOrBackGroundColor,
//                             height: 80,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                       child: InkWell(
//                                     onTap: () => setState(() =>
//                                         isYoutubeActive = !isYoutubeActive),
//                                     child: SvgPicture.asset(
//                                       'assets/images/youtube.svg',
//                                       color: isYoutubeActive
//                                           ? Palette.whenTapedButton
//                                           : null,
//                                     ),
//                                   )),
//                                   SizedBox(width: 80),
//                                   Expanded(child: Text('11/365')),
//                                   Expanded(
//                                       child: SvgPicture.asset(
//                                           'assets/images/share.svg')),
//                                   Expanded(
//                                       child: SvgPicture.asset(
//                                           'assets/images/settings.svg')),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       : Container(),
//                   isBovandakMenu
//                       ? Positioned(
//                           top: 90,
//                           child: Container(
//                             color: Palette.textLineOrBackGroundColor,
//                             height: mediaQuery.height,
//                             width: mediaQuery.width,
//                             child: Column(
//                               children: [
//                                 Container(
//                                   color: Palette.whenTapedButton,
//                                   height: 3.0,
//                                 ),
//                                 GlobalBovandakLists(),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Container(),
//                   isYoutubeActive ? youtubrShow() : Container()
//                 ],
//               ),
//             ],
//           )
//         : Container();
//   }
// }

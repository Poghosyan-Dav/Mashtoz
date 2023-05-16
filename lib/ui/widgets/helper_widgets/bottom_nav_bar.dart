// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:mashtoz_flutter/config/palette.dart';

// import '../buttons/bottom_navigation_bar/bottom_app_bar.dart';
// import '../main_page/home_screen.dart';
// enum BottomIcons {
//   home,
//   library,
//   search,
//   italian,
//   account,
//   initall,
// }
// class MyBottomNavBar extends StatefulWidget {
//   const MyBottomNavBar({ Key? key }) : super(key: key);

//   @override
//   State<MyBottomNavBar> createState() => _MyBottomNavBarState();
// }

// class _MyBottomNavBarState extends State<MyBottomNavBar> {
// BottomIcons icons = BottomIcons.initall;

//   ScreenName secrenName = ScreenName.book;

//   bool isAccount = false;

//   bool isHome = false;

//   bool isItalian = false;

//   bool isLibrary = false;

//   bool isSearch = false;

//   List<String> pageKeys = [
//     'homepage',
//     'librarypage',
//     'searchpage',
//     "italianpage",
//     'accountpage'
//   ];

//   Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
//     "homepage": GlobalKey<NavigatorState>(),
//     "librarypage": GlobalKey<NavigatorState>(),
//     "searchpage": GlobalKey<NavigatorState>(),
//     "italianpage": GlobalKey<NavigatorState>(),
//     "accountpage": GlobalKey<NavigatorState>(),
//   };

//   String _currentPage = "homepage";

//   var _currentIndex = 0;

//   void _selectTab(String tabItem, int index) {
//     if (tabItem == _currentIndex) {
//       _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
//     } else {
//       setState(() {
//         _currentPage = pageKeys[index];
//         _currentIndex = index;
//       });
//     }
//   }

//   tirgleColor() {
//     return icons == BottomIcons.library
//         ? Palette.libraryBacgroundColor
//         : false || icons == BottomIcons.home
//             ? Palette.textLineOrBackGroundColor
//             : false || icons == BottomIcons.search
//                 ? Palette.searchBackGroundColor
//                 : false || icons == BottomIcons.italian
//                     ? Palette.textLineOrBackGroundColor
//                     : false || icons == BottomIcons.account
//                         ? Palette.textLineOrBackGroundColor
//                         : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  SizedBox(
//       height: 80,
//       // padding: const EdgeInsets.only(top: 14),
//       child: Stack(
//         children: [
//           Container(
//             color: tirgleColor(),
//             width: double.infinity,
//             height: 20,
//             // color: Colors.black,
//             child: Row(
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 icons == BottomIcons.home
//                     ? Expanded(
//                         child: CustomPaint(
//                           size: const Size(42, 22),
//                           painter: Triangle(),
//                         ),
//                       )
//                     : Expanded(child: Container()),
//                 icons == BottomIcons.library
//                     ? Expanded(
//                         child: CustomPaint(
//                           size: const Size(42, 22),
//                           painter: Triangle(),
//                         ),
//                       )
//                     : Expanded(child: Container()),
//                 icons == BottomIcons.search
//                     ? Expanded(
//                         child: CustomPaint(
//                           size: const Size(42, 22),
//                           painter: Triangle(),
//                         ),
//                       )
//                     : Expanded(child: Container()),
//                 icons == BottomIcons.italian
//                     ? Expanded(
//                         child: CustomPaint(
//                           size: const Size(42, 22),
//                           painter: Triangle(),
//                         ),
//                       )
//                     : Expanded(child: Container()),
//                 icons == BottomIcons.account
//                     ? Expanded(
//                         child: CustomPaint(
//                           size: const Size(42, 22),
//                           painter: Triangle(),
//                         ),
//                       )
//                     : Expanded(child: Container()),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.only(top: 20),
//             height: 100,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Expanded(
//                   child: SizedBox.expand(
//                     child: Container(
//                       height: 55,
//                       color: const Color.fromRGBO(83, 66, 77, 1),
//                       child: Row(
//                         children: [
//                           // const SizedBox(width: 22.0),
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: BottomBar(
//                                 onPressed: () {
//                                   // print('home');
//                                   setState(() {
//                                     // onItemTaped(0);
//                                     _selectTab(pageKeys[0], 0);
//                                     setState(() {
//                                       icons = BottomIcons.home;
//                                     });
//                                     isHome = true;
//                                     isLibrary = false;
//                                     isSearch = false;
//                                     isItalian = false;
//                                     isAccount = false;
//                                   });
//                                 },
//                                 bottomIcons:
//                                     icons == BottomIcons.home ? true : false,
//                                 path: SvgPicture.asset(
//                                   'assets/images/home.svg',
//                                   color: isHome ? Palette.cursor : null,
//                                   width: 25,
//                                   height: 30,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           //  const SizedBox(width: 45.0),
//                           Expanded(
//                             child: BottomBar(
//                               onPressed: () {
//                                 //  print('library');
//                                 setState(() {
//                                   icons = BottomIcons.library;
//                                   // onItemTaped(1);
//                                   _selectTab(pageKeys[1], 1);
//                                   isLibrary = true;

//                                   isHome = false;
//                                   isSearch = false;
//                                   isItalian = false;
//                                   isAccount = false;
//                                 });
//                               },
//                               bottomIcons:
//                                   icons == BottomIcons.library ? true : false,
//                               path: SvgPicture.asset(
//                                 'assets/images/library.svg',
//                                 color: isLibrary ? Palette.cursor : null,
//                                 width: 25,
//                                 height: 30,
//                               ),
//                             ),
//                           ),
//                           //const SizedBox(width: 45.0),
//                           Expanded(
//                             child: BottomBar(
//                                 onPressed: () {
//                                   // print('search');

//                                   //onItemTaped(2);
//                                   _selectTab(pageKeys[2], 2);
//                                   icons = BottomIcons.search;
//                                   isSearch = true;
//                                   isHome = false;
//                                   isLibrary = false;
//                                   isItalian = false;
//                                   isAccount = false;
//                                 },
//                                 bottomIcons:
//                                     icons == BottomIcons.search ? true : false,
//                                 path: SvgPicture.asset(
//                                   'assets/images/search.svg',
//                                   color: isSearch ? Palette.cursor : null,
//                                   width: 25,
//                                   height: 27,
//                                 )),
//                           ),
//                           // const SizedBox(width: 45.0),
//                           Expanded(
//                             child: BottomBar(
//                               onPressed: () {
//                                 //    print('italian');
//                                 setState(() {
//                                   icons = BottomIcons.italian;
//                                   // _currentIndex = 3;
//                                   _selectTab(pageKeys[3], 3);
//                                   isItalian = true;
//                                   isHome = false;
//                                   isLibrary = false;
//                                   isSearch = false;
//                                   isAccount = false;
//                                 });
//                               },
//                               bottomIcons:
//                                   icons == BottomIcons.italian ? true : false,
//                               path: SvgPicture.asset(
//                                 'assets/images/italian_lessons.svg',
//                                 color: isItalian ? Palette.cursor : null,
//                                 width: 25,
//                                 height: 30,
//                               ),
//                             ),
//                           ),
//                           // const SizedBox(width: 40.0),
//                           Expanded(
//                             child: BottomBar(
//                               onPressed: () {
//                                 //    print('account');
//                                 setState(() {
//                                   //    onItemTaped(4);
//                                   _selectTab(pageKeys[4], 4);
//                                   icons = BottomIcons.account;
//                                   isAccount = true;
//                                   isHome = false;
//                                   isLibrary = false;
//                                   isSearch = false;
//                                   isItalian = false;
//                                 });
//                               },
//                               bottomIcons:
//                                   icons == BottomIcons.account ? true : false,
//                               path: SvgPicture.asset(
//                                 'assets/images/profile.svg',
//                                 color: isAccount ? Palette.cursor : null,
//                                 width: 25,
//                                 height: 27,
//                               ),
//                             ),
//                           ),
//                           //const SizedBox(width: 40.0),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
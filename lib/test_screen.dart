// import 'package:flutter/material.dart';
// import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
// import 'package:mashtoz_flutter/globals.dart';

// import 'ui/widgets/helper_widgets/top_menu_model_sheet.dart';

// class TestsScreen extends StatefulWidget {
//   const TestsScreen({Key? key}) : super(key: key);

//   @override
//   State<TestsScreen> createState() => _TestsScreenState();
// }

// class _TestsScreenState extends State<TestsScreen> {
//   final bookDataProvider = BookDataProvider();
//   final _topModalSheetKey = GlobalKey<TopModalSheetState>();
//   var _topModalData = "";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         brightness: Brightness.dark,
//         centerTitle: true,
//         title: const Text("TopModalSheet sample"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//                 child: Center(
//               child: Text("$_topModalData"),
//             )),
//             Row(
//               children: [
//                 Expanded(
//                     child: MaterialButton(
//                   color: Colors.white,
//                   elevation: 5,
//                   child: const Text("Show TopModal 1"),
//                   onPressed: () async {
//                     var value = await showTopModalSheet<String>(
//                         context: context, child: DumyModal());

//                     if (value != null) {
//                       setState(() {
//                         _topModalData = value;
//                       });
//                     }
//                   },
//                 )),
//                 const VerticalDivider(),
//                 Expanded(
//                     child: MaterialButton(
//                   color: Colors.white,
//                   elevation: 5,
//                   child: const Text("Show TopModal 2"),
//                   onPressed: () async {
//                     var value = await Navigator.of(context)
//                         .push<List<int>>(PageRouteBuilder(
//                             pageBuilder: (_, __, ___) {
//                               return TopModalSheet(
//                                 key: _topModalSheetKey,
//                                 child: Container(
//                                     color: Colors.teal,
//                                     height:
//                                         MediaQuery.of(context).size.height * .2,
//                                     child: Center(
//                                         child: MaterialButton(
//                                       color: Colors.white,
//                                       child: const Text(
//                                         "Back",
//                                         style: TextStyle(color: Colors.teal),
//                                       ),
//                                       onPressed: () {
//                                         _topModalSheetKey.currentState
//                                             ?.onBackPressed(data: [1, 2, 3]);
//                                       },
//                                     ))),
//                               );
//                             },
//                             opaque: false));

//                     if (value != null) {
//                       setState(() {
//                         _topModalData = "$value";
//                       });
//                     }
//                   },
//                 )),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DumyModal extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).primaryColor,
//       height: MediaQuery.of(context).size.height * .3,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           Padding(
//             padding:
//                 EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
//             child: const Text("Choose Wisely",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//                 textAlign: TextAlign.center),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Expanded(
//                     child: Padding(
//                   padding: const EdgeInsets.only(left: 10, right: 5),
//                   child: OutlineButton(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     child: Text('dadas'),
//                     splashColor: Colors.white,
//                     highlightedBorderColor: Colors.teal,
//                     onPressed: () {
//                       Navigator.of(context).pop("Maquina");
//                     },
//                   ),
//                 )),
//                 Expanded(
//                     child: Padding(
//                   padding: const EdgeInsets.only(left: 5, right: 10),
//                   child: OutlineButton(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     child: Text('dadas'),
//                     splashColor: Colors.white,
//                     highlightedBorderColor: Colors.teal,
//                     onPressed: () {
//                       Navigator.of(context).pop("Monarcas");
//                     },
//                   ),
//                 ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mashtoz_flutter/config/palette.dart';
// import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
// import 'package:mashtoz_flutter/globals.dart';
// import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/dictionary_screen/aarm_italy_dictionary.dart';

// class Dictionary extends StatefulWidget {
//   const Dictionary({Key? key}) : super(key: key);

//   @override
//   _DictionaryState createState() => _DictionaryState();
// }

// class _DictionaryState extends State<Dictionary>
//     with SingleTickerProviderStateMixin {
//   // late TabController _controller;

//   @override
//   void initState() {
//     // _controller = TabController(length: 2, vsync: this);

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               title: ActionsHelper(
//                 //botomPadding: 55,
//                 text: 'Բառարան',
//                 fontFamily: 'GHEAGrapalat',
//                 rightPadding: 10.0,
//                 fontSize: 20,
//                 laterSpacing: 1,
//                 fontWeight: FontWeight.bold,
//                 color: Palette.appBarTitleColor,
//               ),
//               expandedHeight: 73,
//               backgroundColor: Palette.textLineOrBackGroundColor,
//               elevation: 0,
//               automaticallyImplyLeading: false,
//               systemOverlayStyle: SystemUiOverlayStyle(
//                   statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
//             ),
//             // SliverFillRemaining(
//             //   hasScrollBody: false,
//             //   child: DefaultTabController(
//             //     length: 2,
//             //     child: Scaffold(
//             //       appBar: AppBar(
//             //         elevation: 0.0,
//             //         toolbarHeight: 11,
//             //         backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
//             //         bottom: TabBar(
//             //           indicatorWeight: 2,
//             //           unselectedLabelColor:
//             //               const Color.fromRGBO(122, 108, 115, 1),
//             //           labelColor: const Color.fromRGBO(251, 196, 102, 1),
//             //           indicatorColor: Colors.amber,
//             //           controller: _controller,
//             //           tabs: const <Widget>[
//             //             Padding(
//             //               padding: EdgeInsets.only(bottom: 5),
//             //               child: Tab(
//             //                 child: Text(
//             //                   'Հայերեն-\nԻտալերեն',
//             //                   textAlign: TextAlign.center,
//             //                   style: TextStyle(fontWeight: FontWeight.bold),
//             //                 ),
//             //               ),
//             //             ),
//             //             Padding(
//             //               padding: EdgeInsets.only(bottom: 5),
//             //               child: Tab(
//             //                 child: Text(
//             //                   'Իտալերեն-\nՀայերեն',
//             //                   textAlign: TextAlign.center,
//             //                   style: TextStyle(fontWeight: FontWeight.bold),
//             //                 ),
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //       ),
//             //       body: TabBarView(
//             //         controller: _controller,
//             //         children: const <Widget>[
//             //
//             //           _ItalianArmenian(),
//             //         ],
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             SliverFillRemaining(
//               hasScrollBody: false,
//               child: Column(
//                 children: [
//                   Container(
//                     color: Color.fromRGBO(246, 246, 246, 1),
//                     width: double.infinity,
//                     height: 80,
//                     child: Text(
//                       'Սեղմելով ցանկացած տառի վրա կարող եք\n ընթերցել այդ տառին համապատասխան\n նյութերը',
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: 50),
//                   Expanded(child: _ArmenianItalian()),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// //Armenian alphabet Widget
// class _ArmenianItalian extends StatefulWidget {
//   const _ArmenianItalian({Key? key}) : super(key: key);

//   @override
//   State<_ArmenianItalian> createState() => _ArmenianItalianState();
// }

// class _ArmenianItalianState extends State<_ArmenianItalian> {
//   Future<List<String>?>? charctersData;
//   final bookDataProvider = BookDataProvider();
//   @override
//   void initState() {
//     charctersData = bookDataProvider
//         .getDialect_Encyclopaedia_Characters(Api.encyclopediasCharacters);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: FutureBuilder<List<String>?>(
//         future: charctersData,
//         builder: (context, snapshot) {
//           var characters = snapshot.data as List<String>;

//           if (snapshot.hasData) {
//             return Scaffold(
//               body: GridView.count(
//                 mainAxisSpacing: 30,
//                 crossAxisCount: 7,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: List.generate(wordsArm.length, (index) {
//                   return Center(
//                     child: InkWell(
//                       onTap: characters
//                               .toString()
//                               .toLowerCase()
//                               .contains(wordsArm[index])
//                           ? () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (_) => DictionaryArmItl(
//                                             characters: characters,
//                                             characterByindex: wordsArm[index],
//                                             characterIndex: index,
//                                             isShow: true,
//                                           )));
//                             }
//                           : null,
//                       child: Text(
//                         '${wordsArm[index]}',
//                         style: TextStyle(
//                           fontFamily: 'ArshaluyseArtU',
//                           fontSize: 25,
//                           fontStyle: FontStyle.normal,
//                           fontWeight: FontWeight.bold,
//                           color: characters
//                                   .toString()
//                                   .toLowerCase()
//                                   .contains(wordsArm[index])
//                               ? null
//                               : Color.fromRGBO(186, 166, 177, 1),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             );
//           } else {
//             return Container(
//               child: Center(child: CircularProgressIndicator()),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// //Italian alphabet Widget
// class _ItalianArmenian extends StatefulWidget {
//   const _ItalianArmenian({Key? key}) : super(key: key);

//   @override
//   State<_ItalianArmenian> createState() => _ItalianArmenianState();
// }

// class _ItalianArmenianState extends State<_ItalianArmenian> {
//   Future<List<String>?>? charctersData;
//   final bookDataProvider = BookDataProvider();
//   @override
//   void initState() {
//     charctersData = bookDataProvider
//         .getDialect_Encyclopaedia_Characters(Api.italianDictionaryCharacters);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: FutureBuilder<List<String>?>(
//         future: charctersData,
//         builder: (context, snapshot) {
//           var characters = snapshot.data as List<String>;

//           if (snapshot.hasData) {
//             return Scaffold(
//               body: GridView.count(
//                 mainAxisSpacing: 30,
//                 crossAxisCount: 7,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: List.generate(wordsIt.length, (index) {
//                   return Center(
//                     child: InkWell(
//                       onTap: characters
//                               .toString()
//                               .toLowerCase()
//                               .contains(wordsIt[index])
//                           ? () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (_) => DictionaryArmItl(
//                                             characters: characters,
//                                             characterByindex: wordsIt[index],
//                                             characterIndex: index,
//                                             isShow: false,
//                                           )));
//                             }
//                           : null,
//                       child: Text(
//                         '${wordsIt[index]}',
//                         style: TextStyle(
//                           fontFamily: 'ArshaluyseArtU',
//                           fontSize: 35,
//                           fontStyle: FontStyle.normal,
//                           fontWeight: FontWeight.bold,
//                           color: characters
//                                   .toString()
//                                   .toLowerCase()
//                                   .contains(wordsIt[index].toLowerCase())
//                               ? null
//                               : Color.fromRGBO(186, 166, 177, 1),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             );
//           } else {
//             return Container(
//               child: Center(child: CircularProgressIndicator()),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// //Armenian alphabet
// List<String> wordsArm = [
//   'ա',
//   "բ",
//   "գ",
//   "դ",
//   "ե",
//   "զ",
//   "է",
//   "ը",
//   "թ",
//   "ժ",
//   "ի",
//   "լ",
//   "խ",
//   "ծ",
//   "կ",
//   "հ",
//   "ձ",
//   "ղ",
//   "ճ",
//   "մ",
//   "յ",
//   "ն",
//   "շ",
//   "ո",
//   "չ",
//   "պ",
//   "ջ",
//   "ռ",
//   "ս",
//   "վ",
//   "տ",
//   "ր",
//   "ց",
//   "ու",
//   "փ",
//   "ք",
//   "ԵՎ",
//   "Օ",
//   "Ֆ"
// ];
// //English alphabet
// List<String> wordsIt = [
//   'a',
//   'b',
//   'c',
//   'd',
//   'e',
//   'f',
//   'g',
//   'h',
//   'i',
//   'j',
//   'k',
//   'l',
//   'm',
//   'n',
//   'o',
//   'p',
//   'q',
//   'r',
//   's',
//   't',
//   'u',
//   ''
//       'v',
//   'w',
//   'x',
//   'y',
//   'z',
// ];
// import 'package:flutter/material.dart';
// import 'package:mashtoz_flutter/domens/models/book_data/book_channgeNotifire.dart';
// import 'package:mashtoz_flutter/globals.dart';
// import 'package:provider/provider.dart';

// import 'domens/models/book_data/by_caracters_data.dart';

// class TestNotifire extends StatefulWidget {
//   const TestNotifire({Key? key}) : super(key: key);

//   @override
//   State<TestNotifire> createState() => _TestNotifireState();
// }

// class _TestNotifireState extends State<TestNotifire> {
//   Future<List<ByCharacters>?>? futureString;
//   final bookNotifire = BookNotifire();
//   void bookDAta() {}

//   @override
//   void initState() {
//     futureString = bookNotifire
//         .getDataByCharacters(Api.encyclopediasByCharacters('ա'.toUpperCase()));

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Center(
//             child: FutureBuilder<List<ByCharacters>?>(
//                 future: futureString,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var data = snapshot.data;

//                     return ListView.builder(
//                         shrinkWrap: true,
//                         scrollDirection: Axis.vertical,
//                         itemCount: data?.length,
//                         itemBuilder: (context, index) {
//                           var newDAta = data?[index];

//                           return Text('${newDAta?.title}');
//                         });
//                   } else {
//                     return CircularProgressIndicator();
//                   }
//                 }),
//           ),
//           // Align(
//           //   alignment: Alignment.bottomCenter,
//           //   child: Text(
//           //     ,
//           //     style: TextStyle(color: Colors.red),
//           //   ),
//           // )
//         ],
//       ),
//     );
//   }
// }

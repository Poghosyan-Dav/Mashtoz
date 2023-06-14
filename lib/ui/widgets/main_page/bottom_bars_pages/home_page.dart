import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/models/book_data/book_home_data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/category_lsit.dart';
import 'package:mashtoz_flutter/domens/models/book_data/data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';
import 'package:mashtoz_flutter/domens/models/book_data/word_of_day.dart';
import 'package:mashtoz_flutter/domens/models/user.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/globals.dart';
import 'package:mashtoz_flutter/ui/utils/url_data_lounch.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/menuShow.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/bottom_bars_pages/bottom_bar_menu_pages.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/book_read_screen.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/books_page.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/audio_library/audio_library_by_characters.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/dialect/diaelct_by_characters.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/dialect/dialect.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/encyclopedia/encyclopedia.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/encyclopedia/encyclopedia_by_characters.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/italian_lesson/italian_data_show.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../../../domens/models/book_data/content_list.dart';
import '../../../../tab_navigator.dart';
import '../../helper_widgets/size_config.dart';
import '../../youtube_videos/advanced_overlay.dart';
import '../main_menu_pages/audio_library/audio_library.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static Future<WordOfDay?>? wordsOfDayFuture;
  final _sessionDataProvider = SessionDataProvider();
  final ScrollController _firstController = ScrollController();
  ScrollController _scController = ScrollController();
  Future<HomeData>? homeDataFuture;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? _deviceId;
  int? bookCategoryid;
  Content? libraries;
  List<Lessons>? lessons;
  List<String>? encyclopedias;
  String? audiolibraries;
  List<String>? dialects;
  Users? _users ;
  var charDialects = <String>[];
  var charEncyc = <String>[];
  var charAudio = <String>[];
  List<Data>? e, a, d;
  var encyData = <Data>[];
  var dailectData = <Data>[];
  bool hasData = true;
  bool _enabled = true;
  String? author;
  bool userHasToken = false;
  String? summary;
  Content? books;
  String charTitle = '';
  final _bookDataProvider = BookDataProvider();
  final _userDataProvider = UserDataProvider();
  bool _isAppbar = true;
  ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    initPlatformState();
    _userDataProvider.fetchUserInfo().then((value) {
      if(value!=null)_users= value;
    });
   wordsOfDayFuture = _bookDataProvider.getWordsOfDay();
  _fetchHomeData();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        appBarStatus(false);
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        appBarStatus(true);
      }
    });

    hasToken() ;
    super.initState();
  }

 Future<void> _fetchHomeData()async{
   getToken();
   _bookDataProvider
      .getDialect_Encyclopaedia_Characters(Api.dialectCharacters).then((value) {

    charDialects = value;
  });
  _bookDataProvider
      .getDialect_Encyclopaedia_Characters(Api.encyclopediasCharacters).then((value) {

    charEncyc = value;
  });
  _bookDataProvider
      .getDialect_Encyclopaedia_Characters(Api.audioLibrariesCharacters).then((value) {

    charAudio = value;
  });


  homeDataFuture = _bookDataProvider.getHomeData().then((value) {
    audiolibraries = value.audiolibraries;
    encyclopedias = value.encyclopedias;
    lessons = value.lessons;
    libraries = value.libraries;
    dialects = value.dialects;

    _bookDataProvider
        .getDataByCharactersForHome(
        Api.encyclopediasByCharacters(value.encyclopedias?.first))
        .then((value) {
      setState(() {
        e = value;
      });
    });

    _bookDataProvider
        .getDataByCharactersForHome(Api.dialectBYCharacters(value.dialects?.first))
        .then((value) {
      setState(() {
        d = value;
      });
    });
    _bookDataProvider
        .getDataByCharactersForHome(
        Api.audioLibrariesByCharacters(value.audiolibraries))
        .then((value) {
      setState(() {
        a = value;
      });
    });


    return value;
  });

}
  void getToken() async {

    String? token = await messaging.getToken();

    if (token != null && _deviceId != null) {
      var data = {'device_id': _deviceId, 'fcm_token': token};
      print("device_id : ${data['device_id']} &\nfcm_token: ${data['fcm_token']}");
      _userDataProvider.postFCMToken(data);
    }

    messaging.onTokenRefresh.listen((newToken) {
      if (newToken != null && _deviceId != null) {
        var data = {'device_id': _deviceId, 'fcm_token': token};
        print("device_id : ${data['device_id']} &\nfcm_token: ${data['fcm_token']}");
        _userDataProvider.postFCMToken(data);
      }
    });
  }
  Future<void> hasToken() async{
    String? hasToken = await _sessionDataProvider.readsAccessToken();
    if(hasToken != null){

      userHasToken =  true;

    }
    userHasToken =    false;
  }
  void appBarStatus(bool status) {
    setState(() {
      _isAppbar = status;
    });
  }
  @override
  void dispose() {
    _scController.dispose();
    _firstController.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // context.watch<UserLogOutNotifier>().saveUserName();

    return  ConnectivityBuilder(
        builder:(context,isConnect,status){
          if(isConnect==true){
            if (libraries != null) {
              return SafeArea(
                child: Theme(
                  data: ThemeData(
                      textSelectionTheme:
                      const TextSelectionThemeData(cursorColor: Colors.amber)),
                  child: Scaffold(
                    backgroundColor: Palette.textLineOrBackGroundColor,
                    extendBodyBehindAppBar: true,
                    body: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              // Align(
                              //     alignment: Alignment.topCenter,
                              //     child: Container(
                              //       padding: EdgeInsets.only(
                              //           left: 20.0, right: 20.0),
                              //       height: 53,
                              //       width: SizeConfig.screenWidth! >= 1200
                              //           ? 1200
                              //           : SizeConfig.screenWidth,
                              //       child: Row(
                              //         mainAxisAlignment:
                              //         MainAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             'Օրվա խոսք',
                              //             style: TextStyle(
                              //                 fontSize: 20,
                              //                 letterSpacing: 1,
                              //                 fontFamily: 'GHEAGrapalat',
                              //                 fontWeight: FontWeight.bold,
                              //                 color: Palette.appBarTitleColor),
                              //           ),
                              //           Spacer(),
                              //           Align(
                              //             alignment: Alignment.centerRight,
                              //             child: MenuShow(),
                              //           ),
                              //         ],
                              //       ),
                              //     )),
                              RawScrollbar(
                                controller: _scrollController,
                                thumbColor: Palette.whenTapedButton,
                                thickness: 3,
                                radius: const Radius.circular(12),
                                crossAxisMargin: 3.0,
                                thumbVisibility: true,
                                child: Center(
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    height: MediaQuery.of(context).size.height,
                                    child: SingleChildScrollView(
                                        controller:_scController,
                                        child: Center(
                                          child: Column(
                                            children: [

                                              // //!!header Օրվա խոսք
                                              // Container(
                                              //   padding: EdgeInsets.only(
                                              //       left: SizeConfig.screenWidth! >= 1200
                                              //           ? (SizeConfig.screenWidth! - 1200) / 1.9
                                              //           : 20.0),
                                              //   height: 44,
                                              //   width: SizeConfig.screenWidth,
                                              //   child: Row(
                                              //     children: [
                                              //       GestureDetector(
                                              //         onTap: () async {
                                              //           await showDialog(
                                              //               builder: (BuildContext context) {
                                              //                 return Stack(
                                              //                   children: [
                                              //                     Positioned.fill(
                                              //                       top: SizeConfig
                                              //                           .orentation == Orientation.landscape ? 0.0 : 120 ,
                                              //                       child: Align(
                                              //                         alignment:
                                              //                         Alignment.topCenter,
                                              //                         child: Container(
                                              //                             padding:
                                              //                             const EdgeInsets.only(
                                              //                                 right: 20,
                                              //                                 left: 20),
                                              //                             height: 400,
                                              //                             width: SizeConfig
                                              //                                 .orentation == Orientation.landscape ? MediaQuery.of(context).size.width / 2 :
                                              //                             SizeConfig.screenWidth,
                                              //                             child:
                                              //                             TableComplexExample(day: context.watch<FocuseDay>().day,)),
                                              //                       ),
                                              //                     ),
                                              //                   ],
                                              //                 );
                                              //               },
                                              //               context: context);
                                              //         },
                                              //         child: Container(
                                              //           decoration: const BoxDecoration(
                                              //               color: Palette.whenTapedButton,
                                              //               boxShadow: [
                                              //                 BoxShadow(
                                              //                   color: Color.fromRGBO(
                                              //                       0, 0, 0, 0.1),
                                              //                   blurRadius: 1.0,
                                              //                   spreadRadius: 0.0,
                                              //                   offset: Offset(-4, 4),
                                              //                 ),
                                              //               ]),
                                              //           width: 50,
                                              //           height: 44,
                                              //           child: Align(
                                              //               alignment: Alignment.center,
                                              //               child: Stack(
                                              //                 children: [
                                              //                   Center(
                                              //                     child: SvgPicture.asset(
                                              //                         'assets/images/Group5202.svg'),
                                              //                   ),
                                              //                   Center(
                                              //                     child: Text(
                                              //                       '${context.watch<FocuseDay>().day}',
                                              //                       style: const TextStyle(
                                              //                           fontSize: 11,
                                              //                           color: Colors.white),
                                              //                     ),
                                              //                   )
                                              //                 ],
                                              //               )),
                                              //         ),
                                              //       ),
                                              //       const SizedBox(width: 14.0),
                                              //       Expanded(
                                              //         child: Container(
                                              //           width: double.infinity,
                                              //           decoration: const BoxDecoration(
                                              //               color: Color.fromRGBO(
                                              //                   113, 141, 156, 1),
                                              //               boxShadow: [
                                              //                 BoxShadow(
                                              //                   color: Color.fromRGBO(
                                              //                       0, 0, 0, 0.1),
                                              //                   blurRadius: 1.0,
                                              //                   spreadRadius: 0.0,
                                              //                   offset: Offset(-4, 4),
                                              //                 ),
                                              //               ]),
                                              //           height: 44,
                                              //           child: Row(
                                              //             mainAxisAlignment:
                                              //             MainAxisAlignment.start,
                                              //             children: [
                                              //               const SizedBox(width: 14.0),
                                              //               const Text(
                                              //                 'Օրվա խոսք',
                                              //                 style: TextStyle(
                                              //                     fontFamily: 'GHEAGrapalat',
                                              //                     fontSize: 16.0,
                                              //                     fontWeight: FontWeight.w400,
                                              //                     letterSpacing: 1,
                                              //                     color: Palette
                                              //                         .textLineOrBackGroundColor),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              // const SizedBox(height: 14),
                                              // Container(
                                              //   height: 339,
                                              //   width: SizeConfig.screenWidth! >= 1200
                                              //       ? 1200
                                              //       : SizeConfig.screenWidth,
                                              //   color: Palette.textLineOrBackGroundColor,
                                              //   child: FutureBuilder<WordOfDay?>(
                                              //       future: wordsOfDayFuture,
                                              //       builder: (context, snapshot) {
                                              //         var data = snapshot.data;
                                              //
                                              //         if (snapshot.hasData) {
                                              //           author = data?.author;
                                              //           summary = data?.summary;
                                              //           return Stack(
                                              //             children: [
                                              //               Container(
                                              //                 margin: const EdgeInsets.only(
                                              //                     right: 20.0, left: 20.0),
                                              //                 color: const Color.fromRGBO(
                                              //                     246, 246, 246, 1),
                                              //                 child: Stack(
                                              //                   children: [
                                              //                     Positioned.fill(
                                              //                         child: Align(
                                              //                             alignment: Alignment
                                              //                                 .bottomRight,
                                              //                             child: Container(
                                              //                                 padding: const EdgeInsets
                                              //                                     .only(
                                              //                                     left:
                                              //                                     16.0,
                                              //                                     right:
                                              //                                     16.0),
                                              //                                 height: 50,
                                              //                                 child: Row(
                                              //         mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                              //                                   children: [
                                              //                                     Expanded(
                                              //                                       child: Text(
                                              //                                         '${data?.author}',
                                              //                                         textAlign:
                                              //                                         TextAlign
                                              //                                             .left,
                                              //                                         style: TextStyle(fontSize: 12),
                                              //                                       ),
                                              //                                     ),
                                              //                                     Expanded(
                                              //                                       child: GestureDetector(
                                              //                                         onTap:(){
                                              //                                           context
                                              //                                               .read<BottomColorNotifire>()
                                              //                                               .setColor(Palette.searchBackGroundColor);
                                              //                                           Navigator.push(context, MaterialPageRoute(builder: (_)=> const AfterWordsOfDayScreen()));
                                              //                                         },
                                              //                                         child: Text(
                                              //                                           'Նախորդ խոսքեր',
                                              //                                           textAlign:
                                              //                                           TextAlign
                                              //                                               .right,
                                              //
                                              //                                           style: TextStyle(
                                              //                                             color: Colors.grey.shade600,
                                              //                                             fontSize: 12,
                                              //                                             decoration: TextDecoration.underline,
                                              //                                             decorationStyle: TextDecorationStyle.solid,
                                              //                                           ),
                                              //                                         ),
                                              //                                       ),
                                              //                                     ),
                                              //                                   ],
                                              //                                 )))),
                                              //                     Positioned.fill(
                                              //                       top: 14.0,
                                              //                       left: 16.0,
                                              //                       right: 7.0,
                                              //                       bottom: 61,
                                              //                       child: Align(
                                              //                         alignment:
                                              //                         Alignment.topCenter,
                                              //                         child: Container(
                                              //                             color: const Color.fromRGBO(
                                              //                                 246, 246, 246, 1),
                                              //                             width:
                                              //                             double.infinity,
                                              //                             height: 264,
                                              //                             child: Scrollbar(
                                              //                                 thickness: 1.5,
                                              //                                 radius: const Radius
                                              //                                     .circular(12),
                                              //                                 thumbVisibility:
                                              //                                 false,
                                              //                                 showTrackOnHover:
                                              //                                 true,
                                              //                                 child: Center(
                                              //                                     child:
                                              //                                     ListView(
                                              //                                       scrollDirection:
                                              //                                       Axis.vertical,
                                              //                                       shrinkWrap:
                                              //                                       true,
                                              //                                       children: [
                                              //                                         Padding(
                                              //                                             padding: const EdgeInsets
                                              //                                                 .all(
                                              //                                                 12.0),
                                              //                                             child: Text(
                                              //                                                 '${data?.summary}'))
                                              //                                       ],
                                              //                                     )))),
                                              //                       ),
                                              //                     ),
                                              //                     const Positioned.fill(
                                              //                         bottom: 40,
                                              //                         child: Align(
                                              //                           alignment: Alignment
                                              //                               .bottomCenter,
                                              //                           child: Padding(
                                              //                             padding:
                                              //                             EdgeInsets
                                              //                                 .only(
                                              //                                 right: 20.0,
                                              //                                 left: 20.0),
                                              //                             child: Divider(
                                              //                               thickness: 1,
                                              //                             ),
                                              //                           ),
                                              //                         )),
                                              //                   ],
                                              //                 ),
                                              //               ),
                                              //             ],
                                              //           );
                                              //         }
                                              //
                                              //         return Stack(
                                              //           children: [
                                              //             Container(
                                              //               margin: const EdgeInsets.only(
                                              //                   right: 20.0, left: 20.0),
                                              //               color: const Color.fromRGBO(
                                              //                   246, 246, 246, 1),
                                              //               child: Stack(
                                              //                 children: [
                                              //                   Positioned.fill(
                                              //                       child: Align(
                                              //                           alignment: Alignment
                                              //                               .bottomRight,
                                              //                           child: Container(
                                              //                               padding:
                                              //                               const EdgeInsets.only(
                                              //                                   left: 16.0,
                                              //                                   right:
                                              //                                   16.0),
                                              //                               height: 50,
                                              //                               child: Align(
                                              //                                 alignment:
                                              //                                 Alignment
                                              //                                     .center,
                                              //                                 child: Text(
                                              //                                   '${author??''}',
                                              //                                   textAlign:
                                              //                                   TextAlign
                                              //                                       .center,
                                              //                                 ),
                                              //                               )))),
                                              //                   Positioned.fill(
                                              //                     top: 14.0,
                                              //                     left: 16.0,
                                              //                     right: 7.0,
                                              //                     bottom: 61,
                                              //                     child: Align(
                                              //                       alignment:
                                              //                       Alignment.topCenter,
                                              //                       child: Container(
                                              //                           color: const Color.fromRGBO(
                                              //                               246, 246, 246, 1),
                                              //                           width: double.infinity,
                                              //                           height: 264,
                                              //                           child: Scrollbar(
                                              //                               thickness: 1.5,
                                              //                               radius: const Radius
                                              //                                   .circular(12),
                                              //                               thumbVisibility:
                                              //                               false,
                                              //                               showTrackOnHover:
                                              //                               true,
                                              //                               child: Center(
                                              //                                   child: ListView(
                                              //                                     scrollDirection:
                                              //                                     Axis.vertical,
                                              //                                     shrinkWrap: true,
                                              //                                     children: [
                                              //                                       Padding(
                                              //                                           padding: const EdgeInsets
                                              //                                               .all(
                                              //                                               12.0),
                                              //                                           child: Text(
                                              //                                               '${summary??''}'))
                                              //                                     ],
                                              //                                   )))),
                                              //                     ),
                                              //                   ),
                                              //                   const Positioned.fill(
                                              //                       bottom: 40,
                                              //                       child: Align(
                                              //                         alignment: Alignment
                                              //                             .bottomCenter,
                                              //                         child: Padding(
                                              //                           padding:
                                              //                           EdgeInsets
                                              //                               .only(
                                              //                               right: 20.0,
                                              //                               left: 20.0),
                                              //                           child: Divider(
                                              //                             thickness: 1,
                                              //                           ),
                                              //                         ),
                                              //                       )),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         );
                                              //       }),
                                              // ),
                                              Container(
                                                // height:
                                                //     SizeConfig.orentation == Orientation.landscape
                                                //         ? (SizeConfig.screenHeight! * 0.82) * 2
                                                  height: SizeConfig.screenHeight! * 0.82,
                                                  width: SizeConfig.screenWidth! >= 1200
                                                      ? 1200
                                                      : SizeConfig.screenWidth,
                                                  color: Palette.textLineOrBackGroundColor,
                                                  padding:
                                                  const EdgeInsets.all( 10.0, ),
                                                  child: Stack(
                                                    children: [
                                                      const Positioned.fill(
                                                          top: 24.0,
                                                          child: Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Text(
                                                                'Վերջին նորությունները',
                                                                style: TextStyle(
                                                                    fontFamily: 'GHEAGrapalat',
                                                                    fontSize: 16.0,
                                                                    letterSpacing: 1,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: Color.fromRGBO(
                                                                        122, 108, 115, 1)),
                                                              ))),
                                                      const Positioned.fill(
                                                          top: 62.0,
                                                          child: Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Text(
                                                                'Գրադարան',
                                                                style: TextStyle(
                                                                    fontFamily: 'GHEAGrapalat',
                                                                    fontSize: 16.0,
                                                                    letterSpacing: 1,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Color.fromRGBO(
                                                                        122, 108, 115, 1)),
                                                              ))),
                                                      Positioned.fill(
                                                          top: 70,
                                                          child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Container(
                                                                width: double.infinity,
                                                                child:
                                                                ResponsiveGridListBuilder(
                                                                    builder:
                                                                        (context, items) {
                                                                      return ListView(
                                                                        shrinkWrap: true,
                                                                        reverse: true,
                                                                        scrollDirection:
                                                                        Axis.vertical,
                                                                        physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                        children: items,
                                                                      );
                                                                    },
                                                                    horizontalGridSpacing:
                                                                    16, // Horizontal space between grid items
                                                                    // Vertical space between grid items

                                                                    verticalGridMargin:
                                                                    10, // Vertical space around the grid
                                                                    minItemWidth:
                                                                    300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                                                                    minItemsPerRow:
                                                                    1, // The minimum items to show in a single row. Takes precedence over minItemWidth
                                                                    maxItemsPerRow:
                                                                    2, // The m
                                                                    gridItems:
                                                                    List.generate(libraries!
                                                                        .content!
                                                                        .values
                                                                        .map((e) =>
                                                                    e)
                                                                        .toList().length,
                                                                            (index) {
                                                                          var bookData;

                                                                          if (libraries !=
                                                                              null) {
                                                                            bookData =
                                                                                libraries!
                                                                                    .content!
                                                                                    .values
                                                                                    .map((e) =>
                                                                                e)
                                                                                    .toList();
                                                                            books =
                                                                            bookData[index];

                                                                            //var bookContent = Content.fromJson(books!.content.values.map((e) => e.content)!);
                                                                            print(libraries?.content?.values?.map((e) => e.id));
                                                                            return index % 2 !=
                                                                                0
                                                                                ? Transform(
                                                                                alignment:
                                                                                Alignment
                                                                                    .center,
                                                                                transform: Matrix4
                                                                                    .rotationY(math
                                                                                    .pi),
                                                                                child:
                                                                                Padding(
                                                                                  padding: const EdgeInsets
                                                                                      .only(
                                                                                      top:
                                                                                      20),
                                                                                  child:
                                                                                  BookCard(
                                                                                    isOdd:
                                                                                    true,
                                                                                    isFromHomePage: true,
                                                                                    categorys: BookCategory(
                                                                                        categoryTitle: books
                                                                                            ?.title!,
                                                                                        id: books
                                                                                            ?.id!,
                                                                                        title:
                                                                                        '${books?.title}',
                                                                                        type:
                                                                                        'libraries'),
                                                                                    book:
                                                                                    books!,
                                                                                    bookId:
                                                                                    books?.id,
                                                                                  ),
                                                                                ))
                                                                                : Padding(
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  top:
                                                                                  20),
                                                                              child:
                                                                              BookCard(

                                                                                isOdd: false,
                                                                                isFromHomePage: true,
                                                                                categorys: BookCategory(
                                                                                    categoryTitle: books?.title ??'',

                                                                                    id: books?.id ??
                                                                                        0,
                                                                                    title:
                                                                                    '${books?.title}',
                                                                                    type:
                                                                                    'libraries'),

                                                                                bookId:
                                                                                books?.id,
                                                                                book: books!,
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            return const Center(
                                                                              child:
                                                                              Text('Empty'),
                                                                            );
                                                                          }
                                                                        })),
                                                              ))),
                                                      Positioned.fill(
                                                        bottom: 16,
                                                        right: 10,
                                                        child: Align(
                                                          alignment: Alignment.bottomRight,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context, rootNavigator: true).push(
                                                                MaterialPageRoute(
                                                                  builder: (_) => TabNavigator(
                                                                    navigatorKey: GlobalKey<NavigatorState>(),
                                                                    tabItem: 'librarypage',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Տեսնել բոլորը',
                                                              style: TextStyle(
                                                                  fontFamily: 'GHEAGrapalat',
                                                                  fontSize: 12.0,
                                                                  letterSpacing: 1,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Palette.main),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Container(
                                                width: SizeConfig.screenWidth,
                                                padding:
                                                EdgeInsets.only(right: 16.0, left: 16.0),
                                                // height: SizeConfig.orentation == Orientation.landscape
                                                //     ? (SizeConfig.screenHeight! * 0.52) * 2
                                                height: SizeConfig.screenHeight! * 0.52,
                                                color: Color.fromRGBO(226, 224, 224, 1),
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:SizeConfig.orentation == Orientation.landscape? Alignment.centerLeft:Alignment.center,
                                                      child: Container(
                                                        width: SizeConfig.screenWidth! >= 1200
                                                            ? 1200
                                                            : SizeConfig.orentation == Orientation.landscape? SizeConfig.screenWidth! /3:SizeConfig.screenWidth,
                                                        child: Stack(
                                                          children: [
                                                            Positioned.fill(
                                                              top: 65.0,
                                                              child: Align(
                                                                alignment:SizeConfig.orentation == Orientation.landscape? Alignment.topLeft:Alignment.topCenter,
                                                                child: Container(
                                                                  width: 485,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Container(
                                                                        child: Stack(
                                                                          children: [
                                                                            Align(
                                                                              alignment:
                                                                              Alignment
                                                                                  .topCenter,
                                                                              child: lessons !=
                                                                                  null
                                                                                  ? CachedNetworkImage(
                                                                                imageUrl: lessons!
                                                                                    .first
                                                                                    .image!,
                                                                                width: double
                                                                                    .infinity,
                                                                                fit: BoxFit
                                                                                    .cover,
                                                                                // height: SizeConfig
                                                                                //             .orentation ==
                                                                                //         Orientation
                                                                                //             .landscape
                                                                                //     ? (SizeConfig
                                                                                //                 .screenHeight! /
                                                                                //             3.55) *
                                                                                //         2
                                                                                height: SizeConfig
                                                                                    .screenHeight! /
                                                                                    3.55,
                                                                              )
                                                                                  : const CircularProgressIndicator(),
                                                                            ),
                                                                            Positioned.fill(
                                                                              child: Align(
                                                                                alignment:
                                                                                Alignment
                                                                                    .center,
                                                                                child:
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.of(
                                                                                        context,
                                                                                        rootNavigator:
                                                                                        true)
                                                                                        .push(MaterialPageRoute(
                                                                                        builder: (_) => ItaliaLessonShow(
                                                                                          lessons: lessons?.first,
                                                                                        )));
                                                                                  },
                                                                                  child: const Icon(
                                                                                    Icons
                                                                                        .play_arrow,
                                                                                    color: Colors
                                                                                        .white,
                                                                                    size: 50.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 20.0,
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Positioned.fill(
                                                                top: 16.0,
                                                                child: Align(
                                                                    alignment:
                                                                    Alignment.topLeft,
                                                                    child: Text(
                                                                      'Իտալերենի դասեր',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                          'GHEAGrapalat',
                                                                          fontSize: 16.0,
                                                                          letterSpacing: 1,
                                                                          fontWeight:
                                                                          FontWeight.w400,
                                                                          color: Color.fromRGBO(
                                                                              122,
                                                                              108,
                                                                              115,
                                                                              1)),
                                                                    ))),

                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      bottom:SizeConfig.orentation == Orientation.landscape?0.0:50.0,
                                                      child: Align(
                                                        alignment:SizeConfig.orentation == Orientation.landscape? Alignment.centerRight:Alignment.bottomLeft,

                                                        child: Container(
                                                            width: 485,
                                                          child:
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: ((_) =>
                                                                          ItaliaLessonShow(
                                                                            lessons:
                                                                            lessons?.first,
                                                                          ))));
                                                            },
                                                            child: Text(
                                                              '${lessons?.first.title}',
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                  'GHEAGrapalat',
                                                                  fontSize:
                                                                  14.0,
                                                                  letterSpacing:
                                                                  1,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Colors
                                                                      .black),
                                                              textAlign:
                                                              TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                        right: 15,
                                                        bottom: 16.0,
                                                        child: Align(
                                                          alignment:
                                                          Alignment.bottomRight,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context,rootNavigator: true).push(

                                                                  MaterialPageRoute(
                                                                      builder: ((_) =>
                                                                          ItalianPage(fromHomePage: true,))));
                                                            },
                                                            child: const Text(
                                                              'Տեսնել բոլորը',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  'GHEAGrapalat',
                                                                  fontSize: 12.0,
                                                                  letterSpacing: 1,
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  color: Palette.main),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: SizeConfig.orentation == Orientation.landscape
                                                    ? (SizeConfig.screenHeight! * 0.433) * 2 :SizeConfig.screenHeight! * 0.433,
                                                width: double.infinity,
                                                color: Palette.textLineOrBackGroundColor,
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        width: SizeConfig.screenWidth! >= 1200
                                                            ? 1200
                                                            : SizeConfig.screenWidth,
                                                        child: Stack(
                                                          children: [
                                                            Positioned.fill(
                                                                right: 16,
                                                                top: 24,
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.topCenter,
                                                                  child: Container(
                                                                    padding:
                                                                    const EdgeInsets.only(
                                                                        right: 16.0,
                                                                        left: 16.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      mainAxisSize:
                                                                      MainAxisSize.min,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            Navigator.of(
                                                                                context,rootNavigator: true)
                                                                                .push(MaterialPageRoute(
                                                                                builder: (_) =>
                                                                                    const Ecyclopedia()));
                                                                          },
                                                                          child: const Text(
                                                                            'Հանրագիտարան',
                                                                            style: TextStyle(
                                                                                fontFamily:
                                                                                'GHEAGrapalat',
                                                                                fontSize: 12,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                                letterSpacing:
                                                                                1,
                                                                                color: Color
                                                                                    .fromRGBO(
                                                                                    164,
                                                                                    171,
                                                                                    189,
                                                                                    1)),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10.0,
                                                                        ),
                                                                        GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.of(
                                                                                  context,rootNavigator: true)
                                                                                  .push(MaterialPageRoute(
                                                                                  builder:
                                                                                      (_) =>
                                                                                      const Ecyclopedia()));
                                                                            },
                                                                            child: SvgPicture.asset(
                                                                                'assets/images/arrow_right.svg')),
                                                                        const SizedBox(
                                                                          width: 10.0,
                                                                        ),
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Container(
                                                                            height:30,
                                                                            width: MediaQuery.of(context).size.width/2,
                                                                            child: ListView.builder(
                                                                                scrollDirection: Axis.horizontal,
                                                                                physics: const NeverScrollableScrollPhysics(),
                                                                                shrinkWrap: true,
                                                                                itemCount: encyclopedias?.length,
                                                                                itemBuilder: (BuildContext context,index){
                                                                                  return      Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: InkWell(
                                                                                      onTap:(){
                                                                                        if(encyclopedias!=null)
                                                                                          Navigator.of(context).push(MaterialPageRoute(builder:(_)=>
                                                                                              EcyclopediaByCharacters(
                                                                                                  characters: charEncyc,
                                                                                                  characterByindex: "${encyclopedias?[index]}",
                                                                                                  characterIndex: charEncyc.indexOf("${encyclopedias?[index]}"))));

                                                                                      },
                                                                                      child: Text(
                                                                                        '${encyclopedias?[index]},',
                                                                                        style: const TextStyle(
                                                                                            fontFamily:
                                                                                            'GHEAGrapalat',
                                                                                            fontSize: 12,
                                                                                            fontWeight:
                                                                                            FontWeight
                                                                                                .w700,
                                                                                            letterSpacing: 1,
                                                                                            color: Color
                                                                                                .fromRGBO(
                                                                                                164,
                                                                                                171,
                                                                                                189,
                                                                                                1)),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                            Positioned.fill(
                                                              bottom: 15,
                                                              child: Align(
                                                                alignment:
                                                                Alignment.bottomCenter,
                                                                child: Container(
                                                                  padding: const EdgeInsets.only(
                                                                      left: 16.0),
                                                                  height: 81.0,
                                                                  width: double.infinity,

                                                                  child: Align(
                                                                    alignment: Alignment.center,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          'assets/images/VectorLine.svg',
                                                                        ),
                                                                        const SizedBox(width: 12),
                                                                        Expanded(
                                                                          child:
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.of(context,rootNavigator: true).push(
                                                                                  MaterialPageRoute(
                                                                                      builder: (_) =>
                                                                                          BookReadScreen(
                                                                                            encyclopediaBody:
                                                                                            !encyData.isEmpty?encyData.first: e?.first,
                                                                                          )));
                                                                            },
                                                                            child: SizedBox(
                                                                              width: MediaQuery.of(
                                                                                  context)
                                                                                  .size
                                                                                  .width /
                                                                                  2,
                                                                              child: Text(
                                                                                '${!encyData.isEmpty?encyData.first.title: e?.first.title}',
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .start,
                                                                                style:
                                                                                const TextStyle(
                                                                                  fontFamily:
                                                                                  'GHEAGrapalat',
                                                                                  fontSize: 12,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w700,
                                                                                  letterSpacing:
                                                                                  1,
                                                                                  color: Color
                                                                                      .fromRGBO(
                                                                                      113,
                                                                                      141,
                                                                                      156,
                                                                                      1),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // child: Stack(
                                                                  //   children: [
                                                                  //     Container(
                                                                  //       height: double.infinity,
                                                                  //       width: 84,
                                                                  //       color: Colors.pink,
                                                                  //     ),
                                                                  //   ],
                                                                  // ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      top: 73,
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          //color: Palette.textLineOrBackGroundColor,
                                                          height: 110,
                                                          width: double.infinity,
                                                          child: Stack(
                                                            alignment: Alignment.centerLeft,
                                                            children: [
                                                              Positioned.fill(
                                                                  child: Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 3,
                                                                          child: Container(
                                                                            height: 34,
                                                                            width: double.infinity,
                                                                            decoration:
                                                                            const BoxDecoration(
                                                                                color: Color
                                                                                    .fromRGBO(
                                                                                    113,
                                                                                    141,
                                                                                    156,
                                                                                    1),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Color
                                                                                        .fromRGBO(
                                                                                        0,
                                                                                        0,
                                                                                        0,
                                                                                        0.1),
                                                                                    blurRadius: 1.0,
                                                                                    spreadRadius:
                                                                                    0.0,
                                                                                    offset: Offset(
                                                                                        4, 4),
                                                                                  ),
                                                                                ]),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10.0,
                                                                        ),
                                                                        Container(
                                                                          height: 34,
                                                                          padding: const EdgeInsets.only(
                                                                              right: 20.0),
                                                                          child: Align(
                                                                            alignment: Alignment
                                                                                .centerRight,
                                                                            child:
                                                                            ListView.separated(
                                                                              separatorBuilder:
                                                                                  (context,
                                                                                  index) =>
                                                                                  const SizedBox(
                                                                                    width: 10.0,
                                                                                  ),
                                                                              itemCount:
                                                                              encyclopedias!
                                                                                  .length,
                                                                              shrinkWrap: true,
                                                                              scrollDirection:
                                                                              Axis.horizontal,
                                                                              physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                              itemBuilder:
                                                                                  (context, index) {
                                                                                return Container(
                                                                                  height: 34,
                                                                                  width: 45,
                                                                                  decoration: const BoxDecoration(
                                                                                      color: Color
                                                                                          .fromRGBO(
                                                                                          113,
                                                                                          141,
                                                                                          156,
                                                                                          1),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Color
                                                                                              .fromRGBO(
                                                                                              0,
                                                                                              0,
                                                                                              0,
                                                                                              0.1),
                                                                                          blurRadius:
                                                                                          1.0,
                                                                                          spreadRadius:
                                                                                          0.0,
                                                                                          offset:
                                                                                          Offset(
                                                                                              4,
                                                                                              4),
                                                                                        ),
                                                                                      ]),
                                                                                  child: Center(
                                                                                    child: InkWell(
                                                                                      onTap: () async{
                                                                                        print(encyclopedias?[index]);
                                                                                        charTitle = encyclopedias![index];
                                                                                        await   _bookDataProvider
                                                                                            .getDataByCharacters(
                                                                                            Api.encyclopediasByCharacters(encyclopedias?[index]))
                                                                                            .then((value) {
                                                                                          setState(() {
                                                                                            encyData = value;
                                                                                          });
                                                                                        });
                                                                                      },
                                                                                      child: Text(
                                                                                          ' ${encyclopedias?[index]}'),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                              // Positioned.fill(
                                                              //   child: Align(
                                                              //     alignment: Alignment.center,
                                                              //     child: Container(
                                                              //       width: SizeConfig.screenWidth! >=
                                                              //               1200
                                                              //           ? 1200
                                                              //           : SizeConfig.screenWidth,
                                                              //       height: 34,
                                                              //       padding:
                                                              //           EdgeInsets.only(right: 20.0),
                                                              //       child: Align(
                                                              //         alignment:
                                                              //             Alignment.centerRight,
                                                              //         child: ListView.separated(
                                                              //           separatorBuilder:
                                                              //               (context, index) =>
                                                              //                   SizedBox(
                                                              //             width: 10.0,
                                                              //           ),
                                                              //           itemCount: 3,
                                                              //           shrinkWrap: true,
                                                              //           scrollDirection:
                                                              //               Axis.horizontal,
                                                              //           physics:
                                                              //               NeverScrollableScrollPhysics(),
                                                              //           itemBuilder:
                                                              //               (context, index) {
                                                              //             return Container(
                                                              //               height: 34,
                                                              //               width: 45,
                                                              //               decoration: BoxDecoration(
                                                              //                   color: Color.fromRGBO(
                                                              //                       113, 141, 156, 1),
                                                              //                   boxShadow: [
                                                              //                     BoxShadow(
                                                              //                       color: Color
                                                              //                           .fromRGBO(
                                                              //                               0,
                                                              //                               0,
                                                              //                               0,
                                                              //                               0.1),
                                                              //                       blurRadius: 1.0,
                                                              //                       spreadRadius: 0.0,
                                                              //                       offset:
                                                              //                           Offset(4, 4),
                                                              //                     ),
                                                              //                   ]),
                                                              //               child: Center(
                                                              //                 child: Text('Պ'),
                                                              //               ),
                                                              //             );
                                                              //           },
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              Center(
                                                                child: Container(
                                                                  padding: const EdgeInsets.only(
                                                                      left: 16.0),
                                                                  width: SizeConfig
                                                                      .screenWidth! >=
                                                                      1200
                                                                      ? 1200
                                                                      : SizeConfig.screenWidth,
                                                                  child: Stack(
                                                                    children: [
                                                                      // Positioned.fill(
                                                                      //     child: Align(
                                                                      //   alignment:
                                                                      //       Alignment.centerLeft,
                                                                      //   child: Container(
                                                                      //     decoration: BoxDecoration(
                                                                      //         color: Color.fromRGBO(
                                                                      //             113, 141, 156, 1),
                                                                      //         boxShadow: [
                                                                      //           BoxShadow(
                                                                      //             color:
                                                                      //                 Color.fromRGBO(
                                                                      //                     0,
                                                                      //                     0,
                                                                      //                     0,
                                                                      //                     0.1),
                                                                      //             blurRadius: 1.0,
                                                                      //             spreadRadius: 0.0,
                                                                      //             offset:
                                                                      //                 Offset(4, 4),
                                                                      //           ),
                                                                      //         ]),
                                                                      //     height: 34,
                                                                      //     width: SizeConfig
                                                                      //                 .screenWidth! >=
                                                                      //             1200
                                                                      //         ? 1000
                                                                      //         : SizeConfig
                                                                      //                 .screenWidth! -
                                                                      //             200,
                                                                      //   ),
                                                                      // )),
                                                                      Container(
                                                                        height: double.infinity,
                                                                        width: 84,
                                                                        decoration:
                                                                        const BoxDecoration(
                                                                            color: Color
                                                                                .fromRGBO(
                                                                                84,
                                                                                126,
                                                                                126,
                                                                                1),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Color
                                                                                    .fromRGBO(
                                                                                    0,
                                                                                    0,
                                                                                    0,
                                                                                    0.1),
                                                                                blurRadius: 1.0,
                                                                                spreadRadius:
                                                                                0.0,
                                                                                offset: Offset(
                                                                                    4, 4),
                                                                              ),
                                                                            ]),
                                                                        child: Center(
                                                                          child: Align(
                                                                            alignment: Alignment
                                                                                .center,
                                                                            child: Container(
                                                                              alignment:
                                                                              Alignment
                                                                                  .center,
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  top:
                                                                                  15.0),
                                                                              width: double
                                                                                  .infinity,
                                                                              height: double
                                                                                  .infinity,
                                                                              child: Text(

                                                                                '${!charTitle.isEmpty ? charTitle : encyclopedias?.first}',
                                                                                style: const TextStyle(
                                                                                    color: Palette
                                                                                        .whenTapedButton,
                                                                                    fontFamily:
                                                                                    'ArshaluyseArtU',
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w700,
                                                                                    fontSize:
                                                                                    52),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(16.0),
                                                color: const Color.fromRGBO(226, 224, 224, 1),
                                                height: MediaQuery.of(context).orientation == Orientation.landscape ? (SizeConfig.screenHeight! * 0.65) * 2:(SizeConfig.screenHeight! * 0.65),
                                                width: SizeConfig.screenWidth,
                                                child: Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      right: 16,
                                                      top: 16,
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          width: SizeConfig.screenWidth! >= 1200
                                                              ? 1200
                                                              : SizeConfig.screenWidth,
                                                          child: Align(
                                                            alignment: Alignment.topCenter,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.of(context,rootNavigator: true).push(
                                                                        MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                const AudioLibrary()));
                                                                  },
                                                                  child: const Text(
                                                                    'Ձայանդարան',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                        'GHEAGrapalat',
                                                                        fontSize: 12,
                                                                        fontWeight:
                                                                        FontWeight.w700,
                                                                        letterSpacing: 1,
                                                                        color: Color.fromRGBO(
                                                                            122, 108, 115, 1)),
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 17),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(context,rootNavigator: true).push(
                                                                          MaterialPageRoute(
                                                                              builder: (_) =>
                                                                                  const AudioLibrary()));
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      'assets/images/arrow_right.svg',
                                                                      color: const Color.fromRGBO(
                                                                          122, 108, 115, 1),
                                                                    )),
                                                                const SizedBox(width: 17),
                                                                InkWell(
                                                                  onTap:(){
                                                                    Navigator.of(context).push(MaterialPageRoute(builder:(_)=>
                                                                        AudioLibraryByCharacters(
                                                                          characters:charAudio,
                                                                          characterByindex: "${audiolibraries}",
                                                                          characterIndex: charAudio.indexOf("${audiolibraries}"),
                                                                        )));

                                                                  },
                                                                  child: Text(
                                                                    '${audiolibraries}',
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                        'GHEAGrapalat',
                                                                        fontSize: 12,
                                                                        fontWeight:
                                                                        FontWeight.w700,
                                                                        letterSpacing: 1,
                                                                        color: Color.fromRGBO(
                                                                            122, 108, 115, 1)),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      top: 49,
                                                      child: Center(
                                                        child: Align(
                                                          alignment: Alignment.topCenter,
                                                          child: Container(
                                                            width:
                                                            SizeConfig.screenWidth! >= 1200
                                                                ? 1200
                                                                : SizeConfig.screenWidth,
                                                            // height: SizeConfig.orentation ==
                                                            //         Orientation.landscape
                                                            //     ? (SizeConfig.screenHeight! *
                                                            //             0.101) *
                                                            //         2
                                                            height: SizeConfig.screenHeight! *
                                                                0.101,
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  width:
                                                                  SizeConfig.screenWidth! >=
                                                                      1200
                                                                      ? 100
                                                                      : 60,
                                                                  decoration: const BoxDecoration(
                                                                      color: Color.fromRGBO(
                                                                          83, 66, 77, 1),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Color.fromRGBO(
                                                                              0, 0, 0, 0.1),
                                                                          blurRadius: 1.0,
                                                                          spreadRadius: 0.0,
                                                                          offset: Offset(4, 4),
                                                                        ),
                                                                      ]),
                                                                  child: Align(
                                                                    alignment: Alignment.center,
                                                                    child: Text(
                                                                      '${audiolibraries}',
                                                                      style: TextStyle(
                                                                        fontFamily:
                                                                        "ArshaluyseArtU",
                                                                        fontSize: SizeConfig
                                                                            .screenWidth! >=
                                                                            1200
                                                                            ? 38
                                                                            : 30,
                                                                        color: Palette
                                                                            .textLineOrBackGroundColor,
                                                                        fontWeight:
                                                                        FontWeight.w700,
                                                                      ),
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Container(
                                                                      padding: const EdgeInsets.only(
                                                                        left: 10.0,
                                                                      ),
                                                                      child: Text(
                                                                        '${a?.first.title}',
                                                                        //  softWrap: true,
                                                                        style: const TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              83, 66, 77, 1),
                                                                          fontSize: 12.0,
                                                                          fontWeight:
                                                                          FontWeight.w400,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.start,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      child: Container(
                                                        width: SizeConfig.screenWidth! >= 1200
                                                            ? 1200
                                                            : SizeConfig.screenWidth,
                                                        child: Stack(
                                                          children: [
                                                            Positioned.fill(
                                                              top: 167.0,
                                                              child: Align(
                                                                alignment: Alignment.topCenter,
                                                                child: Container(
                                                                  width: 485,
                                                                  height:
                                                               SizeConfig.orentation == Orientation.landscape ?
                                                               (   SizeConfig.screenHeight! / 3.55 )* 2
                                                                   : SizeConfig.screenHeight! / 3.55,
                                                                  child: Stack(
                                                                    children: [
                                                                      Align(
                                                                        alignment:
                                                                        Alignment.topCenter,
                                                                        child: a != null
                                                                            ? CachedNetworkImage(
                                                                          imageUrl:
                                                                          '${a?.first.image}',
                                                                          width: double
                                                                              .infinity,

                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height:  SizeConfig.orentation == Orientation.landscape ?
                                                                          (   SizeConfig.screenHeight! / 3.55 )* 2
                                                                              : SizeConfig.screenHeight! / 3.55,
                                                                        )
                                                                            : const CircularProgressIndicator(),
                                                                      ),
                                                                      Positioned.fill(
                                                                        child: Align(
                                                                          alignment:
                                                                          Alignment.center,
                                                                          child:
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.of(
                                                                                  context,
                                                                                  rootNavigator:
                                                                                  true)
                                                                                  .push(MaterialPageRoute(
                                                                                  builder: (_) => VideoView(
                                                                                    link:
                                                                                    a?.first.link,
                                                                                  )));
                                                                            },
                                                                            child: const Icon(
                                                                              Icons.play_arrow,
                                                                              color:
                                                                              Colors.white,
                                                                              size: 50.0,
                                                                            ),
                                                                          ),
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
                                                    ),
                                                    Positioned.fill(
                                                        child: Align(
                                                          alignment: Alignment.bottomRight,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context,rootNavigator: true).push(
                                                                  MaterialPageRoute(
                                                                      builder: ((_) =>
                                                                          const AudioLibrary(
                                                                          ))));
                                                            },
                                                            child: const Text(
                                                              'Տեսնել բոլորը',
                                                              style: TextStyle(
                                                                  fontFamily: 'GHEAGrapalat',
                                                                  fontSize: 12.0,
                                                                  letterSpacing: 1,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Palette.main),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // height: SizeConfig.orentation == Orientation.landscape
                                                //     ? (SizeConfig.screenHeight! * 0.7) * 2
                                                height:SizeConfig.orentation == Orientation.landscape?
                                                (SizeConfig.screenHeight! * 0.444) * 2 :
                                                SizeConfig.screenHeight! * 0.444,
                                                width: double.infinity,
                                                color: Palette.textLineOrBackGroundColor,
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        width: SizeConfig.screenWidth! >= 1200
                                                            ? 1200
                                                            : SizeConfig.screenWidth,
                                                        child: Stack(
                                                          children: [
                                                            Positioned.fill(
                                                                right: 16,
                                                                top: 24,
                                                                child: Align(
                                                                  alignment: Alignment.topLeft,
                                                                  child: Container(
                                                                    padding:
                                                                    const EdgeInsets.only(
                                                                        right: 16.0,
                                                                        left: 16.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      mainAxisSize:
                                                                      MainAxisSize.min,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            Navigator.of(
                                                                                context,rootNavigator: true)
                                                                                .push(MaterialPageRoute(
                                                                                builder: (_) =>
                                                                                    const Dialect()));
                                                                          },
                                                                          child: const Text(
                                                                            'Համաբարբառ ',
                                                                            style: TextStyle(
                                                                                fontFamily:
                                                                                'GHEAGrapalat',
                                                                                fontSize: 12,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                                letterSpacing:
                                                                                1,
                                                                                color: Color
                                                                                    .fromRGBO(
                                                                                    164,
                                                                                    171,
                                                                                    189,
                                                                                    1)),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10.0,
                                                                        ),
                                                                        GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.of(
                                                                                  context,rootNavigator: true)
                                                                                  .push(MaterialPageRoute(
                                                                                  builder:
                                                                                      (_) =>
                                                                                      const Dialect()));
                                                                            },
                                                                            child: SvgPicture.asset(
                                                                                'assets/images/arrow_right.svg')),
                                                                        const SizedBox(
                                                                          width: 10.0,
                                                                        ),
                                                                        Container(
                                                                          height:30,
                                                                          width: MediaQuery.of(context).size.width/2,
                                                                          child: ListView.builder(
                                                                              scrollDirection: Axis.horizontal,
                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              itemCount: dialects?.length,
                                                                              itemBuilder: (BuildContext context,index){
                                                                                return      Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: InkWell(
                                                                                    onTap:(){
                                                                                      if(dialects!=null)
                                                                                        Navigator.of(context).push(MaterialPageRoute(builder:(_)=>
                                                                                            DialectByCharacters(
                                                                                                characters: charDialects,
                                                                                                characterByindex: "${dialects?[index]}",
                                                                                                characterIndex: charDialects.indexOf("${dialects?[index]}"))));

                                                                                    },
                                                                                    child: Text(
                                                                                      '${dialects?[index]},',
                                                                                      style: const TextStyle(
                                                                                          fontFamily:
                                                                                          'GHEAGrapalat',
                                                                                          fontSize: 12,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w700,
                                                                                          letterSpacing: 1,
                                                                                          color: Color
                                                                                              .fromRGBO(
                                                                                              164,
                                                                                              171,
                                                                                              189,
                                                                                              1)),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                            Positioned.fill(
                                                              top: 194.0,
                                                              child: Center(
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.topCenter,
                                                                  child: Container(
                                                                    width: SizeConfig
                                                                        .screenWidth! >=
                                                                        1200
                                                                        ? 1200
                                                                        : SizeConfig
                                                                        .screenWidth,
                                                                    child: Align(
                                                                      alignment:
                                                                      Alignment.topLeft,
                                                                      child: Align(
                                                                        alignment:
                                                                        Alignment.topLeft,
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                padding: const EdgeInsets
                                                                                    .only(
                                                                                    left:
                                                                                    16.0),
                                                                                width: MediaQuery.of(
                                                                                    context)
                                                                                    .size
                                                                                    .width /
                                                                                    1.3,
                                                                                child:
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    OpenUrl.launchInBrowser(Uri.parse(d!
                                                                                        .first
                                                                                        .sharurl
                                                                                        .toString()));
                                                                                  },
                                                                                  child: _enabled ? Text(
                                                                                    '${!dailectData.isEmpty ?dailectData.first.title:d?.first.title}',
                                                                                    style: const TextStyle(
                                                                                        fontFamily:
                                                                                        'GHEAGrapalat',
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w700,
                                                                                        fontSize:
                                                                                        16.0,
                                                                                        color: Color.fromRGBO(
                                                                                            97,
                                                                                            109,
                                                                                            135,
                                                                                            1)),
                                                                                    textAlign:
                                                                                    TextAlign
                                                                                        .start,
                                                                                  ) : Padding(
                                                                                    padding:  EdgeInsets.only(
                                                                                        top:10,
                                                                                        right: MediaQuery.of(context).size.width / 2),
                                                                                    child: const LinearProgressIndicator(

                                                                                      backgroundColor: Colors.grey,color: Palette.main,),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      top: 73,
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          height: 110,
                                                          width: double.infinity,
                                                          child: Stack(
                                                            alignment: Alignment.centerLeft,
                                                            children: [
                                                              Positioned.fill(
                                                                  child: Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 3,
                                                                          child: Container(
                                                                            height: 34,
                                                                            width: double.infinity,
                                                                            decoration:
                                                                            const BoxDecoration(
                                                                                color: Color
                                                                                    .fromRGBO(
                                                                                    113,
                                                                                    141,
                                                                                    156,
                                                                                    1),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Color
                                                                                        .fromRGBO(
                                                                                        0,
                                                                                        0,
                                                                                        0,
                                                                                        0.1),
                                                                                    blurRadius: 1.0,
                                                                                    spreadRadius:
                                                                                    0.0,
                                                                                    offset: Offset(
                                                                                        4, 4),
                                                                                  ),
                                                                                ]),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10.0,
                                                                        ),
                                                                        Container(
                                                                          height: 34,
                                                                          padding: const EdgeInsets.only(
                                                                              right: 20.0),
                                                                          child: Align(
                                                                            alignment: Alignment
                                                                                .centerRight,
                                                                            child:
                                                                            ListView.separated(
                                                                              separatorBuilder:
                                                                                  (context,
                                                                                  index) =>
                                                                                  const SizedBox(
                                                                                    width: 10.0,
                                                                                  ),
                                                                              itemCount:
                                                                              dialects!.length,
                                                                              shrinkWrap: true,
                                                                              scrollDirection:
                                                                              Axis.horizontal,
                                                                              physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                              itemBuilder:
                                                                                  (context, index) {
                                                                                return Container(
                                                                                  height: 34,
                                                                                  width: 45,
                                                                                  decoration: const BoxDecoration(
                                                                                      color: Color
                                                                                          .fromRGBO(
                                                                                          113,
                                                                                          141,
                                                                                          156,
                                                                                          1),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Color
                                                                                              .fromRGBO(
                                                                                              0,
                                                                                              0,
                                                                                              0,
                                                                                              0.1),
                                                                                          blurRadius:
                                                                                          1.0,
                                                                                          spreadRadius:
                                                                                          0.0,
                                                                                          offset:
                                                                                          Offset(
                                                                                              4,
                                                                                              4),
                                                                                        ),
                                                                                      ]),
                                                                                  child: Center(
                                                                                    child: InkWell(
                                                                                      onTap: () {
                                                                                        charTitle = dialects![index];
                                                                                        setState(() {
                                                                                          _enabled = false;
                                                                                        });
                                                                                        Future.delayed(const Duration(milliseconds: 300),(){

                                                                                          _bookDataProvider
                                                                                              .getDataByCharacters(
                                                                                              Api.dialectBYCharacters(dialects?[index]))
                                                                                              .then((value) {
                                                                                            setState(() {
                                                                                              dailectData = value;


                                                                                            });
                                                                                          });
                                                                                        }).then((value) => Future.delayed(const Duration(milliseconds: 300),()=>_enabled = true));

                                                                                      },
                                                                                      child:  Text(
                                                                                          '${dialects?[index]}'),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                              Center(
                                                                child: Container(
                                                                  padding: const EdgeInsets.only(
                                                                      left: 16.0),
                                                                  width: SizeConfig
                                                                      .screenWidth! >=
                                                                      1200
                                                                      ? 1200
                                                                      : SizeConfig.screenWidth,
                                                                  child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        height: double.infinity,
                                                                        width: 84,
                                                                        decoration:
                                                                        const BoxDecoration(
                                                                            color: Color
                                                                                .fromRGBO(
                                                                                84,
                                                                                126,
                                                                                126,
                                                                                1),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Color
                                                                                    .fromRGBO(
                                                                                    0,
                                                                                    0,
                                                                                    0,
                                                                                    0.1),
                                                                                blurRadius: 1.0,
                                                                                spreadRadius:
                                                                                0.0,
                                                                                offset: Offset(
                                                                                    4, 4),
                                                                              ),
                                                                            ]),
                                                                        child: Center(
                                                                          child: Align(
                                                                            alignment: Alignment
                                                                                .center,
                                                                            child: Container(
                                                                              alignment:
                                                                              Alignment
                                                                                  .center,
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  top:
                                                                                  15.0),
                                                                              width: double
                                                                                  .infinity,
                                                                              height: double
                                                                                  .infinity,
                                                                              child:_enabled? Text(
                                                                                '${!charTitle.isEmpty ? charTitle :dialects?.first}',
                                                                                style: const TextStyle(
                                                                                    color: Palette
                                                                                        .whenTapedButton,
                                                                                    fontFamily:
                                                                                    'ArshaluyseArtU',
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w700,
                                                                                    fontSize:
                                                                                    52),
                                                                              ): const CircularProgressIndicator(color: Palette.main,strokeWidth: 2,),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                        right: 15,
                                                        child: Align(
                                                          alignment: Alignment.bottomRight,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context,rootNavigator: true).push(
                                                                  MaterialPageRoute(
                                                                      builder: ((_) =>
                                                                          const Dialect())));
                                                            },
                                                            child: const Text(
                                                              'Տեսնել բոլորը',
                                                              style: TextStyle(
                                                                  fontFamily: 'GHEAGrapalat',
                                                                  fontSize: 12.0,
                                                                  letterSpacing: 1,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Palette.main),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              width: 30,
                              height: 51,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: MenuShow(fromHomePage: true),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Palette.main,
                ),
              );
            }
          }else{
            return   const Center(child: AlertDialog(
              elevation: 0.1,
              backgroundColor: Palette.barColor,
              title: Text(''
                  'Ինտերնետ կապը կորել է: \nՄիացրեք կամ Ստուգեք ձեր կապը և նորից փորձեք:'

              ,style: TextStyle(color: Colors.white,fontSize: 18),),),);
          }
        }


    );

  }
}

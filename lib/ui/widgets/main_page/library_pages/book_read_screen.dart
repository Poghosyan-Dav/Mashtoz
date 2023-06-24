import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/models/app_theme.dart/theme_notifire.dart';
import 'package:mashtoz_flutter/domens/models/book_data/data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/search_data.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/domens/repository/search_book_data_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/book_page.dart';
import 'package:mashtoz_flutter/ui/widgets/youtube_videos/advanced_overlay.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube/youtube_thumbnail.dart';
import 'package:youtube_parser/youtube_parser.dart';

import '../../../../domens/models/book_data/content_list.dart';
import '../../../../domens/repository/user_data_provider.dart';
import '../../../../globals.dart';
import '../../../../tab_provider.dart';
import '../../helper_widgets/save_show_dialog.dart';
import 'book_inherited_widget.dart';
import 'book_utils/book_setings.dart';

String? eId, libId;
class BookReadScreen extends StatefulWidget {
  const BookReadScreen(
      {Key? key,
        this.saveId,
        this.readScreen,
        this.encyclopediaBody,
        this.searchData,
        this.encyId,
        this.idLib,
        this.isShowTitle,
        this.isFromHomePage})
      : super(key: key);
  final int? saveId;
  final Data? encyclopediaBody;
  final Content? readScreen;
  final Search? searchData;
  final bool? isShowTitle;
  final String? encyId;
  final String? idLib;
  final bool? isFromHomePage;

  @override
  State<BookReadScreen> createState() => _BookReadScreenState(
      readScreen: readScreen,
      encyclopediaBody: encyclopediaBody,
      isShowTitle: isShowTitle,
      encyId: encyId,
      idLib: idLib,
      searchData: searchData);
}

class _BookReadScreenState extends State<BookReadScreen> {
  _BookReadScreenState(
      {this.readScreen,
        this.encyclopediaBody,
        this.searchData,
        this.encyId,
        this.idLib,
        this.isShowTitle});

  var bookPartsLengt;
  Future<Content?>? content;
  var count = 0;
  var data;
  Data? encyclopediaBody;
  Future<Data?>? futureSearchText;
  bool isVisiblty = false;
  int pageindex = 0;
  final bool? isShowTitle;
  Content? readScreen;
  final searchBookProvider = SearchBookProvider();
  final Search? searchData;
  var textList;
  String? encyId;
  String? idLib;
  PageController _pageController = PageController(initialPage: 0);
  final bookDataProvider = BookDataProvider();
  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (eId != null || idLib != null) {
      eId = encyId;
      libId = idLib;
    }
    if (libId != null) {
      bookDataProvider.getCategoryLists(Api.categoryListUrl,false).then((value) {
        for (var nv in value) {
          Future.delayed(Duration(microseconds: 1500), () {
            bookDataProvider.getLibraryBooksByCategory(nv.id!,false).then((value) {
              for (var nValue in value!) {
                // print(nValue.id);

                // if (nValue == libId) {
                //   // readScreen = nValue;
                //   // inspect(readScreen);
                //   // textList = readScreen!.body!;
                //   // setState(() {});
                //   print(nValue);
                //   break;
                // }
              }
            });
          });
        }
      });
    }
    textList =
    (readScreen?.body != null ? readScreen?.body : encyclopediaBody?.body);
    _pageController;
    futureSearchText = getSearchBook();

    super.initState();
  }

  Future<Data?> getSearchBook() async {
    return await searchBookProvider.fetchBook(
        type: searchData?.type, id: searchData?.id);
  }

  // //Book data add
  // List<String>? bookGengerator(String? x) {
  //   var textList = <String>[];

  //   print(x?.length);
  //   var indexCharacter;
  //   var cutCount = SizeConfig.screenWidth!.floor();

  //   if (x != null && x.length < cutCount) {
  //     cutCount = x.length;
  //     indexCharacter = x.indexOf(' ', cutCount);
  //   } else {
  //     indexCharacter = x?.indexOf(' ', cutCount);
  //   }

  //   var count = x != null ? (x.length / indexCharacter).floor() : 0;

  //   for (var i = 0; i < count; i++) {
  //     final a = x!.substring(0, indexCharacter);
  //     textList.add(a);

  //     x = x.substring(cutCount, x.length);
  //   }
  //   textList.add(x ?? '');
  //   return textList;
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.isFromHomePage);
    return searchData != null
        ? FutureBuilder<Data?>(
      future: futureSearchText,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          textList = data?.body ;
          //    inspect(data);
          return BookPages(
            encId: widget.encyId,
            saveId: widget.saveId,
            listText: textList,
            readScreen: readScreen,
            isFromHomePage: widget.isFromHomePage,
            encyclopediaBody: encyclopediaBody,
            searchDataBody: data,
            searchData: searchData,
            pageCounts: textList.length,
            dynamicPageCounts: count,
            //   isVisiblty: isVisiblty,
          );
        } else {
          return Container(
              child: Center(
                  child: CircularProgressIndicator(
                    color: Palette.main,
                  )));
        }
      },
    )
        : BookPages(
      encId: widget.encyId,
      saveId: widget.saveId,
      listText: textList != null ? textList : '',
      readScreen: readScreen,
      encyclopediaBody: encyclopediaBody,
isFromHomePage: widget.isFromHomePage,
      dynamicPageCounts: count,
      isShowTitle: isShowTitle,
      //   isVisiblty: isVisiblty,
    );
  }
}

class BookPages extends StatefulWidget {
  BookPages({
    Key? key,
    required this.saveId,
    required this.listText,
    this.encyclopediaBody,
    this.searchDataBody,
    this.readScreen,
    this.searchData,
    this.controller,
    this.index,
    this.pageCounts,
    this.dynamicPageCounts,
    this.isShowTitle,
    this.encId,
    this.isFromHomePage
  }) : super(key: key);

  final PageController? controller;
  final Data? encyclopediaBody;
  final Data? searchDataBody;
 final bool? isFromHomePage;
  final int? index;
  final String listText;
  final Content? readScreen;
  final Search? searchData;
  final int? pageCounts;
  final int? dynamicPageCounts;
  final bool? isShowTitle;
  final int? saveId;
  final String? encId;
  @override
  State<BookPages> createState() => _BookPagesState(
    saveId:saveId,
      listText: listText,
      readScreen: readScreen,
      searchData: searchData,
      encyclopediaBody: encyclopediaBody,
      controller: controller,
      index: index,
      isFromHomePage: isFromHomePage,
      searchBodyData: searchDataBody,
      pageCounts: pageCounts,
      dynamicPageCounts: dynamicPageCounts,
      isShowTitle: isShowTitle,
      encId:encId,
  );
}

class _BookPagesState extends State<BookPages> {
  _BookPagesState({
    required this.saveId,
    required this.listText,
    this.isShowTitle,
    this.readScreen,
    this.encyclopediaBody,
    this.searchBodyData,
    this.controller,
    this.searchData,
    this.index,
    this.pageCounts,
    this.isFromHomePage,
    this.encId,
    this.dynamicPageCounts,
  });
  final Search? searchData;
  final int? pageCounts;
  final bool? isShowTitle;
  final int? dynamicPageCounts;
  final PageController? controller;
  int? custemerId;
  String? encId;
  int?  saveId;
  bool isShowingDialog = false;

  Data? encyclopediaBody;
  Data? searchBodyData;
  final int? index;
  bool isBovandakMenu = false;
  bool isDarkTheme = false;
  bool isFavorite = false;
  bool isLisghtTheme = false;
  bool isPhoneturnHorizontal = false;
  bool isPhoneturnVertical = false;
  bool isSettings = false;
  bool isShare = false;
  bool isVisiblty = false;
  bool isYoutubeActive = false;
  bool? isFromHomePage;
  var items = 1;
  String listText;
  Content? readScreen;
  double selectedValue = 0;
  double _textSize = 16.0;
  final userDataProvider = UserDataProvider();
  final bookDataProvider = BookDataProvider();
  @override
  void initState() {

    if (encId != null) {
      bookDataProvider
          .getDialect_Encyclopaedia_Characters(encId != null
          ? Api.encyclopediasCharacters
          : libId != null
          ? Api.dialectCharacters
          : Api.audioLibrariesCharacters)
          .then((value) {
        for (var nv in value) {
          bookDataProvider
              .getDataByCharacters(Api.encyclopediasByCharacters(nv))
              .then((value) {
            for (var nValue in value) {
              if ('(${nValue.id})'.toString().contains(encId.toString())) {
                setState(() {
                  encyclopediaBody = nValue;
                  listText = encyclopediaBody!.body!;
                });
                break;

              }
            }
          });
        }
      });
    }

    super.initState();
  }

  void _increaseTextSize() {
    setState(() {
      _textSize = (_textSize + 2.0).clamp(16.0, 30.0);

    });
  }

  void _decreaseTextSize() {
    setState(() {
      _textSize = (_textSize - 2.0).clamp(16.0, 30.0);
    });
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  Widget hideMenuAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(children: [
          SizedBox(
              height: 20,
              width: 50,
              child: Center(
                child: InkWell(
                  onTap: () {
                   setState(() {
                     isVisiblty = !isVisiblty;
                     isBovandakMenu = false;
                   });
                  },
                  child: SvgPicture.asset(
                    'assets/images/arrow.svg',
                    width: 20,
                  ),
                ),
              )),
        ]),
        Spacer(),
        Container(
            child: InkWell(
              onTap: () => setState(() {
                isBovandakMenu = !isBovandakMenu;
                isFavorite = false;

                isSettings = false;
                isShare = false;
                isYoutubeActive = false;
                //  print("BovandakMenu :: $isBovandakMenu");
              }),
              child: SvgPicture.asset(
                'assets/images/bovandakutyun_menu.svg',
                color: isBovandakMenu ? Palette.whenTapedButton : null,
                width: 30,
              ),
            )),
        Spacer(),
        // SizedBox(
        //   // height: 120,
        //   // width: 32,
        //   child: Stack(children: [
        //     SizedBox(
        //         height: 80,
        //         width: 50,
        //         child: Center(
        //           child: InkWell(
        //             onTap: () {
        //               setState(() {
        //                 isFavorite = !isFavorite;
        //                 isBovandakMenu = false;
        //                 isSettings = false;
        //                 isShare = false;
        //                 isYoutubeActive = false;
        //                 //  print("Favorite :: $isFavorite");
        //               });
        //             },
        //             child: SvgPicture.asset(
        //               'assets/images/favorite.svg',
        //               width: 20,
        //               color: isFavorite ? Palette.whenTapedButton : null,
        //             ),
        //           ),
        //         )),
        //   ]),
        // ),
      ],
    );
  }

  Widget hideBottomBarMenu() {
    final mediaQuery = MediaQuery.of(context).size;
    final book = context.read<ContentProvider>().bookContents;
    final theme = context.read<ThemeNotifier>();

    return Stack(
      children: [
        Stack(
          children: [
            Container(
              color: theme.backgroundColor != null
                  ? theme.backgroundColor
                  : Palette.textLineOrBackGroundColor,
              child: Container(
                alignment: Alignment(0, -1),
                color: isBovandakMenu &&
                    encyclopediaBody?.body == null &&
                    isBovandakMenu &&
                    searchData?.title == null &&
                    isBovandakMenu ||
                    readScreen?.body != null && isFavorite
                    ? Color.fromRGBO(35, 35, 35, 0.5)
                    : theme.backgroundColor != null
                    ? theme.backgroundColor
                    : Palette.textLineOrBackGroundColor,
                height: 181,
                width: double.infinity,
                child: Column(children: [
                  Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 15.0),
                          hideMenuAppBar(),
                          // HideMenuAppBar(
                          //   isBovandakMenu: isBovandakMenu,
                          //   isFavorite: isFavorite,
                          // ),
                          SizedBox(
                              width: 250,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  searchData?.title != null
                                      ? '${searchData?.title} '
                                      : isShowTitle == true && book?.title != null
                                      ? '${book?.title}'
                                      : '${encyclopediaBody?.title}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                              width: 300,
                              // height: 50,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  searchBodyData?.author != null
                                      ? '${searchBodyData?.author}'
                                      : isShowTitle == true && book?.title != null
                                      ? '${book?.author}'
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                      height: 1),
                                ),
                              )),
                        ],
                      )),
                ]),
              ),
            ),
            isVisiblty
                ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                child: Container(
                  color: book?.content != null && isBovandakMenu ||
                      isFavorite
                      ? theme.backgroundColor != null
                      ? theme.backgroundColor
                      : Color.fromRGBO(35, 35, 35, 0.5)
                      : theme.backgroundColor != null
                      ? theme.backgroundColor
                      : Palette.textLineOrBackGroundColor,
                  height: 80,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 3.0,
                                color: isYoutubeActive || isSettings
                                    ? Colors.amber
                                    : theme.backgroundColor != null
                                    ? theme.backgroundColor
                                    : Palette
                                    .textLineOrBackGroundColor,
                              ))),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: isYoutubeActive || isSettings
                                ? Color.fromRGBO(31, 31, 31, 0.5)
                                : theme.backgroundColor != null
                                ? theme.backgroundColor
                                : Palette.textLineOrBackGroundColor,
                            height: 77.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() {
                                        isYoutubeActive = !isYoutubeActive;
                                        isSettings = false;
                                        isShare = false;
                                        isFavorite = false;
                                        isBovandakMenu = false;
                                      }),
                                      child: SvgPicture.asset(
                                        'assets/images/youtube.svg',
                                        color: isYoutubeActive
                                            ? Palette.whenTapedButton
                                            : null,
                                        fit: BoxFit.none,
                                      ),
                                    )),
                                Expanded(
                                    child: InkWell(
                                      onTap: ()  {
                                        if (!isShare && widget.isFromHomePage == null){
                                           Share.share(
                                            searchBodyData?.sharurl != null
                                                ? '${searchBodyData?.sharurl} '
                                                : isShowTitle == true &&
                                                readScreen?.sharurl != null
                                                ? '${readScreen?.sharurl}'
                                                : '${encyclopediaBody?.sharurl}',
                                          ).then((value) {
                                            setState(() {
                                              isShare = false;
                                              isYoutubeActive = false;
                                              isSettings = false;

                                              isFavorite = false;
                                              isBovandakMenu = false;
                                            });
                                          });
                                        }
                                        if (!isShare && widget.isFromHomePage == true){
                                        if(readScreen?.sharurl != null)  Share.share('${readScreen?.sharurl} ').then((value) {
                                          setState(() {
                                            isShare = false;
                                            isYoutubeActive = false;
                                            isSettings = false;

                                            isFavorite = false;
                                            isBovandakMenu = false;
                                          });
                                        });
                                        }

                                          setState(() {
                                          isShare = true;

                                          });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/share.svg',
                                        color: isShare
                                            ? Palette.whenTapedButton
                                            : null,
                                        fit: BoxFit.none,
                                      ),
                                    )),
                                Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isSettings = !isSettings;
                                          isYoutubeActive = false;
                                          isShare = false;

                                          isFavorite = false;
                                          isBovandakMenu = false;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/settings.svg',
                                        color: isSettings
                                            ? Palette.whenTapedButton
                                            : null,
                                        fit: BoxFit.none,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                : Container(),
            book?.content != null && isBovandakMenu
                ? Positioned(
              top: 90,
              child: Container(
                color: Color.fromRGBO(31, 31, 31, 0.7),
                height: mediaQuery.height,
                width: mediaQuery.width,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Palette.whenTapedButton,
                            height: 3.0,
                          ),
                          Container(
                              color: theme.backgroundColor != null
                                  ? theme.backgroundColor
                                  : Palette.textLineOrBackGroundColor,
                              child: GlobalBovandakLists()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Container(),
            isYoutubeActive ? youtubeShow() : Container(),
            //isFavorite ? favoriteShow() : Container(),
           // isSettings ? settingsShow() : Container(),
          ],
        ),
      ],
    );
  }

  Widget youtubeShow() {

    final mediaQuery = MediaQuery.of(context).size;
    final theme = context.read<ThemeNotifier>();
    final orentation = MediaQuery.of(context).orientation;
    return Container(

        color: Color.fromRGBO(31, 31, 31, 0.5),
        width: mediaQuery.width,
        height: 400,
        child: Column(children: [
          Expanded(
            child: Container(
                width: mediaQuery.width,
                child: Container(
                  color: theme.backgroundColor != null
                      ? theme.backgroundColor
                      : Palette.textLineOrBackGroundColor,
                  width: mediaQuery.width,
                  padding: EdgeInsets.only(top: 20,bottom: 20),

                  child: Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                            builder: (_) => VideoView(
                              link:  readScreen?.videoLink!= null
                                  ? '${readScreen?.videoLink!}'
                                  : searchBodyData?.video_link != null
                                  ? '${searchBodyData?.video_link!}'
                                  : "${encyclopediaBody?.video_link!}"
                            )));
                      },
                      child: Container(
                        width: orentation == Orientation.landscape
                            ? 450
                            : double.infinity,

                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Stack(
                          children: [
                            if (encyclopediaBody?.image != null ||
                                readScreen?.image != null ||
                                searchData?.image != null)
                              Align(
                                  alignment: Alignment.center,
                                  child: CachedNetworkImage(
                                    useOldImageOnUrlChange: true,
                                    imageUrl: YoutubeThumbnail(youtubeId: getIdFromUrl(readScreen?.videoLink!= null
                                        ? '${readScreen?.videoLink!}'
                                        : searchBodyData?.video_link != null
                                        ? '${searchBodyData?.video_link!}'
                                        : "${encyclopediaBody?.video_link!}")).hd(),
                                    fit: BoxFit.contain,
                                  )),
                            Positioned.fill(
                              bottom: 0.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          )
        ]));
  }

  Widget favoriteShow() {
    final mediaQuery = MediaQuery.of(context).size;
    final theme = context.read<ThemeNotifier>();
    final orentation = MediaQuery.of(context).orientation;

    return Positioned(
      top: 90,
      child: Container(
        color: Color.fromRGBO(31, 31, 31, 0.7),
        height: mediaQuery.height,
        width: mediaQuery.width,
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Palette.whenTapedButton,
                  height: 3.0,
                ),
                // SizedBox(height: 15.0),
                // Container(
                //   color: Palette.textLineOrBackGroundColor,
                //   child: Text(
                //     'Պահպանած էջեր',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                //   ),
                // ),

                Container(
                  color: theme.backgroundColor != null
                      ? theme.backgroundColor
                      : Palette.textLineOrBackGroundColor,
                  child: Column(
                    children: [
                      SizedBox(height: 15.0),
                      Text(
                        'Պահպանած էջեր',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          //itemCount: 3,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: Text('$index'),
                                  title: Text('Data$index'),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
                ),

                // Expanded(
                //   child: Container(
                //     color: theme.backgroundColor != null
                //         ? theme.backgroundColor
                //         : Palette.textLineOrBackGroundColor,
                //     height: orentation == Orientation.landscape
                //         ? mediaQuery.height / 1.55
                //         : mediaQuery.height,
                //     width: mediaQuery.width,
                //     child: Column(
                //       children: [
                //         SizedBox(height: 15.0),
                //         Text(
                //           'Պահպանած էջեր',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               fontSize: 16, fontWeight: FontWeight.bold),
                //         ),
                //         ListView.builder(
                //             shrinkWrap: true,
                //             itemCount: 4,
                //             scrollDirection: Axis.vertical,
                //             itemBuilder: (context, index) {
                //               return Column(
                //                 children: [
                //                   ListTile(
                //                     leading: Text('$index'),
                //                     title: Text('Data$index'),
                //                   ),
                //                   Divider(
                //                     thickness: 1,
                //                   ),
                //                 ],
                //               );
                //             }),
                //         // Container(
                //         //   width: mediaQuery.width,
                //         //   height: mediaQuery.height - 120,
                //         //   child: ListView.builder(
                //         //       shrinkWrap: true,
                //         //       itemCount: 4,
                //         //       scrollDirection: Axis.vertical,
                //         //       itemBuilder: (context, index) {
                //         //         return Column(
                //         //           children: [
                //         //             ListTile(
                //         //               leading: Text('$index'),
                //         //               title: Text('Data$index'),
                //         //             ),
                //         //             Divider(
                //         //               thickness: 1,
                //         //             ),
                //         //           ],
                //         //         );
                //         //       }),
                //         // ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ]),
      ),
    );
  }



  Widget shareShow() {
    final mediaQuery = MediaQuery.of(context).size;
    final orentation = MediaQuery.of(context).orientation;

    final theme = context.read<ThemeNotifier>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Container(
        color: Color.fromRGBO(31, 31, 31, 0.5),
        child: Stack(
          children: [
            Positioned(
              top: orentation == Orientation.landscape
                  ? MediaQuery.of(context).size.height / 3
                  : MediaQuery.of(context).size.height / 1.48,
              child: Container(
                color: theme.backgroundColor != null
                    ? theme.backgroundColor
                    : Palette.textLineOrBackGroundColor,
                height: mediaQuery.height,
                width: mediaQuery.width,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              SizedBox(height: 15.0),
                              Padding(
                                padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // showDialog(
                                    //     context: context,
                                    //     barrierDismissible: false,
                                    //     builder: (
                                    //       context,
                                    //     ) =>
                                    //         SaveShowDialog(
                                    //           isShow: true,
                                    //         ));
                                  },
                                  child: Text(
                                    'Կիսվել',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                                child: Divider(
                                  color: Color.fromRGBO(226, 224, 224, 1),
                                  thickness: 1,
                                ),
                              ),
                              Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/messenger 2.svg'),
                                          SvgPicture.asset(
                                              'assets/images/whatsapp 2.svg'),
                                          SvgPicture.asset('assets/images/gmail 2.svg'),
                                          SvgPicture.asset(
                                              'assets/images/messenger 2.svg'),
                                          SvgPicture.asset(
                                              'assets/images/vk-social-logotype (1) 2.svg'),
                                          SvgPicture.asset(
                                              'assets/images/facebook (1) 4.svg'),
                                          SvgPicture.asset(
                                              'assets/images/twitter (1) 4.svg'),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void userIsSign() async {
    final tabProvider = Provider.of<TabProvider>(context,listen: false);

    var data = <String,dynamic>{};
    String type = encyclopediaBody != null ? 'encyclopedias'
        : readScreen != null ? 'libraries':

    searchData != null ? 'encyclopedias' :  'libraries';
    int? id = encyclopediaBody != null ? encyclopediaBody?.id
        : readScreen != null ? widget.saveId:

    searchData != null ? encyclopediaBody?.id :   widget.saveId ?? searchData?.id;
 await   userDataProvider.fetchUserInfo().then((value) {

   data = <String,dynamic>{
        'type':
        type,
        'type_id':
        id,
        'customer_id':
        value?.id,
      };
    });
   if(data.isNotEmpty){
     tabProvider.updateSaveData(data,context);
     if(!isShowingDialog){
       isShowingDialog = true;
       showDialog(
           context: context,
           barrierDismissible: false,
           builder: (
               context,
               ) =>
               SaveShowDialog(
                 data:data,
                 isShow: false,
               )).then((_) {
         isShowingDialog = false;
       });
     }


   }


  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.read<ThemeNotifier>();
    var theme = appTheme.theme != null ? appTheme.theme : appTheme.lightTheme;
    return readScreen != null || encyclopediaBody != null || searchData != null
        ? Theme(
      data: theme,
      child: SafeArea(
        child: Scaffold(
            body: GestureDetector(
              onTap: (){
                setState(() {
                  isVisiblty = false;
                  isBovandakMenu = false;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: appTheme.readBookBackgroundColor != null
                          ? appTheme.readBookBackgroundColor
                          : Color.fromRGBO(226, 225, 224, 1),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Expanded(
                            child: RawScrollbar(
                                thumbColor: Palette.whenTapedButton,
                                thickness: 5,
                                crossAxisMargin: 5,
                                radius: const Radius.circular(12),
                                thumbVisibility: true,
                                child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 238,
                                        width: double.infinity,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                                bottom: 49,
                                                child: Align(
                                                    alignment:
                                                    Alignment.center,
                                                    child: Container(
                                                      height: 94,
                                                      width: double.infinity,
                                                      color: Color.fromRGBO(
                                                          164, 171, 189, 1),
                                                    ))),
                                            Positioned.fill(
                                                child: Align(
                                                    alignment:
                                                    Alignment.topCenter,
                                                    child: Container(
                                                      height: 180,
                                                      width: 140,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: Palette
                                                            .textLineOrBackGroundColor,
                                                        border: Border.all(
                                                          color:
                                                          Color.fromRGBO(
                                                              51,
                                                              51,
                                                              51,
                                                              1),
                                                          width: 01,
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          if (encyclopediaBody
                                                              ?.image !=
                                                              null ||
                                                              readScreen
                                                                  ?.image !=
                                                                  null || searchData?.image != null)
                                                            Positioned.fill(
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .center,
                                                                  child: SizedBox(
                                                                      height: 164.0,
                                                                      width: 122.0,
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: encyclopediaBody !=
                                                                            null
                                                                            ? '${encyclopediaBody?.image}'
                                                                            : readScreen?.image!= null ?'${readScreen?.image}':
                                                                        '${searchData?.image}',
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      )),
                                                                ))
                                                        ],
                                                      ),
                                                    ))),

                                                 Positioned.fill(
                                                child: Align(
                                                  alignment: Alignment
                                                      .bottomCenter,
                                                  child: Container(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20.0),
                                                      color: Palette
                                                          .textLineOrBackGroundColor,
                                                      width:
                                                      double.infinity,
                                                      height: 49,
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap:
                                                                () async {
                                                              String? share = encyclopediaBody != null? encyclopediaBody?.sharurl :
                                                                  searchBodyData != null ? searchBodyData?.sharurl : readScreen != null
                                                                      ? readScreen?.sharurl :searchBodyData?.sharurl ;


                                                              await Share.share(share!);
                                                              print(
                                                                  'dadas');
                                                              // showDialog(
                                                              //     context:
                                                              //         context,
                                                              //     barrierDismissible:
                                                              //         true,
                                                              //     builder: (
                                                              //       context,
                                                              //     ) =>
                                                              //         SaveShowDialog(
                                                              //             isShow:
                                                              //                 false));
                                                            },
                                                            child: Row(
                                                              children: [
                                                                //  const SizedBox(width: 16),
                                                                SvgPicture
                                                                    .asset(
                                                                    'assets/images/այքըններ.svg'),
                                                                const SizedBox(
                                                                    width:
                                                                    6),
                                                                const Text(
                                                                    'Կիսվել')
                                                              ],
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          InkWell(
                                                            onTap: () =>userIsSign(),
                                                            child: Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                    'assets/images/վելացնել1.svg'),
                                                                const SizedBox(
                                                                    width:
                                                                    6),
                                                                const Text(
                                                                    'Պահել'),
                                                                //const SizedBox(width: 16),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ))

                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Center(
                                          child: SizedBox(
                                              width: 235,
                                              child: Text(
                                                encyclopediaBody != null
                                                    ? '${encyclopediaBody?.title ?? ''}'
                                                    :readScreen?.title != null ? '${readScreen?.title }' : '${searchBodyData?.title ?? ''}',
                                                style: TextStyle(
                                                    fontFamily:
                                                    'GHEAGrapalat',
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    letterSpacing: 1),
                                                textAlign: TextAlign.center,
                                              ))),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        width: MediaQuery.of(context).size.width,
                                        child: HtmlWidget(
                                          listText,
                                          onTapUrl: (url)=> _openUrl(url)
                                          ,
                                        ),
                                        // child: Html(
                                        //    data: listText,
                                        //   // document: dom.Document.html(listText),
                                        //   onCssParseError: (css, messages) {
                                        //     debugPrint("css that errored: $css");
                                        //     debugPrint("error messages:");
                                        //     for (var element in messages) {
                                        //       debugPrint(element.toString());
                                        //     }
                                        //     return '';
                                        //   },
                                        //
                                        //   customRenders: {
                                        //     tagMatcher("table"): CustomRender.widget(
                                        //       widget: (context, buildChildren) => SizedBox(
                                        //         child: NotificationListener<ScrollNotification>(
                                        //           onNotification: (notification) => true,
                                        //           child: SingleChildScrollView(
                                        //             scrollDirection: Axis.horizontal,
                                        //             child: tableRender.call().widget!.call(context, buildChildren),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   },
                                        //
                                        //   shrinkWrap: true,
                                        //     onLinkTap: (url, _, __, ___) async{
                                        //       print("Opening $url...");
                                        //       if(url!=null){
                                        //         if(url.contains('http') || url.contains('https') ){
                                        //           if (await canLaunch(url)) {
                                        //             await launch(
                                        //               url,
                                        //             );
                                        //           } else {
                                        //             throw 'Could not launch $url';
                                        //           }
                                        //       }
                                        //
                                        //
                                        //     }
                                        //     },
                                        //     onImageTap: (src, _, __, ___) {
                                        //       print(src);
                                        //     },
                                        //     onImageError: (exception, stackTrace) {
                                        //       print(exception);
                                        //     },
                                        //
                                        //   style: {
                                        //     'body': Style(
                                        //       fontSize:  FontSize(_textSize),
                                        //     ),
                                        //
                                        //
                                        //
                                        //     'table': Style(
                                        //       width: Width(MediaQuery.of(context).size.width),
                                        //       // reduce width by 100 pixels
                                        //       lineHeight: LineHeight.em(1.3),
                                        //     ),
                                        //     'td': Style(
                                        //
                                        //       alignment: Alignment.centerLeft,
                                        //       after: ' ',
                                        //     ),
                                        //     'tr': Style(
                                        //       width: Width(MediaQuery.of(context).size.width-100),
                                        //       whiteSpace: WhiteSpace.pre,
                                        //       alignment: Alignment.center,
                                        //
                                        //     ),
                                        //     'img':Style(
                                        //
                                        //         width: Width(MediaQuery.of(context).size.width-30),
                                        //         alignment: Alignment.center,
                                        //
                                        //     ),
                                        //     'span': Style(
                                        //       fontSize: FontSize(17),
                                        //         width: Width(MediaQuery.of(context).size.width/2),
                                        //
                                        //         alignment: Alignment.center,
                                        //       maxLines: 2,
                                        //       after: ' ',
                                        //       textOverflow: TextOverflow.visible
                                        //
                                        //     ),
                                        //
                                        //
                                        //   },
                                        //
                                        // ),

                                      ),
                                      //Container(padding: EdgeInsets.only(left: 16.0,right: 16.0),child: RichText(text: textSpan),),
                                      if(readScreen != null && readScreen?.explanation != null || searchData != null &&  searchBodyData?.explanation != null ||  encyclopediaBody != null && encyclopediaBody?.explanation != null)
                                      SizedBox(height: 20,),
                                      Container(
                                        padding: EdgeInsets.only(top: 10,bottom: 5),
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            const Divider(
                                                indent: 20,
                                                endIndent:20,
                                                thickness: 2,color: Palette.main),
                                            SizedBox(height: 20),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          width: MediaQuery.of(context).size.width,
                                          child: HtmlWidget(
                                              readScreen != null && readScreen?.explanation != null  ?
                                                   '''${readScreen?.explanation}''': searchBodyData != null && searchBodyData?.explanation != null ?
                                                   '''${searchBodyData?.explanation}''' : encyclopediaBody != null &&  encyclopediaBody?.explanation != null ? '''${encyclopediaBody?.explanation}''' :  '''''',
                                          ),),
                                        //     Padding(
                                        //       padding: const EdgeInsets.only(left: 20,right: 20),
                                        //       child: Html(
                                        //         shrinkWrap: true,
                                        //           onLinkTap: (url, _, __, ___) async {
                                        //             print("Opening $url...");
                                        //       if(url!=null){
                                        //       if(url.contains('http') || url.contains('https') ){
                                        //       if (await canLaunch(url)) {
                                        //       await launch(
                                        //       url,
                                        //       );
                                        //       } else {
                                        //       throw 'Could not launch $url';
                                        //       }
                                        //       }
                                        //
                                        //           }},
                                        //           onImageTap: (src, _, __, ___) {
                                        //             print(src);
                                        //           },
                                        //           onImageError: (exception, stackTrace) {
                                        //             print(exception);
                                        //           },
                                        //
                                        //           data:readScreen != null && readScreen?.explanation != null  ?
                                        //           '''${readScreen?.explanation}''': searchBodyData != null && searchBodyData?.explanation != null ?
                                        //           '''${searchBodyData?.explanation}''' : encyclopediaBody != null &&  encyclopediaBody?.explanation != null ? '''${encyclopediaBody?.explanation}''' :  '''''',
                                        //           style: {
                                        //             'body': Style(
                                        //               fontSize: FontSize(
                                        //                   11),
                                        //             ),
                                        //           }                                              ),
                                        //
                                        //     ),
                                            SizedBox(height: 20),

                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ])),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      right: 20,
                      top: 8,
                      child: Align(alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: (){
                                 Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.arrow_back_ios_new_outlined,size: 20,color: Palette.barColor,)),
                            IconButton(
                                onPressed: (){
                                  // setState(() {
                                  //   isSettings = !isSettings;
                                  //   isBovandakMenu = false;
                                  // });
                                  settingsSheetBody();
                                },

                                icon: SvgPicture.asset(
                                  'assets/images/settings.svg',
                                  height:   20,
                                  width: 20,
                                ),),
                          ],
                        ),),
                    ),
                    isVisiblty ? hideBottomBarMenu() : Container(),
                   // isSettings ? settingsShow() : Container(),

                    // Positioned.fill(
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Container(
              //       color: Palette.textLineOrBackGroundColor,
              //       height: 77.0,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Expanded(
              //               child: InkWell(
              //                 onTap: () => setState(() {
              //                   isYoutubeActive = !isYoutubeActive;
              //                   isSettings = false;
              //                   isShare = false;
              //                   isFavorite = false;
              //                   isBovandakMenu = false;
              //                 }),
              //                 child: SvgPicture.asset(
              //                   'assets/images/youtube.svg',
              //                   color: isYoutubeActive
              //                       ? Palette.whenTapedButton
              //                       : null,
              //                   fit: BoxFit.none,
              //                 ),
              //               )),
              //
              //           Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   setState(() {
              //                     isSettings = !isSettings;
              //                     isYoutubeActive = false;
              //                     isShare = false;
              //
              //                     isFavorite = false;
              //                     isBovandakMenu = false;
              //                   });
              //                 },
              //                 child: SvgPicture.asset(
              //                   'assets/images/settings.svg',
              //                   color: isSettings
              //                       ? Palette.whenTapedButton
              //                       : null,
              //                   fit: BoxFit.none,
              //                 ),
              //               )),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
                    Positioned.fill(
                      bottom: 10,
                      child:  Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              iconSize: 30,
                              onPressed: ()  {

                                youtubeSheetBody();
                              },
                              color: Palette.barColor,
                              icon:  Image.asset(
                                'assets/images/youtube_icon.png',
                                width: 50,
                                height: 50,
                              ),


                            ),
                            IconButton(
                              iconSize: 30,
                              onPressed: ()  {
                                if (!isShare && widget.isFromHomePage == null){
                                  Share.share(
                                    searchBodyData?.sharurl != null
                                        ? '${searchBodyData?.sharurl} '
                                        : isShowTitle == true &&
                                        readScreen?.sharurl != null
                                        ? '${readScreen?.sharurl}'
                                        : '${encyclopediaBody?.sharurl}',
                                  );
                                }
                                if (!isShare && widget.isFromHomePage == true){
                                  if(readScreen?.sharurl != null)  Share.share('${readScreen?.sharurl} ');
                                }
                              },
                              color: Palette.barColor,
                              icon: Icon(Icons.share),


                            ),
                          ],
                        ),
                      ),)
                ],
                ),
              ),
            )

          // bottomNavigationBar:
        ),
      ),
    )
        : Container(
        child: Center(
          child: CircularProgressIndicator(color: Palette.main),
        ));
  }
  TextSpan substringForLink(String readText){
    var linkText = 'այս հղմամբ ։';
    print(linkText.length);
    if(readText.contains(linkText)){
     var text =  readText.length - linkText.length;

      var substring = readText.substring(text,text+linkText.length);
      var fullText = readText.replaceAll(linkText, '');
      return TextSpan(
        children: [
      TextSpan(
      text:
      ' $fullText',
    style: TextStyle(
    color: Colors.black,
    height: 2.5,
    fontWeight: FontWeight.w200,
    fontFamily: 'GHEAGrapalat',
    letterSpacing: 1),
    ),
          TextSpan(
            text: '$substring',
            style: TextStyle(
                fontWeight:
                FontWeight
                    .bold,
            color: Colors.blue),
            recognizer:
            TapGestureRecognizer()
              ..onTap = () {
              print('object');
              _launchURL();
              },
          ),
        ]
      ) ;

    }

    return  TextSpan(
      text:
      " ${listText.replaceAll(RegExp(r"[&nbsp;]"), '')}",
      style: TextStyle(
          color: Colors.black,
          height: 2.5,
          fontWeight: FontWeight.w200,
          //fontSize: textSize,
          fontFamily: 'GHEAGrapalat',
          letterSpacing: 1),
    );

  }
  _openUrl(String url) async{
    if(url!=null){
      if(url.contains('http') || url.contains('https') ){
        if (await canLaunch(url)) {
    await launch(
    url,
    );
    } else {
    throw 'Could not launch $url';
    }
  }


  }
  }
  _launchURL() async {

    var url = '${encyclopediaBody?.sharurl}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }

}
void settingsSheetBody(){
  final orientation = MediaQuery.of(context).orientation;

  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled:  orientation == Orientation.landscape ? true : false,
    builder: (context) {
      return  BookSetings(
      sizeChange: _increaseTextSize,
      sizeChangeSmall: _decreaseTextSize,
      );

    },
  );
}
void youtubeSheetBody(){
    showModalBottomSheet(context: context, builder: (context){
      return youtubeShow();
    });
}
}

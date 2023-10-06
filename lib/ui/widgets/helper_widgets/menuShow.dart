import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/models/book_data/category_lsit.dart';
import 'package:mashtoz_flutter/globals.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../../domens/repository/book_data_provdier.dart';
import '../../../domens/repository/user_data_provider.dart';
import '../../../tab_provider.dart';
import '../../utils/log_out_changenotifire.dart';
import '../main_page/bottom_bars_pages/bottom_bar_menu_pages.dart';
import '../main_page/main_menu_pages/abaut_us.dart';
import '../main_page/main_menu_pages/audio_library/audio_library.dart';
import '../main_page/main_menu_pages/contact_page.dart';
import '../main_page/main_menu_pages/dialect/dialect.dart';
import '../main_page/main_menu_pages/dictionary_screen/dictionary.dart';
import '../main_page/main_menu_pages/encyclopedia/encyclopedia.dart';
import '../main_page/main_menu_pages/gallery/galery_item.dart';

class MenuShow extends StatefulWidget {
  final bool fromHomePage;
  const MenuShow({Key? key, this.fromHomePage = false}) : super(key: key);

  @override
  State<MenuShow> createState() => _MenuShowState();
}

class _MenuShowState extends State<MenuShow>
    with SingleTickerProviderStateMixin {
  final bookDataProvider = BookDataProvider();
  bool iconAcitve = true;
  Future<List<BookCategory>>? menuFuture;
  int custemerId = 0;
  bool? isture = false;
  late AnimationController _controller;
  late FToast fToast;

  final userDataProvider = UserDataProvider();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    fToast = FToast();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    userDataProvider
        .fetchUserInfo()
        .then((value) => custemerId = value?.id ?? 0);
    userIsSign();

    super.initState();
  }

  bool _isDrawerOpen() {
    return _controller.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _controller.status == AnimationStatus.forward;
  }

  void _toggleDrawer() {
    if (_controller.isCompleted) {
      _controller.reverse();
      setState(() {
        iconAcitve = true;
      });
    } else {
      _controller.forward();
      setState(() {
        iconAcitve = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween(begin: 0, end: 0.5 * pi).animate(_controller);
    User? user = FirebaseAuth.instance.currentUser;
    final tabProvider = Provider.of<TabProvider>(context);

    return Container(
      height: double.infinity,
      width: 30,
      child: InkWell(
        onTap: () {
          print('dadasion');
          // context
          //     .read<BottomColorNotifire>()
          //     .setColor(Palette.libraryBacgroundColor);
          setState(() {
            _toggleDrawer();
            menuFuture = bookDataProvider.getCategoryLists(Api.menu, true);
          });
          showGeneralDialog(
              context: context,
              //     barrierDismissible: true,

              transitionDuration: const Duration(microseconds: 500),
              barrierLabel: MaterialLocalizations.of(context).dialogLabel,
              pageBuilder: (
                context,
                _,
                __,
              ) {
                return WillPopScope(
                  onWillPop: () async {
                    _toggleDrawer();
                    return true;
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          bottom: 60,
                          child: Container(
                            color: Palette.barColor,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: 150,
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      color: Palette.barColor,
                                      child: AppBar(
                                        leading: const SizedBox(
                                          width: 0.1,
                                        ),
                                        systemOverlayStyle:
                                            const SystemUiOverlayStyle(
                                                statusBarColor: Color.fromRGBO(
                                                    25, 4, 18, 1)),
                                        elevation: 0.0,
                                        backgroundColor:
                                            Palette.barColor.withOpacity(0.5),
                                        centerTitle: false,
                                        flexibleSpace: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        const HomeScreen())),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 30.0, left: 43),
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 20.0,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/images/mashtoz_org.svg',
                                                    width: 250,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        //toolbarHeight: 63,
                                        actions: [
                                          Container(
                                            width: 30,
                                            height: 51,
                                            child: InkWell(
                                              onTap: () {
                                                _toggleDrawer();
                                                Navigator.pop(context);
                                              },
                                              child: Stack(children: [
                                                Stack(
                                                  children: [
                                                    SimpleShadow(
                                                      child: SvgPicture.asset(
                                                        'assets/images/app_bar_icon_button.svg',

                                                        color: iconAcitve
                                                            ? Palette
                                                                .appBarIconMenuColor
                                                            : const Color
                                                                .fromRGBO(122,
                                                                108, 115, 1),
                                                        fit: BoxFit.cover,

                                                        //width: 60,
                                                        //width: 22,
                                                      ),
                                                      opacity: 0.15,
                                                      offset:
                                                          const Offset(0, 4),
                                                      color:
                                                          const Color.fromRGBO(
                                                              0, 0, 0, 0.15),
                                                    ),
                                                  ],
                                                ),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: AnimatedBuilder(
                                                      animation: animation,
                                                      builder:
                                                          (context, child) {
                                                        return Transform.rotate(
                                                          angle: animation.value
                                                              .toDouble(),
                                                          child: _isDrawerOpen() ||
                                                                  _isDrawerOpening()
                                                              ? SvgPicture
                                                                  .asset(
                                                                  'assets/images/close_bar_icon.svg',
                                                                  fit: BoxFit
                                                                      .none,
                                                                )
                                                              : SvgPicture
                                                                  .asset(
                                                                  'assets/images/asset_bar_icon.svg',
                                                                  fit: BoxFit
                                                                      .none,
                                                                ),
                                                        );
                                                      },
                                                    )),
                                              ]),
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
                          top: 170,
                          bottom: 60, //
                          child: Container(
                            //padding: EdgeInsets.only(bottom: 130),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(83, 66, 77, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(31, 31, 31, 1),
                                    blurRadius: 5.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0, 5.0),
                                  ),
                                ]),
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      children: [
                                        //!!
                                        Container(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              //margin: EdgeInsets.only(right: 75),

                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FutureBuilder<List<dynamic>?>(
                                                      future: menuFuture,
                                                      builder:
                                                          (context, snapshot) {
                                                        var data =
                                                            snapshot.data;

                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top:
                                                                          50.0),
                                                              child:
                                                                  const Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                strokeWidth:
                                                                    2.0,
                                                                color: Palette
                                                                    .main,
                                                              )));
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return const Text(
                                                                '');
                                                          } else if (snapshot
                                                              .hasData) {
                                                            return Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              50),
                                                                      child: ListView.builder(
                                                                          scrollDirection: Axis.vertical,
                                                                          shrinkWrap: true,
                                                                          physics: const AlwaysScrollableScrollPhysics(),
                                                                          itemCount: data?.length,
                                                                          itemBuilder: (contesxt, index) {
                                                                            return Column(
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: GestureDetector(
                                                                                    child: Container(
                                                                                      width: double.infinity,
                                                                                      height: 50.0,
                                                                                      child: Text(
                                                                                        '${data?[index].title}',
                                                                                        style: const TextStyle(
                                                                                          decoration: TextDecoration.none,
                                                                                          color: Palette.textLineOrBackGroundColor,
                                                                                          fontFamily: 'GHEAGrapalat',
                                                                                          letterSpacing: 1,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          fontSize: 12.0,
                                                                                        ),
                                                                                        textAlign: TextAlign.end,
                                                                                      ),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      switch (index) {
                                                                                        case 0:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();

                                                                                          Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                              builder: (_) => const Ecyclopedia(),
                                                                                            ),
                                                                                          );
                                                                                          break;
                                                                                        case 1:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();
                                                                                          Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (_) => ItalianPage(
                                                                                                      fromHomePage: true,
                                                                                                    )),
                                                                                          );
                                                                                          break;
                                                                                        case 2:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();

                                                                                          Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                              builder: (_) => const Dictionary(),
                                                                                            ),
                                                                                          );
                                                                                          break;
                                                                                        case 3:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();
                                                                                          Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(builder: (_) => const Dialect()),
                                                                                          );
                                                                                          break;
                                                                                        case 4:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();
                                                                                          Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(builder: (_) => const GalleryItem()),
                                                                                          );
                                                                                          break;
                                                                                        case 5:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();
                                                                                          Navigator.of(context, rootNavigator: true).push(
                                                                                            MaterialPageRoute(builder: (_) => const AudioLibrary()),
                                                                                          );
                                                                                          break;
                                                                                        case 6:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();
                                                                                          Navigator.push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                  builder: (_) => const InfoPage(
                                                                                                        isShow: true,
                                                                                                      )));

                                                                                          break;
                                                                                        case 7:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();
                                                                                          Navigator.push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                  builder: (_) => const InfoPage(
                                                                                                        isShow: false,
                                                                                                      )));
                                                                                          break;
                                                                                        case 8:
                                                                                          Navigator.pop(context);
                                                                                          _toggleDrawer();
                                                                                          Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(builder: (_) => const Contact()),
                                                                                          );
                                                                                          break;
                                                                                        default:
                                                                                      }
                                                                                      print('menu: $index');
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          } else {
                                                            return const Text(
                                                                'Empty data');
                                                          }
                                                        } else {
                                                          return Text(
                                                              'State: ${snapshot.connectionState}');
                                                        }
                                                      }),
                                                  tabProvider.userHasLogin ||
                                                          user != null
                                                      ? const Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Divider(
                                                            thickness: 1,
                                                            color:
                                                                Color.fromRGBO(
                                                                    122,
                                                                    108,
                                                                    115,
                                                                    0.7),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 0.1,
                                                          width: 0.1,
                                                        ),
                                                  tabProvider.userHasLogin ||
                                                          user != null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 0.1),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Container(
                                                              // color:
                                                              //     Colors.amber,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          50),
                                                              height: 50,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      tabProvider
                                                                          .logout();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      context
                                                                          .read<
                                                                              UserLogOutNotifier>()
                                                                          .usesHasLogOut(
                                                                              true);
                                                                      _toggleDrawer();
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                            'assets/images/log_out.svg'),
                                                                        const SizedBox(
                                                                            width:
                                                                                10.0),
                                                                        const Text(
                                                                          'Դուրս գալ',
                                                                          style: TextStyle(
                                                                              decoration: TextDecoration.none,
                                                                              color: Color.fromRGBO(186, 166, 177, 1),
                                                                              fontFamily: 'GHEAGrapalat',
                                                                              letterSpacing: 1,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 17.0),
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 0.1,
                                                          width: 0.1,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],

                                      //   ],
                                      // ),
                                    ),
                                  ),
                                ),
                                MediaQuery.of(context).size.width >= 520 &&
                                            MediaQuery.of(context).size.width <=
                                                630 ||
                                        MediaQuery.of(context).size.width >= 630
                                    ? Positioned.fill(
                                        left: 50,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                            .size
                                                            .width >=
                                                        520 &&
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width <=
                                                        630
                                                ? 200
                                                : MediaQuery.of(context)
                                                                .size
                                                                .width >=
                                                            630 &&
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width <=
                                                            730
                                                    ? 300
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >=
                                                            730
                                                        ? 500
                                                        : 400,
                                            width: MediaQuery.of(context)
                                                            .size
                                                            .width >=
                                                        520 &&
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width <=
                                                        630
                                                ? 200
                                                : MediaQuery.of(context)
                                                                .size
                                                                .width >=
                                                            630 &&
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width <=
                                                            730
                                                    ? 300
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >=
                                                            730
                                                        ? 500
                                                        : 400,
                                            //color: Colors.amber,
                                            child: const RiveAnimation.asset(
                                              'assets/images/mashtoz3.riv',
                                              alignment: Alignment.centerRight,
                                              // controllers: [_controller],
                                            ),
                                          ),
                                        ))
                                    : const SizedBox(
                                        width: 0.1,
                                        height: 0.1,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ).drive(
                    Tween<Offset>(
                        begin: const Offset(0, -1.0), end: Offset.zero),
                  ),
                  child: child,
                );
              });
        },
        child: Stack(children: [
          Stack(
            children: [
              SimpleShadow(
                child: SvgPicture.asset(
                  'assets/images/app_bar_icon_button.svg',

                  color: iconAcitve
                      ? Palette.appBarIconMenuColor
                      : const Color.fromRGBO(122, 108, 115, 1),
                  fit: BoxFit.none,

                  //width: 60,
                  //width: 22,
                ),
                opacity: 0.15,
                offset: const Offset(0, 4),
                color: const Color.fromRGBO(0, 0, 0, 0.15),
              ),
            ],
          ),
          Positioned.fill(
            right: 8,
            top: 10,
            child: Align(
                alignment: Alignment.topRight,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: animation.value.toDouble(),
                      child: _isDrawerOpen() || _isDrawerOpening()
                          ? SvgPicture.asset(
                              'assets/images/close_bar_icon.svg',
                              fit: BoxFit.none,
                            )
                          : SvgPicture.asset(
                              'assets/images/asset_bar_icon.svg',
                              fit: BoxFit.none,
                            ),
                    );
                  },
                )),
          ),
        ]),
      ),
    );
  }

  void userIsSign() async {
    final hasId = await userDataProvider.fetchUserInfo();
    if (mounted) {
      setState(() {
        isture = hasId != null &&
            hasId.fullName != null &&
            hasId.fullName!.isNotEmpty &&
            hasId.email != null &&
            hasId.email!.isNotEmpty &&
            hasId.email!.length > 2;
      });
      setState(() {
        isture = false;
      });
    }
  }
}

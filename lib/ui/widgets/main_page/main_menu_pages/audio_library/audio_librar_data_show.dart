import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/models/book_data/data.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube/youtube_thumbnail.dart';
import 'package:youtube_parser/youtube_parser.dart';

import '../../../../../domens/repository/user_data_provider.dart';
import '../../../../../globals.dart';
import '../../../../../tab_provider.dart';
import '../../../helper_widgets/menuShow.dart';
import '../../../helper_widgets/save_show_dialog.dart';
import '../../../youtube_videos/advanced_overlay.dart';

class AudioLibraryDataShow extends StatefulWidget {
  final Data? dataCharacter;
  final String? adbId;
  final String? firstCharacter;
  final bool? isFromNotifications;
  const AudioLibraryDataShow(
      {Key? key,
      this.firstCharacter,
      this.isFromNotifications,
      this.adbId,
      this.dataCharacter})
      : super(key: key);

  @override
  State<AudioLibraryDataShow> createState() => _AudioLibraryDataShowState(
      dataCharacter: dataCharacter,
      adbId: adbId,
      firstCharacter: firstCharacter);
}

class _AudioLibraryDataShowState extends State<AudioLibraryDataShow> {
  Data? dataCharacter;
  int? custemerId;
  String? adbId;
  String? firstCharacter;
  bool isShowingDialog = false;

  final userDataProvider = UserDataProvider();
  final bookDataProvider = BookDataProvider();
  _AudioLibraryDataShowState(
      {this.dataCharacter, this.adbId, this.firstCharacter});
  @override
  void initState() {
    userDataProvider.fetchUserInfo().then((value) => custemerId = value?.id);
    _findDataCharacterFromPushNotification();

    super.initState();
  }

  Future<void> _findDataCharacterFromPushNotification() async {
    try {
      if (adbId != null) {
        if (widget.isFromNotifications == true) {
          // Refresh data for BooksScreen and HomePage
          bookDataProvider.updateBooksAfterPushNotification();
          bookDataProvider.updateHomeAfterPushNotification(context);
          // Get a list of characters using audioLibrariesCharacters
          final characters =
              await bookDataProvider.getDialect_Encyclopaedia_Characters(
                  Api.audioLibrariesCharacters);

          // Collect futures to be awaited using Future.wait
          final futures = <Future>[];

          for (var nv in characters) {
            futures.add(
                // Fetch data by characters using audioLibrariesByCharacters
                bookDataProvider
                    .getDataByCharacters(Api.audioLibrariesByCharacters(nv))
                    .then((value) {
              for (var nValue in value) {
                if ("(${nValue.id})".toString().contains(adbId.toString())) {
                  dataCharacter = nValue;
                  setState(() {});
                  break;
                }
              }
            }));
          }

          // Wait for all the futures to complete
          await Future.wait(futures);
        } else {
          // Fetch data by characters using audioLibrariesByCharacters(firstCharacter)
          final value = await bookDataProvider.getDataByCharacters(
              Api.audioLibrariesByCharacters(firstCharacter));

          for (var nValue in value) {
            if ("(${nValue.id})".toString().contains(adbId.toString())) {
              dataCharacter = nValue;
              setState(() {});
              break;
            }
          }
        }
      }
    } catch (e) {
      // Handle any potential errors here
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    print("Ciki${dataCharacter?.video_link}");
    return dataCharacter != null
        ? Container(
            // width: mediaQuery.width,
            // height: mediaQuery.height,
            child: Scaffold(
              body: CustomScrollView(
                // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: [
                  // SliverAppBar(
                  //   expandedHeight: 73,
                  //   backgroundColor: Palette.textLineOrBackGroundColor,
                  //   pinned: false,
                  //   floating: true,
                  //   elevation: 0,
                  //   automaticallyImplyLeading: false,
                  //   systemOverlayStyle: SystemUiOverlayStyle(
                  //       statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
                  //   flexibleSpace: ActionsHelper(
                  //     leftPadding: 12,
                  //     // botomPadding: 0,
                  //     // topPadding: 30,
                  //     text: '${dataCharacter?.firstCharacter}',

                  //     fontFamily: 'GHEAGrapalat',
                  //     fontSize: 20,
                  //     laterSpacing: 1,
                  //     fontWeight: FontWeight.bold,
                  //     color: Palette.appBarTitleColor,
                  //     buttonShow: true,
                  //   ),
                  // ),
                  SliverAppBar(
                    flexibleSpace: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0, top: 5.0),
                        child: Text(
                          '${dataCharacter?.firstCharacter}',
                          style: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontFamily: 'GHEAGrapalat',
                              fontWeight: FontWeight.w700,
                              color: Palette.appBarTitleColor),
                        ),
                      ),
                    ),
                    pinned: false,
                    floating: true,
                    leading: SizedBox(
                      width: 8,
                      height: 14.0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Palette.appBarTitleColor,
                        ),
                      ),
                    ),
                    expandedHeight: 73,
                    backgroundColor: Palette.textLineOrBackGroundColor,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
                    actions: const [
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: MenuShow(),
                      ),
                    ],
                  ),
                  // SliverFillRemaining(
                  //   // child: YoutubePlayers(
                  //   //   lessons: lessons,
                  //   // ),
                  //   child: Container(
                  //     child: Center(
                  //       child: Text('DAvs'),
                  //     ),
                  //   ),
                  // ),
                  //! Ձայնադարան

                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          width: mediaQuery.width,
                          height: 300,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 70,
                                  left: 0,
                                  child: Stack(
                                    children: [
                                      Container(
                                          width: mediaQuery.width,
                                          height: 185,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                113, 141, 156, 1),
                                          )),
                                      Positioned.fill(
                                          child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: 350,
                                          height: 90,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              "${dataCharacter?.title}",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    25, 4, 18, 1),
                                                fontSize: 12,
                                                fontFamily: 'GHEAGrapalat',
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  )),
                              Container(
                                  child: Center(
                                child: SizedBox(
                                    width: 300,
                                    height: mediaQuery.height / 2,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                              width: 300,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      51, 51, 51, 1),
                                                  width: 01,
                                                ),
                                              ))),
                                      if (dataCharacter?.image != null &&
                                          dataCharacter!.image!.isNotEmpty)
                                        Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              width: 283,
                                              height: 134,
                                              // child: Text('Marjanja'),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${dataCharacter?.image}",
                                                fit: BoxFit.contain,
                                              ),
                                            )),
                                    ])),
                              )),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0),
                                      color: const Color.fromRGBO(
                                          246, 246, 246, 1),
                                      width: double.infinity,
                                      height: 49,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Share.share(
                                                  dataCharacter!.sharurl!);
                                              print('kisvel');
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/images/այքըններ.svg'),
                                                const SizedBox(width: 6),
                                                const Text('Կիսվել')
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              userIsSign(context);
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/images/վելացնել1.svg'),
                                                const SizedBox(width: 6),
                                                const Text('Պահել'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // YoutubePlayers(),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      width: 485,
                      child: Column(
                        children: [
                          Container(
                            child: Stack(
                              children: [
                                if (dataCharacter?.link != null &&
                                    dataCharacter!.link!.isNotEmpty)
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: CachedNetworkImage(
                                      useOldImageOnUrlChange: true,
                                      imageUrl: YoutubeThumbnail(
                                              youtubeId: getIdFromUrl(
                                                  dataCharacter!.link!))
                                          .hd(),
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      // height: SizeConfig
                                      //             .orentation ==
                                      //         Orientation
                                      //             .landscape
                                      //     ? (SizeConfig
                                      //                 .screenHeight! /
                                      //             3.55) *
                                      //         2
                                      height: mediaQuery.height / 3.55,
                                    ),
                                  ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(MaterialPageRoute(
                                                builder: (_) => VideoView(
                                                      link: widget
                                                          .dataCharacter?.link,
                                                    )));
                                      },
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
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
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              child: Html(
                                shrinkWrap: true,
                                data: """${dataCharacter?.summary}
                                """,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: Palette.main,
              ),
            ),
          );
  }

  void userIsSign(BuildContext context) async {
    final tabProvider = Provider.of<TabProvider>(context, listen: false);

    var data = <String, dynamic>{};

    await userDataProvider.fetchUserInfo().then((value) {
      data = <String, dynamic>{
        'type': 'audiolibraries',
        'type_id': dataCharacter?.id,
        'customer_id': value?.id,
      };
    });
    if (data.isNotEmpty) {
      tabProvider.updateSaveData(data, context);
      if (!isShowingDialog) {
        isShowingDialog = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SaveShowDialog(
            data: data,
            isShow: false,
          ),
        ).then((value) {
          // Reset the flag when the dialog is dismissed
          isShowingDialog = false;
        });
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/ui/widgets/youtube_videos/youtuve_player.dart';

import '../../helper_widgets/menuShow.dart';
import '../../helper_widgets/save_show_dialog.dart';

class TestBookDataYutubePlayer extends StatefulWidget {
  // final Lessons lessons;

  //const TestBookDataYutubePlayerByCharacters({Key? key, required this.lessons}) : super(key: key);

  @override
  State<TestBookDataYutubePlayer> createState() =>
      _TestBookDataYutubePlayerState();
}

class _TestBookDataYutubePlayerState extends State<TestBookDataYutubePlayer> {
  var textData =
      '135, 112. 2. 3. 4. 5. 6. 7. 8. 9. 10. 11. 12. 13. 14. 15. 16. 17. 18. 19. 20. 21. 22. 23. 24. 25. 26';

  // final Lessons lessons;
  // _TestBookDataYutubePlayerState({required this.lessons});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: true,
            title: Text(
              '{lessons.number}',
              style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                  fontFamily: 'GHEAGrapalat',
                  fontWeight: FontWeight.bold,
                  color: Palette.appBarTitleColor),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Palette.appBarTitleColor,
              ),
            ),
            expandedHeight: 73,
            backgroundColor: Palette.textLineOrBackGroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
            actions: [
              MenuShow(),
            ],
          ),
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
          //     text: '{lessons.number}',

          //     fontFamily: 'GHEAGrapalat',
          //     fontSize: 20,
          //     laterSpacing: 1,
          //     fontWeight: FontWeight.bold,
          //     color: Palette.appBarTitleColor,
          //     buttonShow: true,
          //   ),
          // ),
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
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: mediaQuery.width,
                  height: 275,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: 90,
                          left: 0,
                          child: Container(
                              width: mediaQuery.width,
                              height: 185,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(164, 171, 189, 1),
                              ))),
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
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        border: Border.all(
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          width: 01,
                                        ),
                                      ))),
                              Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    width: 122,
                                    height: 164,
                                    child: Text('Marjanja'),
                                    // child: CachedNetworkImage(
                                    //   imageUrl: book.image!,
                                    //   fit: BoxFit.cover,
                                    // ),
                                  )),
                            ])),
                      )),
                      Positioned(
                          top: 193,
                          left: mediaQuery.width / 5,
                          child: Container(
                            width: 246,
                            child: Text(
                              "{book.title}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(25, 4, 18, 1),
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          )),
                      Positioned(
                        top: mediaQuery.height / 3.5,
                        left: mediaQuery.width / 4.5,
                        child: Container(
                          width: 246,
                          child: Text(
                            'datas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(25, 4, 18, 1),
                                fontSize: 12,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    color: const Color.fromRGBO(246, 246, 246, 1),
                    width: double.infinity,
                    height: 49,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            print('kisvel');
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              SvgPicture.asset('assets/images/այքըններ.svg'),
                              const SizedBox(width: 6),
                              const Text('Կիսվել')
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('share anel paterin');
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (
                                  context,
                                ) =>
                                    SaveShowDialog(isShow: true));
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/վելացնել1.svg'),
                              const SizedBox(width: 6),
                              const Text('Պահել'),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 30),
                // YoutubePlayers(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                YoutubePlayers(
                  lessons: null,
                ),
              ],
            ),
          )

          //!Համաբարբառ
          // SliverToBoxAdapter(
          //   child: ListView.separated(
          //     shrinkWrap: true,
          //     physics: ClampingScrollPhysics(),
          //     separatorBuilder: ((context, index) => SizedBox(height: 30.0)),
          //     itemCount: 5,
          //     itemBuilder: (context, index) {
          //       return Expanded(
          //         // width: 300,
          //         // height: 300,
          //         //fit: BoxFit.fitHeight,
          //         child: Container(
          //           color: index % 2 != 0
          //               ? Color.fromRGBO(202, 217, 228, 1)
          //               : Color.fromRGBO(197, 202, 212, 1),
          //           child: Column(
          //             children: [
          //               Container(
          //                 width: double.infinity,
          //                 // constraints: BoxConstraints.expand(),
          //                 color: index % 2 != 0
          //                     ? Color.fromRGBO(172, 197, 215, 1)
          //                     : Color.fromRGBO(164, 171, 189, 1),
          //                 height: 44,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: [Text('Երեմիա')],
          //                 ),
          //               ),
          //               ListView.separated(
          //                   scrollDirection: Axis.vertical,
          //                   physics: ClampingScrollPhysics(),
          //                   shrinkWrap: true,
          //                   itemBuilder: (context, index) {
          //                     return Container(
          //                       padding: EdgeInsets.all(12.0),
          //                       child: IntrinsicHeight(
          //                           child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Container(
          //                             width: 50,
          //                             child: Wrap(children: [
          //                               Text(
          //                                 textData,
          //                                 textAlign: TextAlign.start,
          //                                 softWrap: true,
          //                               ),
          //                             ]),
          //                           ),
          //                           VerticalDivider(
          //                             color: Colors.black,
          //                             thickness: 1,
          //                           ),
          //                           Expanded(
          //                             flex: 1,
          //                             child: Align(
          //                               alignment: Alignment.topCenter,
          //                               child: Container(
          //                                   color: Colors.red,
          //                                   child: Text(
          //                                     '« ... Երուսաղէմի ողջ ազատանուն գերի տարաւ ... »',
          //                                     textAlign: TextAlign.start,
          //                                   )),
          //                             ),
          //                           ),
          //                         ],
          //                       )),
          //                     );
          //                   },
          //                   separatorBuilder: (context, index) =>
          //                       SizedBox(height: 20.0),
          //                   itemCount: 2),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

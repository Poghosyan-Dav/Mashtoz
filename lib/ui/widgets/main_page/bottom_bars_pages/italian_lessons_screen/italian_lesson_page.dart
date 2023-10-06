import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/main.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/menuShow.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../../../../config/palette.dart';
import '../../main_menu_pages/italian_lesson/italian_data_show.dart';

class ItalianPage extends StatefulWidget {
  bool? fromHomePage;
  ItalianPage({Key? key, this.fromHomePage}) : super(key: key);

  @override
  State<ItalianPage> createState() => _ItalianPageState();
}

class _ItalianPageState extends State<ItalianPage>
    with TickerProviderStateMixin {
  final bookDataProvider = BookDataProvider();
  Future<List<Lessons>>? lessonFuture;
  List<Lessons> lessons = [];

  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();

  final bool showPage = false;
  bool isOdd = false;
  bool isTurnLesson = true;
  @override
  void initState() {
    lessonFuture = bookDataProvider.getLessons();

    super.initState();

    _loadItems();
  }

  Future<void> _loadItems() async {
    List result = await bookDataProvider.getLessons();
    for (var item in result) {
      await Future.delayed(const Duration(milliseconds: 800));

      lessons.add(item);

      _listKey.currentState?.insertItem(lessons.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.textLineOrBackGroundColor,
        extendBodyBehindAppBar: true,
        body: CustomScrollView(slivers: [
          SliverAppBar(
            leading: isWhichPlatform
                ? IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new_outlined),
                    color: Palette.appBarTitleColor,
                  )
                : null,
            leadingWidth: isWhichPlatform ? 20 : null,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Իտալերենի դասեր',
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                    fontFamily: 'GHEAGrapalat',
                    fontWeight: FontWeight.bold,
                    color: Palette.appBarTitleColor),
              ),
            ),
            pinned: true,
            expandedHeight: 53,
            backgroundColor: Palette.textLineOrBackGroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
            actions: [
              Padding(padding: EdgeInsets.only(right: 20.0), child: MenuShow()),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 20.0),
              height: 60,
              width: 87,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isTurnLesson = !isTurnLesson;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Հին ',
                      style: TextStyle(
                          fontFamily: "GHEAGrapalat",
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Palette.main),
                    ),
                    SizedBox(width: 5.0),
                    SvgPicture.asset('assets/images/hin_nor.svg'),
                    SizedBox(width: 5.0),
                    Text('Նոր',
                        style: TextStyle(
                            fontFamily: "GHEAGrapalat",
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Palette.main)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<Lessons>>(
              future: lessonFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var listsLesson = snapshot.data;
                  return ResponsiveGridListBuilder(
                    horizontalGridSpacing:
                        16, // Horizontal space between grid items

                    verticalGridMargin: 50, // Vertical space around the grid
                    minItemWidth:
                        300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                    minItemsPerRow:
                        1, // The minimum items to show in a single row. Takes precedence over minItemWidth
                    maxItemsPerRow: 4, // T The m`
                    gridItems: List.generate(listsLesson!.length, (index) {
                      final Lessons italianLesson = listsLesson[index];
                      return index % 2 != 0
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: ITLesson(
                                  isOdd: true, italianLesson: italianLesson),
                            )
                          : ITLesson(
                              isOdd: false, italianLesson: italianLesson);
                    }),
                    builder: (context, items) {
                      return ListView(
                        reverse: isTurnLesson,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        children: items,
                      );
                    },
                  );
                } else {
                  return SizedBox(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Palette.main,
                      )),
                    ],
                  ));
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class ITLesson extends StatefulWidget {
  const ITLesson({Key? key, required this.isOdd, required this.italianLesson})
      : super(key: key);

  final bool isOdd;
  final Lessons italianLesson;

  @override
  _ItalianLessonState createState() =>
      // ignore: no_logic_in_create_state
      _ItalianLessonState(isOdd: isOdd, italianLesson: italianLesson);
}

class _ItalianLessonState extends State<ITLesson>
    with TickerProviderStateMixin {
  _ItalianLessonState({required this.italianLesson, required this.isOdd});
  final bool showPage = false;
  final bool isOdd;
  final Lessons italianLesson;
  bool selected = true;

  late Animation sizeRibbonAnimation, sizeNumberAnimation, sizeImageAnimation;

  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    // sizeRibbonAnimation =
    //     Tween<double>(begin: 0.0, end: 304.0).animate(_controller);

    // sizeImageAnimation =
    //     Tween<double>(begin: -220.0, end: 16.0).animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sizeRibbonAnimation = Tween<double>(begin: 0.0, end: 340) //340
        .animate(_controller);
    sizeNumberAnimation = Tween<double>(begin: 0.0, end: 300) //300
        .animate(_controller);
    sizeImageAnimation = Tween<double>(begin: -220.0, end: 12) //12
        .animate(_controller);
    print(MediaQuery.of(context).size.width / 1.34);
    return InkWell(
      onTap: () {
        print('dadas youtube');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ItaliaLessonShow(
                      lessons: italianLesson,
                      isShow: true,
                    )));
      },
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 218,
          child: Stack(children: <Widget>[
            Positioned(
                top: 56,
                left: 0,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 46,
                    child: Stack(children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: sizeRibbonAnimation.value,
                            height: 46,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(84, 112, 126, 1),
                            )),
                      ),
                      Positioned(
                        top: 13.5,
                        left: sizeNumberAnimation.value,
                        child: isOdd
                            ? Transform(
                                transform: Matrix4.rotationY(math.pi),
                                alignment: Alignment.center,
                                child: Text(
                                  '${italianLesson.number}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'GHEA GHEAGrapalat',
                                      fontSize: 20,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ))
                            : Text(
                                italianLesson.number!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'GHEA GHEAGrapalat',
                                    fontSize: 20,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                      ),
                    ]))),
            Positioned(
                top: 0,
                left: sizeImageAnimation.value,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 300 ? 276 : 300,
                  height: 150,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width > 300
                                ? 276
                                : 300,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: const Color.fromRGBO(25, 4, 18, 1),
                                width: 1,
                              ),
                            ))),
                    Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width > 300
                              ? 268
                              : 300,
                          height: 142,
                          child: CachedNetworkImage(
                            imageUrl: italianLesson.image!,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ]),
                )),
            Positioned(
                top: 158,
                left: 20,
                child: isOdd
                    ? Transform(
                        transform: Matrix4.rotationY(math.pi),
                        alignment: Alignment.center,
                        child: AnimatedOpacity(
                          opacity: _controller.isCompleted ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 100),
                          child: SizedBox(
                            width: 300,
                            child: Text(
                              italianLesson.title!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  color: Color.fromRGBO(84, 112, 126, 1),
                                  fontFamily: 'GHEA GHEAGrapalat',
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.6),
                              maxLines: 2,
                            ),
                          ),
                        ))
                    : AnimatedOpacity(
                        opacity: _controller.isCompleted ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 100),
                        child: InkWell(
                          onTap: () {
                            print('cik');
                          },
                          child: SizedBox(
                            width: 300,
                            child: Text(
                              italianLesson.title!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                color: Color.fromRGBO(84, 112, 126, 1),
                                fontFamily: 'GHEA GHEAGrapalat',
                                fontSize: 12,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1.6,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      )),
          ])),
    );
  }
}

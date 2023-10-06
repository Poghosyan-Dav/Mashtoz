import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mashtoz_flutter/domens/models/book_data/search_data.dart';
import 'package:mashtoz_flutter/domens/repository/search_book_data_provider.dart';
import 'package:mashtoz_flutter/main.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '/config/palette.dart';
import '../../helper_widgets/menuShow.dart';
import '../library_pages/book_page.dart';
import '../library_pages/book_read_screen.dart';
import '../main_menu_pages/audio_library/audio_librar_data_show.dart';
import '../main_menu_pages/italian_lesson/italian_data_show.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<Search>>? booksSearchFuture;
  final controller = TextEditingController();
  Timer? debouncer;
  String query = '';
  final searchBookProvider = SearchBookProvider();

  var searchbooks = <Search>[];
  var searcjBookforDisplay = <Search>[];
  List<String> strongList = [
    'libraries',
    'lessons',
    'autiolibraries',
    "italians",
    "encyclopedias"
  ];
  String selected = 'libraries';

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    init();
    controller.dispose();
    super.initState();
  }

  void searchPageination(int? id, String? type) {
    switch (type) {
      case 'libraries':
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => BookInitalScreen(
              idLib: id.toString(),
              categoryID: '',
            ),
          ),
        );
        print('Selected: libraries');
        break;
      case 'lessons':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ItaliaLessonShow(
                      idLessons: id.toString(),
                      isShow: true,
                    )));
        print('Selected: lessons');
        break;
      case 'autiolibraries':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AudioLibraryDataShow(
                      adbId: id.toString(),
                    )));
        // Handle case for 'autiolibraries'
        print('Selected: autiolibraries');
        break;
      case 'encyclopedias':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BookReadScreen(
                      encyId: id.toString(),
                    )));
        break;

      default:
        // Handle default case
        print('Selected: unknown');
    }
  }

  Future init() async {
    final books = await SearchBookProvider.fetchAllBooks(query);

    setState(() => this.searchbooks = books);
  }

  Future searchBook(String query) async => debounce(() async {
        final books = await SearchBookProvider.fetchAllBooks(query);
        if (!mounted) return;

        setState(() {
          this.query = query;
          this.searchbooks = books;
        });
      });

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(microseconds: 333),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    print(controller.text);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Palette.searchBackGroundColor,
          extendBodyBehindAppBar: false,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: CustomScrollView(
              slivers: [
                // ),
                SliverAppBar(
                  leading: isWhichPlatform
                      ? IconButton(
                          padding: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back_ios_new_outlined),
                          color: Palette.appBarTitleColor,
                        )
                      : null,
                  leadingWidth: isWhichPlatform ? 20 : null,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Որոնել',
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          fontFamily: 'GHEAGrapalat',
                          fontWeight: FontWeight.bold,
                          color: Palette.appBarTitleColor),
                    ),
                  ),
                  expandedHeight: 53,
                  backgroundColor: Palette.searchBackGroundColor,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
                  actions: [
                    MenuShow(),
                  ],
                ),
                SliverFillRemaining(
                  fillOverscroll: true,
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: TextField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(226, 224, 224, 1),
                                  ),
                                  borderRadius: BorderRadius.zero),
                              hintText: 'Գրել այստեղ․․․',
                              suffixIcon: Container(
                                height: double.infinity,
                                child: SvgPicture.asset(
                                  'assets/images/search.svg',
                                  semanticsLabel: 'search',
                                  color: Color.fromRGBO(122, 108, 115, 1),
                                ),
                              ),
                              suffixIconConstraints: BoxConstraints.tightFor(
                                  height: 30, width: 80)),
                          autofocus: false,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: searchBook,
                        ),
                      ),
                      searchbooks.isNotEmpty
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 50.0,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Որոնման արդյունքները',
                                    style: TextStyle(
                                        color: Color.fromRGBO(122, 108, 115, 1),
                                        fontFamily: "GHEAGrapalat",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            )
                          : searchbooks.isEmpty && query.isNotEmpty ||
                                  controller.text.length > 0
                              ? Center(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Նման արդյունք չի գտնվել',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(122, 108, 115, 1),
                                          fontFamily: "GHEAGrapalat",
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                )
                              : SizedBox(height: 20.0),
                      Expanded(
                          child: ResponsiveGridList(
                        horizontalGridSpacing:
                            16, // Horizontal space between grid items

                        verticalGridMargin:
                            50, // Vertical space around the grid
                        minItemWidth:
                            388, // The minimum item width (can be smaller, if the layout constraints are smaller)
                        minItemsPerRow:
                            1, // The minimum items to show in a single row. Takes precedence over minItemWidth
                        maxItemsPerRow: 4, // The m
                        children: List.generate(searchbooks.length, (index) {
                          Search book = searchbooks[index];
                          print(book.type);
                          return InkWell(
                            onTap: () {
                              searchPageination(book.id, book.type);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: double.infinity,
                                    height: 180,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            width: 116,
                                            height: 160,
                                            child: CachedNetworkImage(
                                              imageUrl: book.image!,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      Positioned(
                                          top: 63,
                                          left: 126,
                                          child: Container(
                                            width: 200,
                                            child: Text(
                                              "  ${book.title}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      25, 4, 18, 1),
                                                  fontFamily:
                                                      'GHEA GHEAGrapalat',
                                                  fontSize: 12,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1),
                                              maxLines: 4,
                                            ),
                                          )),
                                      Positioned(
                                          top: 156,
                                          left: 185,
                                          child: Transform.rotate(
                                            angle: 0.1 * (math.pi / 180),
                                            child: SvgPicture.asset(
                                              'assets/images/vector81.svg',
                                              semanticsLabel: 'vector81',
                                              color: Palette.main,
                                            ),
                                          )),
                                      Positioned(
                                          top: 180,
                                          left: 0,
                                          child: Transform.rotate(
                                            angle: 0.000005008956538086317 *
                                                (math.pi / 180),
                                            child: Divider(
                                                color: Color.fromRGBO(
                                                    122, 108, 115, 1),
                                                thickness: 0.5),
                                          )),
                                    ])),
                                Divider(
                                  thickness: 1,
                                  color: Color.fromRGBO(122, 108, 115, 1),
                                ),
                                SizedBox(
                                  height: 20.0,
                                )
                              ],
                            ),
                          );
                        }),
                      ))
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

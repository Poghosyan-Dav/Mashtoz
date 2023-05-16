import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashtoz_flutter/domens/models/book_data/book_channgeNotifire.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/globals.dart';
import 'package:mashtoz_flutter/ui/utils/url_data_lounch.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/menuShow.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '/config/palette.dart';
import '../../../../../domens/models/book_data/data.dart';

String? diId;

class DialectByCharacters extends StatefulWidget {
  const DialectByCharacters({
    Key? key,
    required this.characters,
    required this.characterByindex,
    required this.characterIndex,
    this.dId,
  }) : super(key: key);

  final String characterByindex;
  final int characterIndex;
  final List<Object> characters;
  final String? dId;

  @override
  _DialectByCharactersState createState() => _DialectByCharactersState(
        characters: characters,
        characterByindex: characterByindex,
        characterIndex: characterIndex,
        dId: dId,
      );
}

class _DialectByCharactersState extends State<DialectByCharacters>
    with SingleTickerProviderStateMixin {
  _DialectByCharactersState({
    required this.characters,
    required this.characterByindex,
    required this.characterIndex,
    this.dId,
  });
  final String? dId;
  final bookDataProvider = BookDataProvider();
  final String characterByindex;
  final int characterIndex;
  final List<Object> characters;
  Future<List<Data>?>? charctersData;
  @override
  void initState() {
    if (dId != null) diId = dId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final charcterNotifire =
        Provider.of<BookNotifire>(context).firstCharactersDialect;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            flexibleSpace: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                ),
                child: Container(
                  height: 73,
                  padding: EdgeInsets.only(top: 18),
                  child: Text(
                    charcterNotifire.isNotEmpty
                        ? '${charcterNotifire.toUpperCase()}'
                        : '${characterByindex.toUpperCase()}',
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontFamily: 'GHEAGrapalat',
                        fontWeight: FontWeight.w700,
                        color: Palette.appBarTitleColor),
                  ),
                ),
              ),
            ),
            leading: SizedBox(
              width: 8,
              height: 14,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<BookNotifire>(context,listen: false).resetDatas();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Palette.appBarTitleColor,
                ),
              ),
            ),
            expandedHeight: 73,
            backgroundColor: Palette.textLineOrBackGroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: MenuShow(),
              ),
            ],
          ),
          // SliverAppBar(
          //   title: Text(
          //     '${characterByindex.toUpperCase()}',
          //     style: TextStyle(
          //         fontSize: 20,
          //         letterSpacing: 1,
          //         fontFamily: 'GHEAGrapalat',
          //         fontWeight: FontWeight.bold,
          //         color: Palette.appBarTitleColor),
          //   ),
          //   leading: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: Icon(
          //       Icons.arrow_back_ios_new_outlined,
          //       color: Palette.appBarTitleColor,
          //     ),
          //   ),
          //   expandedHeight: 73,
          //   backgroundColor: Palette.textLineOrBackGroundColor,
          //   elevation: 0,
          //   automaticallyImplyLeading: false,
          //   systemOverlayStyle: SystemUiOverlayStyle(
          //       statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
          //   actions: [
          //     MenuShow(),
          //   ],
          // ),
          SliverFillRemaining(
            child: DelegateChild(
              characterByindex: characterByindex,
              characterIndex: characterIndex,
              characters: characters,
            ),
          )
        ]),
      ),
    );
  }
}

class DelegateChild extends StatefulWidget {
  DelegateChild({
    Key? key,
    required this.characterByindex,
    required this.characters,
    required this.characterIndex,
  }) : super(key: key);

  final String characterByindex;
  final int characterIndex;
  final Object characters;

  @override
  State<DelegateChild> createState() => _DelegateChildState(
        characterByindex: characterByindex,
        characters: characters,
        characterIndex: characterIndex,
      );
}

class _DelegateChildState extends State<DelegateChild>
    with SingleTickerProviderStateMixin {
  _DelegateChildState({
    required this.characterByindex,
    required this.characters,
    required this.characterIndex,
  });

  final bookDataProvider = BookDataProvider();
  final String characterByindex;
  final int characterIndex;
  Object characters;
  var initalIndex;
  Future<List<Data>?>? dialectByCharacters;
  var chars;
  late TabController _tabController;

  @override
  void initState() {
      chars =  characters as List<String>;
    _tabController = TabController(
        length: chars.length,
        vsync: this,
        initialIndex: indeChars(),
        animationDuration: Duration.zero);
    dialectByCharacters = bookDataProvider
        .getDataByCharacters(Api.dialectBYCharacters(characterByindex));
    if (diId != null)
      bookDataProvider
          .getDialect_Encyclopaedia_Characters(Api.dialectCharacters)
          .then((value) {
        for (var nv in value) {
          bookDataProvider
              .getDataByCharacters(Api.dialectBYCharacters(nv))
              .then((value) {
            for (var nValue in value) {
              if ("(${nValue.id})".toString().contains(diId!)) {
                characters = nValue;
                break;
              }
            }
          });
        }
      });
    super.initState();
  }
  int indeChars(){
    var chars= characters as List<String>;
    int index = 0;
    for(var i=0;i<chars.length;i++){
      if(chars[i].toLowerCase().contains(characterByindex.toLowerCase())){
        index = i;
        break;
      }
    }
  return index;
  }
  Future<List<Data>>? getData(String char) {
    Future.delayed(Duration(milliseconds: 1200));
    return bookDataProvider.getDataByCharacters(
        Api.dialectBYCharacters(
            char.toLowerCase()));
  }
  Widget buildData() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: FutureBuilder<List<Data>?>(

          future: dialectByCharacters,
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  child: Center(
                      child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Palette.main,
              )));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const SizedBox();
              } else if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: data?.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => DialectDataShow(
                        //               dataCharacter: data?[index],
                        //             )));
                        OpenUrl.launchInBrowser(
                            Uri.parse(data![index].sharurl.toString()));
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 20.0, left: 22.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Text(
                                      '0${index + 1}',
                                      style: TextStyle(
                                        color: Palette.main,
                                        fontFamily: 'GHEAGrapalat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: 260,
                                      child: Text(
                                        '${data?[index].title}',
                                        style: TextStyle(
                                            fontFamily: 'GHEAGrapalat',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(
                                                113, 141, 156, 1)),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Color.fromRGBO(226, 224, 224, 1),
                            )
                          ],
                        ),
                      ),
                    );
                    // return ExpansionTile(
                    //   title: Text('${data?[index].title}'),
                    //   controlAffinity: ListTileControlAffinity.leading,
                    //   leading: SvgPicture.asset('assets/images/line24.svg'),
                    //   children: [
                    //     ListTile(
                    //       title: Text('${data?[index].body}'),
                    //     )
                    //   ],
                    // );
                  },
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var chars= characters as List<String>;

    return DefaultTabController(
      initialIndex: indeChars(),
      length: chars.length,
      child: Scaffold(
        backgroundColor: Palette.textLineOrBackGroundColor,
        appBar: PreferredSize(
          preferredSize: Size(18.0, 50.0),
          child: Container(
            color: Color.fromRGBO(246, 246, 246, 1),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TabBar(
                  indicatorWeight: 2,
                  unselectedLabelColor: const Color.fromRGBO(122, 108, 115, 1),
                  labelColor: const Color.fromRGBO(251, 196, 102, 1),
                  indicatorColor: Colors.amber,
                  indicator: MaterialIndicator(
                    color: Colors.amber,
                    height: 2,
                    topLeftRadius: 0,
                    topRightRadius: 0,
                    bottomLeftRadius: 5,
                    bottomRightRadius: 5,
                    tabPosition: TabPosition.top,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  controller: _tabController,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                  onTap: (index) {
                    context
                        .read<BookNotifire>()
                        .charactersSetDialect(chars.elementAt(index));
                      setState(() {
                        dialectByCharacters = getData(chars[index]);
                      });

                  },
                  tabs: chars.map((tabName) {
                    return Tab(
                      child: Text(
                        tabName,
                        style: TextStyle(
                          fontFamily: 'ArshaluyseArtU',
                          fontSize: 23,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),
        ),
        body: buildData()

        //     ))
      ),
    );
    // return DefaultTabController(
    //   initialIndex: characterIndex,
    //   length: wordsArm.length,
    //   child: Scaffold(
    //     appBar: TabBar(
    //         indicatorWeight: 2,
    //         unselectedLabelColor: const Color.fromRGBO(122, 108, 115, 1),
    //         labelColor: const Color.fromRGBO(251, 196, 102, 1),
    //         indicatorColor: Colors.amber,
    //         indicator: MaterialIndicator(
    //           color: Colors.amber,
    //           height: 2,
    //           topLeftRadius: 0,
    //           topRightRadius: 0,
    //           bottomLeftRadius: 5,
    //           bottomRightRadius: 5,
    //           tabPosition: TabPosition.top,
    //           paintingStyle: PaintingStyle.fill,
    //         ),
    //         controller: _tabController,
    //         isScrollable: true,
    //         labelPadding: const EdgeInsets.symmetric(horizontal: 15),
    //         onTap: (index) {
    //           setState(() {
    //             characters
    //                     .toString()
    //                     .toLowerCase()
    //                     .contains(wordsArm.elementAt(index))
    //                 ? dialectByCharacters =
    //                     bookDataProvider.getDataByCharacters(
    //                         Api.dialectBYCharacters(wordsArm.elementAt(index)))
    //                 : null;
    //           });
    //         },
    //         tabs: wordsArm.map((tabName) {
    //           return Tab(
    //             child: Text(
    //               tabName,
    //               style: TextStyle(
    //                 fontFamily: 'ArshaluyseArtU',
    //                 fontSize: 23,
    //                 fontStyle: FontStyle.normal,
    //                 fontWeight: FontWeight.bold,
    //                 color: characters
    //                         .toString()
    //                         .toLowerCase()
    //                         .contains(tabName.toLowerCase())
    //                     ? null
    //                     : Color.fromRGBO(186, 166, 177, 1),
    //               ),
    //             ),
    //           );
    //         }).toList()),
    //     body: TabBarView(
    //         controller: _tabController,
    //         children: wordsArm
    //             .map(
    //               (e) => characters
    //                       .toString()
    //                       .toLowerCase()
    //                       .contains(e.toLowerCase())
    //                   ? buildData()
    //                   : Container(
    //                       child: Center(
    //                         child: Text('Empty data'),
    //                       ),
    //                     ),
    //             )
    //             .toList()),

    //     //     ))
    //   ),
    // );
  }


}

List<String> wordsArm = [
  'ա',
  "բ",
  "գ",
  "դ",
  "ե",
  "զ",
  "է",
  "ը",
  "թ",
  "ժ",
  "ի",
  "լ",
  "խ",
  "ծ",
  "կ",
  "հ",
  "ձ",
  "ղ",
  "ճ",
  "մ",
  "յ",
  "ն",
  "շ",
  "ո",
  "չ",
  "պ",
  "ջ",
  "ռ",
  "ս",
  "վ",
  "տ",
  "ր",
  "ց",
  "ու",
  "փ",
  "ք",
  "ԵՎ",
  "Օ",
  "Ֆ"
];

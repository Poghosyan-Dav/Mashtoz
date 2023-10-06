import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/globals.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '/config/palette.dart';
import '../../../../../domens/models/book_data/data.dart';
import '../../../../../domens/repository/user_data_provider.dart';
import '../../../../../tab_provider.dart';
import '../../../helper_widgets/menuShow.dart';
import '../../../helper_widgets/save_show_dialog.dart';

class DictionaryArmItl extends StatefulWidget {
  const DictionaryArmItl({
    Key? key,
    required this.characters,
    required this.characterByindex,
    required this.characterIndex,
    required this.isShow,
  }) : super(key: key);

  final String characterByindex;
  final int characterIndex;
  final List<Object> characters;
  final bool isShow;

  @override
  _DictionaryArmItlState createState() => _DictionaryArmItlState(
      characters: characters,
      characterByindex: characterByindex,
      characterIndex: characterIndex,
      isShow: isShow);
}

class _DictionaryArmItlState extends State<DictionaryArmItl>
    with SingleTickerProviderStateMixin {
  _DictionaryArmItlState(
      {required this.characters,
      required this.characterByindex,
      required this.characterIndex,
      required this.isShow});

  final bookDataProvider = BookDataProvider();
  final String characterByindex;
  final int characterIndex;
  final List<Object> characters;
  Future<List<Data>?>? charctersData;
  final bool isShow;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    isShow ? 'Հայերեն-իտալերեն' : 'Իտալերեն- Հայերեն',
                    style: TextStyle(
                        fontSize: 14,
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
          SliverFillRemaining(
            child: DelegateChild(
              characterByindex: characterByindex,
              characterIndex: characterIndex,
              characters: characters,
              isShow: isShow,
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
    required this.isShow,
  }) : super(key: key);

  final String characterByindex;
  final int characterIndex;
  final Object characters;
  final bool isShow;

  @override
  State<DelegateChild> createState() => _DelegateChildState(
      characterByindex: characterByindex,
      characters: characters,
      characterIndex: characterIndex,
      isShow: isShow);
}

class _DelegateChildState extends State<DelegateChild>
    with SingleTickerProviderStateMixin {
  _DelegateChildState({
    required this.characterByindex,
    required this.characters,
    required this.characterIndex,
    required this.isShow,
  });

  final bookDataProvider = BookDataProvider();
  final String characterByindex;
  final int characterIndex;
  Object characters;
  final userDataProvider = UserDataProvider();
  int? custemerId;
  bool isShowingDialog = false;

  Future<List<Data>?>? charctersDataArmenian;
  Future<List<Data>?>? charctersDataItalian;
  final bool isShow;

  late TabController _tabController;

  @override
  void initState() {
    var chars = characters as List<String>;

    _tabController = TabController(
        length: isShow ? chars.length : chars.length,
        vsync: this,
        initialIndex: indeChars(),
        animationDuration: Duration.zero);
    isShow
        ? charctersDataArmenian = bookDataProvider.getDataByCharacters(
            Api.armenianDictionaryByCharacters(characterByindex))
        : charctersDataItalian = bookDataProvider.getDataByCharacters(
            Api.italianDictionaryByCharacters(characterByindex));

    super.initState();
  }

  int indeChars() {
    var chars = characters as List<String>;
    int index = 0;
    for (var i = 0; i < chars.length; i++) {
      if (chars[i].toLowerCase().contains(characterByindex.toLowerCase())) {
        index = i;
        break;
      }
    }
    return index;
  }

  Widget buildData() {
    print('dadas');
    return FutureBuilder<List<Data>?>(
      future: isShow ? charctersDataArmenian : charctersDataItalian,
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
            return const Text('Error');
          } else if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    '${data?[index].title}',
                    style: TextStyle(
                      fontFamily: 'GHEAGrapalat',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  leading: SvgPicture.asset('assets/images/line24.svg'),
                  initiallyExpanded: false,
                  children: [
                    Container(
                      color: Color.fromRGBO(246, 246, 246, 1),
                      child: ListTile(
                        title: Html(
                            shrinkWrap: true,
                            onLinkTap: (url, _, __) async {
                              await bookDataProvider
                                  .getDialect_Encyclopaedia_Characters(
                                      Api.italianDictionaryCharacters)
                                  .then((value) {
                                if (url != null) {
                                  Uri myUrl = Uri.parse("$url");
                                  String characterB = myUrl.pathSegments[1];
                                  print(characterB); // Output: B
                                  print("Opening $characterB...");
                                  if (url.contains('http') ||
                                      url.contains('https')) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DictionaryArmItl(
                                                characters:
                                                    value as List<Object>,
                                                characterByindex: characterB,
                                                characterIndex: characterIndex,
                                                isShow: false)));
                                    // await launch(
                                    //   url,
                                    // );
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                }
                              });
                            },
                            data: '''${data?[index].body} '''),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      width: double.infinity,
                      height: 49,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              await Share.share(data![index].sharurl!);
                              // showDialog(
                              //     context: context,
                              //     barrierDismissible: true,
                              //     builder: (
                              //       context,
                              //     ) =>
                              //         SaveShowDialog(
                              //           isShow: false,
                              //         ));
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/այքըններ.svg'),
                                const SizedBox(width: 6),
                                const Text('Կիսվել ')
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              userIsSign(
                                context,
                                data?[index].id,
                              );

                              //    showDialog(
                              // context: context,
                              // barrierDismissible: false,
                              // builder: (
                              //   context,
                              // ) =>
                              //     SaveShowDialog(isShow: true));
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/վելացնել1.svg'),
                                const SizedBox(width: 6),
                                const Text('Պահել'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("dadas");
    var chars = characters as List<String>;
    //List<String> sortChars= chars.sort();
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
                      padding: const EdgeInsets.only(left: 7.0),
                      child: TabBar(
                        indicatorWeight: 2,
                        unselectedLabelColor:
                            const Color.fromRGBO(122, 108, 115, 1),
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
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        onTap: (index) {
                          print(wordsIt.elementAt(index).toLowerCase());
                          setState(() {
                            isShow
                                ? charctersDataArmenian =
                                    getData(chars[index], isShow)
                                : charctersDataItalian =
                                    getData(chars[index], isShow);
                          });
                        },
                        tabs: isShow
                            ? chars.map((tabName) {
                                return Tab(
                                  child: Text(
                                    tabName,
                                    style: TextStyle(
                                      fontFamily: 'ArshaluyseArtU',
                                      fontSize: 23,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                      color: chars
                                              .toString()
                                              .toLowerCase()
                                              .contains(tabName.toLowerCase())
                                          ? null
                                          : Color.fromRGBO(186, 166, 177, 1),
                                    ),
                                  ),
                                );
                              }).toList()
                            : chars.map((tabName) {
                                return Tab(
                                  child: Text(
                                    tabName,
                                    style: TextStyle(
                                      fontFamily: 'ArshaluyseArtU',
                                      fontSize: 30,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                      color: chars
                                              .toString()
                                              .toLowerCase()
                                              .contains(tabName.toLowerCase())
                                          ? null
                                          : Color.fromRGBO(186, 166, 177, 1),
                                    ),
                                  ),
                                );
                              }).toList(),
                      ),
                    ))),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: isShow
                    ? chars
                        .map(
                          (e) => chars
                                  .toString()
                                  .toLowerCase()
                                  .contains(e.toLowerCase())
                              ? buildData()
                              : Container(
                                  child: Center(
                                    child: Text('Empty data'),
                                  ),
                                ),
                        )
                        .toList()
                    : chars
                        .map(
                          (e) => chars
                                  .toString()
                                  .toLowerCase()
                                  .contains(e.toLowerCase())
                              ? buildData()
                              : Container(
                                  child: Center(
                                    child: Text('Empty data'),
                                  ),
                                ),
                        )
                        .toList())));
  }

  void userIsSign(BuildContext context, int? typeId) async {
    final tabProvider = Provider.of<TabProvider>(context, listen: false);

    var data = <String, dynamic>{};
    await userDataProvider.fetchUserInfo().then((value) {
      data = <String, dynamic>{
        'type': isShow ? 'armenians' : 'italians',
        'type_id': typeId,
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

  Future<List<Data>?>? getData(String char, bool isShow) {
    Future.delayed(Duration(milliseconds: 1200));
    return bookDataProvider.getDataByCharacters(isShow
        ? Api.armenianDictionaryByCharacters(char.toLowerCase())
        : Api.italianDictionaryByCharacters(char.toLowerCase()));
  }
}

List<String> wordsIt = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  '',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/globals.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/dictionary_screen/aarm_italy_dictionary.dart';

import '../../../helper_widgets/menuShow.dart';

class Dictionary extends StatefulWidget {
  const Dictionary({Key? key}) : super(key: key);

  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // SliverAppBar(
            //   title: ActionsHelper(
            //     //botomPadding: 55,
            //     text: ,
            //     fontFamily: 'GHEAGrapalat',
            //     rightPadding: 10.0,
            //     fontSize: 20,
            //     laterSpacing: 1,
            //     fontWeight: FontWeight.bold,
            //     color: Palette.appBarTitleColor,
            //   ),
            //   expandedHeight: 73,
            //   backgroundColor: Palette.textLineOrBackGroundColor,
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   systemOverlayStyle: SystemUiOverlayStyle(
            //       statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
            // ),
            //  SliverAppBar(
            //   title: Text(
            //    'Բառարան',
            //     style: TextStyle(
            //         fontSize: 20,
            //         letterSpacing: 1,
            //         fontFamily: 'GHEAGrapalat',
            //         fontWeight: FontWeight.bold,
            //         color: Palette.appBarTitleColor),
            //   ),

            //   expandedHeight: 73,
            //   backgroundColor: Color.fromRGBO(226, 224, 224, 1),
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   systemOverlayStyle: SystemUiOverlayStyle(
            //       statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
            //   actions: [
            //     MenuShow(),
            //   ],
            // ),
            SliverAppBar(
              leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_ios_new_outlined),color: Palette.appBarTitleColor,),
              title: const Text(
                'Բառարան',
                style: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 1,
                    fontFamily: 'GHEAGrapalat',
                    fontWeight: FontWeight.w700,
                    color: Palette.appBarTitleColor),
              ),
              expandedHeight: 73,
              backgroundColor: Palette.textLineOrBackGroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
              actions: [
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: MenuShow(),
                ),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0.0,
                    toolbarHeight: 10,
                    backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
                    bottom: TabBar(
                      indicatorWeight: 2,
                      unselectedLabelColor:
                          const Color.fromRGBO(122, 108, 115, 1),
                      labelColor: const Color.fromRGBO(251, 196, 102, 1),
                      indicatorColor: Colors.amber,
                      controller: _controller,
                      tabs: const <Widget>[
                        Tab(
                          height: 55,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Հայերեն-\nԻտալերեն',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                  letterSpacing: 1.0,
                                  fontFamily: 'GHEAGrapalat'),
                            ),
                          ),
                        ),
                        Tab(
                          height: 55,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Իտալերեն-\nՀայերեն',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                  letterSpacing: 1.0,
                                  fontFamily: 'GHEAGrapalat'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    children: const <Widget>[
                      _ArmenianItalian(),
                      _ItalianArmenian(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Armenian alphabet Widget
class _ArmenianItalian extends StatefulWidget {
  const _ArmenianItalian({Key? key}) : super(key: key);

  @override
  State<_ArmenianItalian> createState() => _ArmenianItalianState();
}

class _ArmenianItalianState extends State<_ArmenianItalian> {
  Future<List<String>?>? charctersData;
  final bookDataProvider = BookDataProvider();
  @override
  void initState() {
    charctersData = bookDataProvider
        .getDialect_Encyclopaedia_Characters(Api.armenianDictionaryCharacters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<String>?>(
        future: charctersData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var characters = snapshot.data as List<String>;
            return Scaffold(
              body: GridView.count(
                mainAxisSpacing: 30,
                crossAxisCount: 7,
                physics: const AlwaysScrollableScrollPhysics(),
                children: List.generate(wordsArm.length, (index) {
                  return Center(
                    child: InkWell(
                      onTap: characters
                              .toString()
                              .toLowerCase()
                              .contains(wordsArm[index])
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DictionaryArmItl(
                                            characters: characters,
                                            characterByindex: wordsArm[index],
                                            characterIndex: index,
                                            isShow: true,
                                          )));
                            }
                          : null,
                      child:Card(
                        semanticContainer: false,
                        child: Container(
                          width: 50,
                          child: Center(
                            child: Text(
                              '${wordsArm[index].toUpperCase()}',
                              style: TextStyle(
                                fontFamily: 'ArshaluyseArtU',
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                color: characters
                                    .toString()
                                    .toLowerCase()
                                    .contains(Api.armAlphapet[index])
                                    ? null
                                    : const Color.fromRGBO(186, 166, 177, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          } else {
            return Container(
              child: const Center(
                  child: CircularProgressIndicator(
                color: Palette.main,
              )),
            );
          }
        },
      ),
    );
  }
}

//Italian alphabet Widget
class _ItalianArmenian extends StatefulWidget {
  const _ItalianArmenian({Key? key}) : super(key: key);

  @override
  State<_ItalianArmenian> createState() => _ItalianArmenianState();
}

class _ItalianArmenianState extends State<_ItalianArmenian> {
  Future<List<String>?>? charctersData;
  final bookDataProvider = BookDataProvider();
  @override
  void initState() {
    charctersData = bookDataProvider
        .getDialect_Encyclopaedia_Characters(Api.italianDictionaryCharacters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<String>?>(
        future: charctersData,
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            var characters = snapshot.data as List<String>;
            return Scaffold(
              body: GridView.count(
                mainAxisSpacing: 30,
                crossAxisCount: 7,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(wordsIt.length, (index) {
                  return Center(
                    child: InkWell(
                      onTap: characters
                              .toString()
                              .toLowerCase()
                              .contains(wordsIt[index])
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DictionaryArmItl(
                                            characters: characters,
                                            characterByindex: wordsIt[index],
                                            characterIndex: index,
                                            isShow: false,
                                          )));
                            }
                          : null,
                      child: Card(
                        semanticContainer: false,
                        child: SizedBox(
                          width: 60,
                          child: Center(
                            child: Text(
                              wordsIt[index].toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'ArshaluyseArtU',
                                fontSize: 25,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                color: characters
                                    .toString()
                                    .toLowerCase()
                                    .contains(wordsIt[index])
                                    ? null
                                    : const Color.fromRGBO(186, 166, 177, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Palette.main,
            ));
          }
        },
      ),
    );
  }
}

//Armenian alphabet
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
  "եւ",
  "Օ",
  "Ֆ"
];
//English alphabet
List<String> wordsIt = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  ''
      'v',
  'w',
  'x',
  'y',
  'z',
];

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashtoz_flutter/config/palette.dart';

import '../../../../../domens/models/book_data/data.dart';
import '../../../helper_widgets/menuShow.dart';

class DialectDataShow extends StatefulWidget {
  final Data? dataCharacter;
  const DialectDataShow({Key? key, this.dataCharacter}) : super(key: key);

  @override
  State<DialectDataShow> createState() =>
      _DialectDataShowState(dataCharacter: dataCharacter);
}

class _DialectDataShowState extends State<DialectDataShow> {
  var textData =
      '135, 112. 2. 3. 4. 5. 6. 7. 8. 9. 10. 11. 12. 13. 14. 15. 16. 17. 18. 19. 20. 21. 22. 23. 24. 25. 26';

  final Data? dataCharacter;
  _DialectDataShowState({this.dataCharacter});
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
          // SliverAppBar(
          //   title: Text(
          //     '${dataCharacter?.title}',
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
            flexibleSpace: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0, top: 18.0),
                child: Text(
                  '${dataCharacter?.firstCharacter}',
                  style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      fontFamily: 'GHEAGrapalat',
                      fontWeight: FontWeight.w700,
                      color: Palette.appBarTitleColor),
                ),
              ),
            ),
            pinned: false,
            floating: false,
            snap: false,
            leading: SizedBox(
              width: 8,
              height: 14.0,
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
          //!Համաբարբառ
          SliverToBoxAdapter(
            child: ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: ((context, index) => SizedBox(height: 30.0)),
              itemCount: 1,
              itemBuilder: (context, index) {
                return Expanded(
                  // width: 300,
                  // height: 300,
                  //fit: BoxFit.fitHeight,
                  child: Container(
                    color: index % 2 != 0
                        ? Color.fromRGBO(202, 217, 228, 1)
                        : Color.fromRGBO(197, 202, 212, 1),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          // constraints: BoxConstraints.expand(),
                          color: index % 2 != 0
                              ? Color.fromRGBO(172, 197, 215, 1)
                              : Color.fromRGBO(164, 171, 189, 1),
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [Text('Երեմիա')],
                          ),
                        ),
                        ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(12.0),
                                child: IntrinsicHeight(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 50,
                                      child: Wrap(children: [
                                        Text(
                                          textData,
                                          textAlign: TextAlign.start,
                                          softWrap: true,
                                        ),
                                      ]),
                                    ),
                                    VerticalDivider(
                                      color: Colors.black,
                                      thickness: 1,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                            color: Colors.red,
                                            child: Text(
                                              '${dataCharacter?.body}',
                                              textAlign: TextAlign.start,
                                            )),
                                      ),
                                    ),
                                  ],
                                )),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 20.0),
                            itemCount: 1),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

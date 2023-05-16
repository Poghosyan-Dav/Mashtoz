import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../../../config/palette.dart';
import '../../../../../domens/models/app_theme.dart/theme_notifire.dart';

class BookSetings extends StatefulWidget {
  final Function()? sizeChange;
  final Function()? sizeChangeSmall;
  const BookSetings({Key? key,this.sizeChange,this.sizeChangeSmall}) : super(key: key);

  @override
  State<BookSetings> createState() => _BookSetingsState();
}

class _BookSetingsState extends State<BookSetings> {
  bool isPhoneturnHorizontal = false;
  bool isPhoneturnVertical = false;
  bool isLisghtTheme = false;
  bool isDarkTheme = false;
  double selectedValue = 0;
  double textSize = 18.0;

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }
  @override
  Widget build(BuildContext context) {

      final mediaQuery = MediaQuery.of(context).size;
      final theme = context.read<ThemeNotifier>();
      final orentation = MediaQuery.of(context).orientation;
      return Container(
        color: theme.backgroundColor != null
            ? theme.backgroundColor
            : Palette.textLineOrBackGroundColor,
        // width: mediaQuery.width,
        // height: mediaQuery.height,
        child: orentation == Orientation.landscape? landSpace() :  Container(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
            const SizedBox(height: 10,),
            Expanded(
              child: Container(
                width: mediaQuery.width,
                height: mediaQuery.height,
                child: Column(children: [
                  Flex(

                    direction: Axis.vertical, // or Axis.horizontal, depending on your layout
                    children:[
                      const Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Text(
                        'Կարգավորումներ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),]
                  ),
                  const SizedBox(height: 10.0),
                  Flex(
                    direction: Axis.vertical, // or Axis.horizontal, depending on your layout

                    children:const [
                       Padding(
                        padding: EdgeInsets.only(right: 20.0, left: 20.0),
                        child: Divider(
                          color: Color.fromRGBO(226, 224, 224, 1),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                        height: MediaQuery.of(context).size.height - 250,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, //  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     Flex(
                                       direction: Axis.vertical, // or Axis.horizontal, depending on your layout
                                       children:const [
                                         Padding(
                                          padding:
                                          EdgeInsets.only(left: 20.0),
                                          child: Expanded(
                                            child: Text(
                                              'Պայծառություն',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1,
                                                color: Color.fromRGBO(
                                                    122, 108, 115, 1),
                                              ),
                                            ),
                                          ),
                                    ),
                                       ],
                                     ),
                                    Expanded(
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: 70,
                                        child: SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                              activeTrackColor:
                                              Palette.main,
                                              inactiveTrackColor:
                                              const Color.fromRGBO(
                                                  226, 224, 224, 1),
                                              trackShape:
                                              const RoundedRectSliderTrackShape(),
                                              trackHeight: 4.0,
                                              thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius:
                                                  12.0),
                                              thumbColor: Palette.main,
                                              overlayColor:
                                              Palette.whenTapedButton,
                                              overlayShape:
                                              const RoundSliderOverlayShape(
                                                  overlayRadius: 18.0),
                                              tickMarkShape:
                                              const RoundSliderTickMarkShape(),
                                              activeTickMarkColor:
                                              Palette.main,
                                              inactiveTickMarkColor:
                                              const Color.fromRGBO(
                                                  226, 224, 224, 1),
                                              valueIndicatorShape:
                                              const PaddleSliderValueIndicatorShape(),
                                              valueIndicatorColor:
                                              Palette.main,
                                              valueIndicatorTextStyle:
                                              const TextStyle(
                                                  color: Palette.main),
                                            ),
                                            child: FutureBuilder(
                                                future: ScreenBrightness()
                                                    .current,
                                                builder:
                                                    (BuildContext context,
                                                    AsyncSnapshot
                                                    snapshot) {
                                                  double currentBrightness =
                                                  0;
                                                  if (snapshot.hasData) {
                                                    currentBrightness =
                                                    snapshot.data!;
                                                  }
                                                  return StreamBuilder<
                                                      double>(
                                                    stream: ScreenBrightness()
                                                        .onCurrentBrightnessChanged,
                                                    builder: (context,
                                                        snapshot) {
                                                      double
                                                      changedBrightness =
                                                          currentBrightness;
                                                      if (snapshot
                                                          .hasData) {
                                                        changedBrightness =
                                                        snapshot.data!;
                                                      }

                                                      return Slider
                                                          .adaptive(
                                                        value:
                                                        changedBrightness,
                                                        onChanged: (value) {
                                                          setBrightness(
                                                              value);
                                                        },
                                                      );
                                                    },
                                                  );
                                                })),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flex(
                                direction: Axis.vertical, // or Axis.horizontal, depending on your layout

                                children:const [
                                   Padding(
                                    padding: EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: Divider(
                                      color: Color.fromRGBO(226, 224, 224, 1),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flex(
                                      direction: Axis.vertical, // or Axis.horizontal, depending on your layout

                                      children: const[
                                         Padding(
                                          padding:
                                          EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            'Տառաչափ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1,
                                              color: Color.fromRGBO(
                                                  122, 108, 115, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: orentation ==
                                          Orientation.landscape
                                          ? 10.0
                                          : 20.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 50.0,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: widget.sizeChangeSmall,
                                              icon: SvgPicture.asset(
                                                'assets/images/VectorLine.svg',
                                              ),
                                            ),
                                            Text(
                                              'Աա',
                                              style: TextStyle(
                                                  fontSize: textSize),
                                            ),
                                            IconButton(
                                              onPressed:
                                              widget.sizeChange
                                              ,
                                              icon: SvgPicture.asset(
                                                  'assets/images/plusik.svg'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flex(
                                direction: Axis.vertical, // or Axis.horizontal, depending on your layout

                                children: const[
                                   Padding(
                                    padding: EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: Divider(
                                      color: Color.fromRGBO(226, 224, 224, 1),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flex(
                                      direction: Axis.vertical, // or Axis.horizontal, depending on your layout
                                      children:const [
                                         Padding(
                                          padding:
                                          EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            'Ռեժիմ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1,
                                              color: Color.fromRGBO(
                                                  122, 108, 115, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: orentation ==
                                          Orientation.landscape
                                          ? 0.1
                                          : 10.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 85.0,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isLisghtTheme =
                                                    !isLisghtTheme;
                                                    isDarkTheme = false;
                                                    context
                                                        .read<
                                                        ThemeNotifier>()
                                                        .lightThemeData();
                                                  });
                                                },
                                                child: Container(
                                                    width: 60,
                                                    height: 70,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: orentation ==
                                                                Orientation
                                                                    .landscape
                                                                ? 27.0
                                                                : 37.0,
                                                            width: orentation ==
                                                                Orientation
                                                                    .landscape
                                                                ? 27.0
                                                                : 37.0,
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  height:
                                                                  37,
                                                                  width: 37,
                                                                  color: !isLisghtTheme
                                                                      ? const Color.fromRGBO(
                                                                      226,
                                                                      224,
                                                                      224,
                                                                      1)
                                                                      : Palette
                                                                      .whenTapedButton,
                                                                  child: Container(
                                                                      height:
                                                                      37,
                                                                      width:
                                                                      37,
                                                                      color: const Color.fromRGBO(
                                                                          226,
                                                                          224,
                                                                          224,
                                                                          1)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: orentation ==
                                                              Orientation
                                                                  .landscape
                                                              ? 0.1
                                                              : 10.0,
                                                        ),
                                                        Text(
                                                          'Ցերեկ',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            letterSpacing:
                                                            1,
                                                            color: !isLisghtTheme
                                                                ? const Color
                                                                .fromRGBO(
                                                                186,
                                                                166,
                                                                177,
                                                                1)
                                                                : Palette
                                                                .whenTapedButton,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isDarkTheme =
                                                    !isDarkTheme;
                                                    isLisghtTheme = false;
                                                    context
                                                        .read<
                                                        ThemeNotifier>()
                                                        .darkThemeData();
                                                  });
                                                },
                                                child: Container(
                                                    width: 60,
                                                    height: 70,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: orentation ==
                                                                Orientation
                                                                    .landscape
                                                                ? 27.0
                                                                : 37.0,
                                                            width: orentation ==
                                                                Orientation
                                                                    .landscape
                                                                ? 27.0
                                                                : 37.0,
                                                            child:
                                                            Container(
                                                              color: Colors
                                                                  .black,
                                                              width: 37,
                                                              height: 37,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: orentation ==
                                                              Orientation
                                                                  .landscape
                                                              ? 0.0
                                                              : 10.0,
                                                        ),
                                                        Text(
                                                          'Գիշեր',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            letterSpacing:
                                                            1,
                                                            color: !isDarkTheme
                                                                ? const Color
                                                                .fromRGBO(
                                                                186,
                                                                166,
                                                                177,
                                                                1)
                                                                : Palette
                                                                .whenTapedButton,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flex(
                                direction: Axis.vertical, // or Axis.horizontal, depending on your layout

                                children:const [
                                   Padding(
                                    padding: EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: Divider(
                                      color: Color.fromRGBO(226, 224, 224, 1),
                                      thickness: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     Flex(
                                       direction: Axis.vertical, // or Axis.horizontal, depending on your layout

                                       children: const[
                                         Padding(
                                          padding:
                                          EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            'Էկրան',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1,
                                              color: Color.fromRGBO(
                                                  122, 108, 115, 1),
                                            ),
                                          ),
                                    ),
                                       ],
                                     ),
                                    SizedBox(
                                      height: orentation ==
                                          Orientation.landscape
                                          ? 0.1
                                          : 10.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 85.0,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isPhoneturnHorizontal =
                                                    !isPhoneturnHorizontal;
                                                    isPhoneturnVertical =
                                                    false;
                                                  });
                                                  SystemChrome
                                                      .setPreferredOrientations([
                                                    DeviceOrientation
                                                        .landscapeRight,
                                                    DeviceOrientation
                                                        .landscapeLeft,
                                                  ]);
                                                },
                                                child: Container(
                                                    width: 50,
                                                    height: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/images/phone1.svg',
                                                          color: !isPhoneturnHorizontal
                                                              ? null
                                                              : Palette
                                                              .whenTapedButton,
                                                        ),
                                                        SizedBox(
                                                          height: orentation ==
                                                              Orientation
                                                                  .landscape
                                                              ? 0.1
                                                              : 15.0,
                                                        ),
                                                        const Text(
                                                          'Հորիզոնական',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                  186,
                                                                  166,
                                                                  177,
                                                                  1),
                                                              fontFamily:
                                                              'GHEAGrapalat',
                                                              fontSize:
                                                              12.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  //print('dark theme');
                                                  setState(() {
                                                    isPhoneturnVertical =
                                                    !isPhoneturnVertical;
                                                    isPhoneturnHorizontal =
                                                    false;
                                                    SystemChrome
                                                        .setPreferredOrientations([
                                                      DeviceOrientation
                                                          .portraitUp,
                                                      DeviceOrientation
                                                          .portraitDown,
                                                    ]);
                                                  });
                                                },
                                                child: Container(
                                                    width: 50,
                                                    height: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/images/phone2.svg',
                                                            height: orentation ==
                                                                Orientation
                                                                    .landscape
                                                                ? 19
                                                                : null,
                                                            color: !isPhoneturnVertical
                                                                ? null
                                                                : Palette
                                                                .whenTapedButton),
                                                        SizedBox(
                                                          height: orentation ==
                                                              Orientation
                                                                  .landscape
                                                              ? 0.1
                                                              : 7.0,
                                                        ),
                                                        const Text(
                                                          'Ուղղահայաց',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                  186,
                                                                  166,
                                                                  177,
                                                                  1),
                                                              fontFamily:
                                                              'GHEAGrapalat',
                                                              fontSize:
                                                              12.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //!!!!
                            ])),
                  )
                ]),
              ),
            ),
          ]),
        ),
      );

}
Widget landSpace (){
  final mediaQuery = MediaQuery.of(context).size;
  final theme = context.read<ThemeNotifier>();
  final orentation = MediaQuery.of(context).orientation;
return Container(
  height: mediaQuery.height,
  child: SingleChildScrollView(
  child:   Column(
    children: [
  const Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0),
            child: Text(
              'Կարգավորումներ',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
      const SizedBox(height: 10.0),
      const Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Divider(
                  color: Color.fromRGBO(226, 224, 224, 1),
                  thickness: 1,
                ),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                              Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                        .start, //  mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding:
                                        EdgeInsets.only(left: 20.0),
                                        child: Expanded(
                                          child: Text(
                                            'Պայծառություն',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1,
                                              color: Color.fromRGBO(
                                                  122, 108, 115, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: 70,
                                        child: SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                              activeTrackColor:
                                              Palette.main,
                                              inactiveTrackColor:
                                              const Color.fromRGBO(
                                                  226, 224, 224, 1),
                                              trackShape:
                                              const RoundedRectSliderTrackShape(),
                                              trackHeight: 4.0,
                                              thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius:
                                                  12.0),
                                              thumbColor: Palette.main,
                                              overlayColor: Palette.disable,
                                              overlayShape:
                                              const RoundSliderOverlayShape(
                                                  overlayRadius: 18.0),
                                              tickMarkShape:
                                              const RoundSliderTickMarkShape(),
                                              activeTickMarkColor:
                                              Palette.main,
                                              inactiveTickMarkColor:
                                              const Color.fromRGBO(
                                                  226, 224, 224, 1),
                                              valueIndicatorShape:
                                              const PaddleSliderValueIndicatorShape(),
                                              valueIndicatorColor:
                                              Palette.main,
                                              valueIndicatorTextStyle:
                                              const TextStyle(
                                                  color: Palette.main),
                                            ),
                                            child: FutureBuilder(
                                                future: ScreenBrightness()
                                                    .current,
                                                builder:
                                                    (BuildContext context,
                                                    AsyncSnapshot
                                                    snapshot) {
                                                  double currentBrightness =
                                                  0;
                                                  if (snapshot.hasData) {
                                                    currentBrightness =
                                                    snapshot.data!;
                                                  }
                                                  return StreamBuilder<
                                                      double>(
                                                    stream: ScreenBrightness()
                                                        .onCurrentBrightnessChanged,
                                                    builder: (context,
                                                        snapshot) {
                                                      double
                                                      changedBrightness =
                                                          currentBrightness;
                                                      if (snapshot
                                                          .hasData) {
                                                        changedBrightness =
                                                        snapshot.data!;
                                                      }

                                                      return Slider
                                                          .adaptive(
                                                        value:
                                                        changedBrightness,
                                                        onChanged: (value) {
                                                          setBrightness(
                                                              value);
                                                        },
                                                      );
                                                    },
                                                  );
                                                })),
                                      ),
                                    ],
                                  ),),
            Expanded(
              child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding:
                                EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Տառաչափ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                    color: Color.fromRGBO(
                                        122, 108, 115, 1),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height:
                                   10.0

                              ),
                              Container(
                                height: 50.0,width: mediaQuery.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //!!!!
                                        if (textSize >= 12.0) {
                                          setState(() {
                                            textSize =
                                                textSize - 2.0;
                                          });
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/VectorLine.svg',
                                      ),
                                    ),
                                    Text(
                                      'Աա',
                                      style: TextStyle(
                                          fontSize: textSize),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (textSize <= 20.0) {
                                          setState(() {
                                            textSize =
                                                textSize + 2.0;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            right: 22.0),
                                        child: SvgPicture.asset(
                                            'assets/images/plusik.svg'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),)
          ],),
      const Padding(
        padding: EdgeInsets.only(right: 20.0, left: 20.0),
        child: Divider(
          color: Color.fromRGBO(226, 224, 224, 1),
          thickness: 1,
        ),
      ),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [

                                 Expanded(
                                   child: Container(
                                     height: 60,
                                     child: Column(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.start,
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         const Padding(
                                           padding:
                                           EdgeInsets.only(left: 20.0),
                                           child: Text(
                                             'Ռեժիմ',
                                             textAlign: TextAlign.start,
                                             style: TextStyle(
                                               fontSize: 14,
                                               fontWeight: FontWeight.w400,
                                               letterSpacing: 1,
                                               color: Color.fromRGBO(
                                                   122, 108, 115, 1),
                                             ),
                                           ),
                                         ),
                                         SizedBox(
                                           height: orentation ==
                                               Orientation.landscape
                                               ? 0.1
                                               : 10.0,
                                         ),
                                         Expanded(
                                           child: Container(
                                             height: 85.0,
                                             child: Row(
                                               mainAxisAlignment:
                                               MainAxisAlignment.spaceAround,
                                               children: [
                                                 Expanded(
                                                   child: GestureDetector(
                                                     onTap: () {
                                                       setState(() {
                                                         isLisghtTheme =
                                                         !isLisghtTheme;
                                                         isDarkTheme = false;
                                                         context
                                                             .read<
                                                             ThemeNotifier>()
                                                             .lightThemeData();
                                                       });
                                                     },
                                                     child: Container(
                                                         width: 60,
                                                         height: 70,
                                                         child: Column(
                                                           children: [
                                                             Expanded(
                                                               child: Container(
                                                                 height: orentation ==
                                                                     Orientation
                                                                         .landscape
                                                                     ? 27.0
                                                                     : 37.0,
                                                                 width: orentation ==
                                                                     Orientation
                                                                         .landscape
                                                                     ? 27.0
                                                                     : 37.0,
                                                                 child: Stack(
                                                                   children: [
                                                                     Container(
                                                                       height:
                                                                       37,
                                                                       width: 37,
                                                                       color: !isLisghtTheme
                                                                           ? const Color.fromRGBO(
                                                                           226,
                                                                           224,
                                                                           224,
                                                                           1)
                                                                           : Palette
                                                                           .whenTapedButton,
                                                                       child: Container(
                                                                           height:
                                                                           37,
                                                                           width:
                                                                           37,
                                                                           color: const Color.fromRGBO(
                                                                               226,
                                                                               224,
                                                                               224,
                                                                               1)),
                                                                     ),
                                                                   ],
                                                                 ),
                                                               ),
                                                             ),
                                                             SizedBox(
                                                               height: orentation ==
                                                                   Orientation
                                                                       .landscape
                                                                   ? 0.1
                                                                   : 10.0,
                                                             ),
                                                             Text(
                                                               'Ցերեկ',
                                                               style: TextStyle(
                                                                 fontSize: 12,
                                                                 fontWeight:
                                                                 FontWeight
                                                                     .w400,
                                                                 letterSpacing:
                                                                 1,
                                                                 color: !isLisghtTheme
                                                                     ? const Color
                                                                     .fromRGBO(
                                                                     186,
                                                                     166,
                                                                     177,
                                                                     1)
                                                                     : Palette
                                                                     .whenTapedButton,
                                                               ),
                                                             ),
                                                           ],
                                                         )),
                                                   ),
                                                 ),
                                                 Expanded(
                                                   child: GestureDetector(
                                                     onTap: () {
                                                       setState(() {
                                                         isDarkTheme =
                                                         !isDarkTheme;
                                                         isLisghtTheme = false;
                                                         context
                                                             .read<
                                                             ThemeNotifier>()
                                                             .darkThemeData();
                                                       });
                                                     },
                                                     child: Container(
                                                         width: 60,
                                                         height: 70,
                                                         child: Column(
                                                           children: [
                                                             Expanded(
                                                               child: Container(
                                                                 height: orentation ==
                                                                     Orientation
                                                                         .landscape
                                                                     ? 27.0
                                                                     : 37.0,
                                                                 width: orentation ==
                                                                     Orientation
                                                                         .landscape
                                                                     ? 27.0
                                                                     : 37.0,
                                                                 child:
                                                                 Container(
                                                                   color: Colors
                                                                       .black,
                                                                   width: 37,
                                                                   height: 37,
                                                                 ),
                                                               ),
                                                             ),
                                                             SizedBox(
                                                               height: orentation ==
                                                                   Orientation
                                                                       .landscape
                                                                   ? 0.0
                                                                   : 10.0,
                                                             ),
                                                             Text(
                                                               'Գիշեր',
                                                               style: TextStyle(
                                                                 fontSize: 12,
                                                                 fontWeight:
                                                                 FontWeight
                                                                     .w400,
                                                                 letterSpacing:
                                                                 1,
                                                                 color: !isDarkTheme
                                                                     ? const Color
                                                                     .fromRGBO(
                                                                     186,
                                                                     166,
                                                                     177,
                                                                     1)
                                                                     : Palette
                                                                     .whenTapedButton,
                                                               ),
                                                             ),
                                                           ],
                                                         )),
                                                   ),
                                                 )
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
              Expanded(
                                   child: Container(
                                     height: 60,
                                     child: Column(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.start,
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         const Padding(
                                           padding:
                                           EdgeInsets.only(left: 20.0),
                                           child: Text(
                                             'Էկրան',
                                             textAlign: TextAlign.start,
                                             style: TextStyle(
                                               fontSize: 14,
                                               fontWeight: FontWeight.w400,
                                               letterSpacing: 1,
                                               color: Color.fromRGBO(
                                                   122, 108, 115, 1),
                                             ),
                                           ),
                                         ),
                                         SizedBox(
                                           height: orentation ==
                                               Orientation.landscape
                                               ? 0.1
                                               : 10.0,
                                         ),
                                         Expanded(
                                           child: Container(
                                             height: 85.0,
                                             child: Row(
                                               mainAxisAlignment:
                                               MainAxisAlignment.spaceAround,
                                               children: [
                                                 Expanded(
                                                   child: GestureDetector(
                                                     onTap: () {
                                                       setState(() {
                                                         isPhoneturnHorizontal =
                                                         !isPhoneturnHorizontal;
                                                         isPhoneturnVertical =
                                                         false;
                                                       });
                                                       SystemChrome
                                                           .setPreferredOrientations([
                                                         DeviceOrientation
                                                             .landscapeRight,
                                                         DeviceOrientation
                                                             .landscapeLeft,
                                                       ]);
                                                     },
                                                     child: Container(
                                                         width: 50,
                                                         height: double.infinity,
                                                         child: Column(
                                                           children: [
                                                             SvgPicture.asset(
                                                               'assets/images/phone1.svg',
                                                               color: !isPhoneturnHorizontal
                                                                   ? null
                                                                   : Palette
                                                                   .whenTapedButton,
                                                             ),
                                                             SizedBox(
                                                               height: orentation ==
                                                                   Orientation
                                                                       .landscape
                                                                   ? 0.1
                                                                   : 15.0,
                                                             ),
                                                             const Text(
                                                               'Հորիզոնական',
                                                               style: TextStyle(
                                                                   color: Color
                                                                       .fromRGBO(
                                                                       186,
                                                                       166,
                                                                       177,
                                                                       1),
                                                                   fontFamily:
                                                                   'GHEAGrapalat',
                                                                   fontSize:
                                                                   12.0,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w400),
                                                             )
                                                           ],
                                                         )),
                                                   ),
                                                 ),
                                                 Expanded(
                                                   child: GestureDetector(
                                                     onTap: () {
                                                       // print('dark theme');
                                                       setState(() {
                                                         isPhoneturnVertical =
                                                         !isPhoneturnVertical;
                                                         isPhoneturnHorizontal =
                                                         false;
                                                         SystemChrome
                                                             .setPreferredOrientations([
                                                           DeviceOrientation
                                                               .portraitUp,
                                                           DeviceOrientation
                                                               .portraitDown,
                                                         ]);
                                                       });
                                                     },
                                                     child: Container(
                                                         width: 50,
                                                         height: double.infinity,
                                                         child: Column(
                                                           children: [
                                                             SvgPicture.asset(
                                                                 'assets/images/phone2.svg',
                                                                 height: orentation ==
                                                                     Orientation
                                                                         .landscape
                                                                     ? 19
                                                                     : null,
                                                                 color: !isPhoneturnVertical
                                                                     ? null
                                                                     : Palette
                                                                     .whenTapedButton),
                                                             SizedBox(
                                                               height: orentation ==
                                                                   Orientation
                                                                       .landscape
                                                                   ? 0.1
                                                                   : 10.0,
                                                             ),
                                                             const Text(
                                                               'Ուղղահայաց',
                                                               style: TextStyle(
                                                                   color: Color
                                                                       .fromRGBO(
                                                                       186,
                                                                       166,
                                                                       177,
                                                                       1),
                                                                   fontFamily:
                                                                   'GHEAGrapalat',
                                                                   fontSize:
                                                                   12.0,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w400),
                                                             )
                                                           ],
                                                         )),
                                                   ),
                                                 )
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),


           ],),
    ],
  ),
),);
    // return Column(children: [
    //   SizedBox(height: 10,),
    //   Expanded(
    //     child: Container(
    //       width: mediaQuery.width,
    //       height: mediaQuery.height,
    //       child: Column(children: [
    //         Padding(
    //           padding: const EdgeInsets.only(right: 20.0, left: 20.0),
    //           child: Text(
    //             'Կարգավորումներ',
    //             style: TextStyle(
    //                 fontSize: 14, fontWeight: FontWeight.bold),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //         SizedBox(height: 10.0),
    //         Padding(
    //           padding: const EdgeInsets.only(right: 20.0, left: 20.0),
    //           child: Divider(
    //             color: Color.fromRGBO(226, 224, 224, 1),
    //             thickness: 1,
    //           ),
    //         ),
    //         Expanded(
    //           child: Container(
    //               height: MediaQuery.of(context).size.height - 250,
    //               width: MediaQuery.of(context).size.width,
    //               child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment
    //                             .start, //  mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Padding(
    //                             padding:
    //                             const EdgeInsets.only(left: 20.0),
    //                             child: Expanded(
    //                               child: Text(
    //                                 'Պայծառություն',
    //                                 textAlign: TextAlign.start,
    //                                 style: TextStyle(
    //                                   fontSize: 14,
    //                                   fontWeight: FontWeight.w400,
    //                                   letterSpacing: 1,
    //                                   color: Color.fromRGBO(
    //                                       122, 108, 115, 1),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           Expanded(
    //                             child: Container(
    //                               width: MediaQuery.of(context)
    //                                   .size
    //                                   .width,
    //                               height: 70,
    //                               child: SliderTheme(
    //                                   data: SliderTheme.of(context)
    //                                       .copyWith(
    //                                     activeTrackColor:
    //                                     Palette.main,
    //                                     inactiveTrackColor:
    //                                     Color.fromRGBO(
    //                                         226, 224, 224, 1),
    //                                     trackShape:
    //                                     RoundedRectSliderTrackShape(),
    //                                     trackHeight: 4.0,
    //                                     thumbShape:
    //                                     RoundSliderThumbShape(
    //                                         enabledThumbRadius:
    //                                         12.0),
    //                                     thumbColor: Palette.main,
    //                                     overlayColor: Palette.disable,
    //                                     overlayShape:
    //                                     RoundSliderOverlayShape(
    //                                         overlayRadius: 18.0),
    //                                     tickMarkShape:
    //                                     RoundSliderTickMarkShape(),
    //                                     activeTickMarkColor:
    //                                     Palette.main,
    //                                     inactiveTickMarkColor:
    //                                     Color.fromRGBO(
    //                                         226, 224, 224, 1),
    //                                     valueIndicatorShape:
    //                                     PaddleSliderValueIndicatorShape(),
    //                                     valueIndicatorColor:
    //                                     Palette.main,
    //                                     valueIndicatorTextStyle:
    //                                     TextStyle(
    //                                         color: Palette.main),
    //                                   ),
    //                                   child: FutureBuilder(
    //                                       future: ScreenBrightness()
    //                                           .current,
    //                                       builder:
    //                                           (BuildContext context,
    //                                           AsyncSnapshot
    //                                           snapshot) {
    //                                         double currentBrightness =
    //                                         0;
    //                                         if (snapshot.hasData) {
    //                                           currentBrightness =
    //                                           snapshot.data!;
    //                                         }
    //                                         return StreamBuilder<
    //                                             double>(
    //                                           stream: ScreenBrightness()
    //                                               .onCurrentBrightnessChanged,
    //                                           builder: (context,
    //                                               snapshot) {
    //                                             double
    //                                             changedBrightness =
    //                                                 currentBrightness;
    //                                             if (snapshot
    //                                                 .hasData) {
    //                                               changedBrightness =
    //                                               snapshot.data!;
    //                                             }
    //
    //                                             return Slider
    //                                                 .adaptive(
    //                                               value:
    //                                               changedBrightness,
    //                                               onChanged: (value) {
    //                                                 setBrightness(
    //                                                     value);
    //                                               },
    //                                             );
    //                                           },
    //                                         );
    //                                       })),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(
    //                           right: 20.0, left: 20.0),
    //                       child: Divider(
    //                         color: Color.fromRGBO(226, 224, 224, 1),
    //                         thickness: 1,
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment:
    //                         CrossAxisAlignment.start,
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Padding(
    //                             padding:
    //                             const EdgeInsets.only(left: 20.0),
    //                             child: Text(
    //                               'Տառաչափ',
    //                               textAlign: TextAlign.start,
    //                               style: TextStyle(
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.w400,
    //                                 letterSpacing: 1,
    //                                 color: Color.fromRGBO(
    //                                     122, 108, 115, 1),
    //                               ),
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             height: orentation ==
    //                                 Orientation.landscape
    //                                 ? 10.0
    //                                 : 20.0,
    //                           ),
    //                           Expanded(
    //                             child: Container(
    //                               height: 50.0,
    //                               color: Colors.amber,
    //                               child: Row(
    //                                 mainAxisAlignment:
    //                                 MainAxisAlignment.spaceEvenly,
    //                                 children: [
    //                                   GestureDetector(
    //                                     onTap: () {
    //                                       //!!!!
    //                                       if (textSize >= 12.0) {
    //                                         setState(() {
    //                                           textSize =
    //                                               textSize - 2.0;
    //                                         });
    //                                       }
    //                                     },
    //                                     child: SvgPicture.asset(
    //                                       'assets/images/VectorLine.svg',
    //                                     ),
    //                                   ),
    //                                   Text(
    //                                     'Աա',
    //                                     style: TextStyle(
    //                                         fontSize: textSize),
    //                                   ),
    //                                   GestureDetector(
    //                                     onTap: () {
    //                                       if (textSize <= 20.0) {
    //                                         setState(() {
    //                                           textSize =
    //                                               textSize + 2.0;
    //                                         });
    //                                       }
    //                                     },
    //                                     child: Padding(
    //                                       padding:
    //                                       const EdgeInsets.only(
    //                                           right: 22.0),
    //                                       child: SvgPicture.asset(
    //                                           'assets/images/plusik.svg'),
    //                                     ),
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(
    //                           right: 20.0, left: 20.0),
    //                       child: Divider(
    //                         color: Color.fromRGBO(226, 224, 224, 1),
    //                         thickness: 1,
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment:
    //                         CrossAxisAlignment.start,
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Padding(
    //                             padding:
    //                             const EdgeInsets.only(left: 20.0),
    //                             child: Text(
    //                               'Ռեժիմ',
    //                               textAlign: TextAlign.start,
    //                               style: TextStyle(
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.w400,
    //                                 letterSpacing: 1,
    //                                 color: Color.fromRGBO(
    //                                     122, 108, 115, 1),
    //                               ),
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             height: orentation ==
    //                                 Orientation.landscape
    //                                 ? 0.1
    //                                 : 10.0,
    //                           ),
    //                           Expanded(
    //                             child: Container(
    //                               height: 85.0,
    //                               child: Row(
    //                                 mainAxisAlignment:
    //                                 MainAxisAlignment.spaceAround,
    //                                 children: [
    //                                   Expanded(
    //                                     child: GestureDetector(
    //                                       onTap: () {
    //                                         setState(() {
    //                                           isLisghtTheme =
    //                                           !isLisghtTheme;
    //                                           isDarkTheme = false;
    //                                           context
    //                                               .read<
    //                                               ThemeNotifier>()
    //                                               .lightThemeData();
    //                                         });
    //                                       },
    //                                       child: Container(
    //                                           width: 60,
    //                                           height: 70,
    //                                           child: Column(
    //                                             children: [
    //                                               Expanded(
    //                                                 child: Container(
    //                                                   height: orentation ==
    //                                                       Orientation
    //                                                           .landscape
    //                                                       ? 27.0
    //                                                       : 37.0,
    //                                                   width: orentation ==
    //                                                       Orientation
    //                                                           .landscape
    //                                                       ? 27.0
    //                                                       : 37.0,
    //                                                   child: Stack(
    //                                                     children: [
    //                                                       Container(
    //                                                         height:
    //                                                         37,
    //                                                         width: 37,
    //                                                         color: !isLisghtTheme
    //                                                             ? Color.fromRGBO(
    //                                                             226,
    //                                                             224,
    //                                                             224,
    //                                                             1)
    //                                                             : Palette
    //                                                             .whenTapedButton,
    //                                                         child: Container(
    //                                                             height:
    //                                                             37,
    //                                                             width:
    //                                                             37,
    //                                                             color: Color.fromRGBO(
    //                                                                 226,
    //                                                                 224,
    //                                                                 224,
    //                                                                 1)),
    //                                                       ),
    //                                                     ],
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                               SizedBox(
    //                                                 height: orentation ==
    //                                                     Orientation
    //                                                         .landscape
    //                                                     ? 0.1
    //                                                     : 10.0,
    //                                               ),
    //                                               Text(
    //                                                 'Ցերեկ',
    //                                                 style: TextStyle(
    //                                                   fontSize: 12,
    //                                                   fontWeight:
    //                                                   FontWeight
    //                                                       .w400,
    //                                                   letterSpacing:
    //                                                   1,
    //                                                   color: !isLisghtTheme
    //                                                       ? Color
    //                                                       .fromRGBO(
    //                                                       186,
    //                                                       166,
    //                                                       177,
    //                                                       1)
    //                                                       : Palette
    //                                                       .whenTapedButton,
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           )),
    //                                     ),
    //                                   ),
    //                                   Expanded(
    //                                     child: GestureDetector(
    //                                       onTap: () {
    //                                         setState(() {
    //                                           isDarkTheme =
    //                                           !isDarkTheme;
    //                                           isLisghtTheme = false;
    //                                           context
    //                                               .read<
    //                                               ThemeNotifier>()
    //                                               .darkThemeData();
    //                                         });
    //                                       },
    //                                       child: Container(
    //                                           width: 60,
    //                                           height: 70,
    //                                           child: Column(
    //                                             children: [
    //                                               Expanded(
    //                                                 child: Container(
    //                                                   height: orentation ==
    //                                                       Orientation
    //                                                           .landscape
    //                                                       ? 27.0
    //                                                       : 37.0,
    //                                                   width: orentation ==
    //                                                       Orientation
    //                                                           .landscape
    //                                                       ? 27.0
    //                                                       : 37.0,
    //                                                   child:
    //                                                   Container(
    //                                                     color: Colors
    //                                                         .black,
    //                                                     width: 37,
    //                                                     height: 37,
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                               SizedBox(
    //                                                 height: orentation ==
    //                                                     Orientation
    //                                                         .landscape
    //                                                     ? 0.0
    //                                                     : 10.0,
    //                                               ),
    //                                               Text(
    //                                                 'Գիշեր',
    //                                                 style: TextStyle(
    //                                                   fontSize: 12,
    //                                                   fontWeight:
    //                                                   FontWeight
    //                                                       .w400,
    //                                                   letterSpacing:
    //                                                   1,
    //                                                   color: !isDarkTheme
    //                                                       ? Color
    //                                                       .fromRGBO(
    //                                                       186,
    //                                                       166,
    //                                                       177,
    //                                                       1)
    //                                                       : Palette
    //                                                       .whenTapedButton,
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           )),
    //                                     ),
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(
    //                           right: 20.0, left: 20.0),
    //                       child: Divider(
    //                         color: Color.fromRGBO(226, 224, 224, 1),
    //                         thickness: 1.2,
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment:
    //                         CrossAxisAlignment.start,
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Padding(
    //                             padding:
    //                             const EdgeInsets.only(left: 20.0),
    //                             child: Text(
    //                               'Էկրան',
    //                               textAlign: TextAlign.start,
    //                               style: TextStyle(
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.w400,
    //                                 letterSpacing: 1,
    //                                 color: Color.fromRGBO(
    //                                     122, 108, 115, 1),
    //                               ),
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             height: orentation ==
    //                                 Orientation.landscape
    //                                 ? 0.1
    //                                 : 10.0,
    //                           ),
    //                           Expanded(
    //                             child: Container(
    //                               height: 85.0,
    //                               child: Row(
    //                                 mainAxisAlignment:
    //                                 MainAxisAlignment.spaceAround,
    //                                 children: [
    //                                   Expanded(
    //                                     child: GestureDetector(
    //                                       onTap: () {
    //                                         setState(() {
    //                                           isPhoneturnHorizontal =
    //                                           !isPhoneturnHorizontal;
    //                                           isPhoneturnVertical =
    //                                           false;
    //                                         });
    //                                         SystemChrome
    //                                             .setPreferredOrientations([
    //                                           DeviceOrientation
    //                                               .landscapeRight,
    //                                           DeviceOrientation
    //                                               .landscapeLeft,
    //                                         ]);
    //                                       },
    //                                       child: Container(
    //                                           width: 50,
    //                                           height: double.infinity,
    //                                           child: Column(
    //                                             children: [
    //                                               SvgPicture.asset(
    //                                                 'assets/images/phone1.svg',
    //                                                 color: !isPhoneturnHorizontal
    //                                                     ? null
    //                                                     : Palette
    //                                                     .whenTapedButton,
    //                                               ),
    //                                               SizedBox(
    //                                                 height: orentation ==
    //                                                     Orientation
    //                                                         .landscape
    //                                                     ? 0.1
    //                                                     : 15.0,
    //                                               ),
    //                                               Text(
    //                                                 'Հորիզոնական',
    //                                                 style: TextStyle(
    //                                                     color: Color
    //                                                         .fromRGBO(
    //                                                         186,
    //                                                         166,
    //                                                         177,
    //                                                         1),
    //                                                     fontFamily:
    //                                                     'GHEAGrapalat',
    //                                                     fontSize:
    //                                                     12.0,
    //                                                     fontWeight:
    //                                                     FontWeight
    //                                                         .w400),
    //                                               )
    //                                             ],
    //                                           )),
    //                                     ),
    //                                   ),
    //                                   Expanded(
    //                                     child: GestureDetector(
    //                                       onTap: () {
    //                                         // print('dark theme');
    //                                         setState(() {
    //                                           isPhoneturnVertical =
    //                                           !isPhoneturnVertical;
    //                                           isPhoneturnHorizontal =
    //                                           false;
    //                                           SystemChrome
    //                                               .setPreferredOrientations([
    //                                             DeviceOrientation
    //                                                 .portraitUp,
    //                                             DeviceOrientation
    //                                                 .portraitDown,
    //                                           ]);
    //                                         });
    //                                       },
    //                                       child: Container(
    //                                           width: 50,
    //                                           height: double.infinity,
    //                                           child: Column(
    //                                             children: [
    //                                               SvgPicture.asset(
    //                                                   'assets/images/phone2.svg',
    //                                                   height: orentation ==
    //                                                       Orientation
    //                                                           .landscape
    //                                                       ? 19
    //                                                       : null,
    //                                                   color: !isPhoneturnVertical
    //                                                       ? null
    //                                                       : Palette
    //                                                       .whenTapedButton),
    //                                               SizedBox(
    //                                                 height: orentation ==
    //                                                     Orientation
    //                                                         .landscape
    //                                                     ? 0.1
    //                                                     : 10.0,
    //                                               ),
    //                                               Text(
    //                                                 'Ուղղահայաց',
    //                                                 style: TextStyle(
    //                                                     color: Color
    //                                                         .fromRGBO(
    //                                                         186,
    //                                                         166,
    //                                                         177,
    //                                                         1),
    //                                                     fontFamily:
    //                                                     'GHEAGrapalat',
    //                                                     fontSize:
    //                                                     12.0,
    //                                                     fontWeight:
    //                                                     FontWeight
    //                                                         .w400),
    //                                               )
    //                                             ],
    //                                           )),
    //                                     ),
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ])),
    //         )
    //       ]),
    //     ),
    //   ),
    // ]);
}
}


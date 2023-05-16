import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/config/palette.dart';

class HideMenuAppBar extends StatefulWidget {
  bool isFavorite;
  bool isBovandakMenu;
  HideMenuAppBar(
      {Key? key, required this.isFavorite, required this.isBovandakMenu})
      : super(key: key);

  @override
  State<HideMenuAppBar> createState() => _HideMenuAppBarState();
}

class _HideMenuAppBarState extends State<HideMenuAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(children: [
          SizedBox(
              height: 20,
              width: 50,
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/images/arrow.svg',
                    width: 20,
                  ),
                ),
              )),
        ]),
        Spacer(),
        Container(
            child: InkWell(
          onTap: () => setState(() {
            widget.isBovandakMenu = !widget.isBovandakMenu;
            // isFavorite = false;

            // isSettings = false;
            // isShare = false;
            // isYoutubeActive = false;
            //  print("BovandakMenu :: $isBovandakMenu");
          }),
          child: SvgPicture.asset(
            'assets/images/bovandakutyun_menu.svg',
            color: widget.isBovandakMenu ? Palette.whenTapedButton : null,
            width: 30,
          ),
        )),
        Spacer(),
        SizedBox(
          // height: 120,
          // width: 32,
          child: Stack(children: [
            SizedBox(
                height: 80,
                width: 50,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.isFavorite = !widget.isFavorite;
                        // isBovandakMenu = false;
                        // isSettings = false;
                        // isShare = false;
                        // isYoutubeActive = false;
                        //  print("Favorite :: $isFavorite");
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/images/favorite.svg',
                      width: 20,
                      color: widget.isFavorite ? Palette.whenTapedButton : null,
                    ),
                  ),
                )),
          ]),
        ),
      ],
    );
  }
}

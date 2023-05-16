import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/size_config.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/home_screen.dart';
import 'package:rive/rive.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool? isActive;
  bool isStopped = false; //global

  @override
  void initState() {
    super.initState();

    play();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void play() async {


    if (isActive == true){
      await Future.delayed(Duration(milliseconds: 5000));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomeScreen()),
              (Route<dynamic> route) => false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(83, 66, 77, 1),
        body: ConnectivityBuilder(
            builder: (context, isConnected, status) {
              if (isConnected == true) {
                isActive = true;  play();
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Բարի գալուստ',
                          style: TextStyle(
                              fontFamily: 'GHEAGrapalat',
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 500,
                        width: SizeConfig.screenWidth,
                        child: RiveAnimation.asset(
                          'assets/images/mashtoz3.riv',
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                );

              }
              return Center(child: AlertDialog(
                elevation: 0.1,
                backgroundColor: Palette.barColor,
                title: Text('Միացրեք ինտերնետը',style: TextStyle(color: Colors.white),),

              ));
            }));
  }
}
// import 'package:flutter/material.dart';
// import 'package:from_css_color/from_css_color.dart';
// import 'package:mashtoz_flutter/ui/widgets/main_page/home_screen.dart';
// import 'package:video_player/video_player.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   // video controller
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = VideoPlayerController.asset(
//       'assets/images/mashtoz.mp4',
//     )
//       ..initialize().then((_) {
//         setState(() {});
//       })
//       ..setVolume(0.0);

//     _playVideo();
//   }

//   void _playVideo() async {
//     // playing video
//     _controller.play();

//     //add delay till video is complite
//     await Future.delayed(const Duration(milliseconds: 3640));

//     // navigating to home screen
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomeScreen()));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: fromCssColor('#53424c'),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(
//                   _controller,
//                 ),
//               )
//             : Container(),
//       ),
//     );
//   }
// }

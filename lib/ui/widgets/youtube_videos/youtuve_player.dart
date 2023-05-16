import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../domens/models/book_data/data.dart';

class YoutubePlayers extends StatefulWidget {
  final Lessons? lessons;
  final Data? dataCharacters;
  final bool? isShow;
  final String? url;
  const YoutubePlayers({
    Key? key,
    this.lessons,
    this.dataCharacters,
    this.isShow,
    this.url,
  }) : super(key: key);

  @override
  _YoutubePlayersState createState() => _YoutubePlayersState(
      lessons: lessons,
      dataCharacters: dataCharacters,
      isShow: isShow,
      url: url);
}

class _YoutubePlayersState extends State<YoutubePlayers> {
  final bool? isShow;
  final Lessons? lessons;
  final String? url;
  final Data? dataCharacters;
  _YoutubePlayersState(
      {this.lessons, this.dataCharacters, this.isShow, this.url});
  late YoutubePlayerController _controller;
  // late TextEditingController _idController;
  bool _isPlayerReady = false;
  // late TextEditingController _seekToController;s
  late YoutubeMetaData _videoMetaData;
  // late var videoIdd;
  @override
  void initState() {
    super.initState();

    // controller = VideoPlayerController.network(lessons!.link!)
    //   ..addListener(() => setState(() {}))
    //   ..setLooping(true)
    //   ..initialize().then((_) => controller.play());
    final List<String> _ids = [
      'ThrBnUMhCzc',
    ];

    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(isShow == true
          ? lessons?.link
          : dataCharacters?.link != null
              ? dataCharacters?.link
              : url != null
                  ? url
                  : _ids.first)!,
      //initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        hideControls: false,
        mute: false,
        loop: true,
         hideThumbnail: true,
        controlsVisibleAtStart:true,
        forceHD: true,
      ),
    )..addListener(listener);
    // _idController = TextEditingController();
    // _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();

    //   videoIdd = YoutubePlayer.convertUrlToId("${dataCharacters?.link}");
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: VideoPlayerBothWidget(
          controller: _controller,
          metaData: _videoMetaData,
        ),
      );
}

class VideoPlayerBothWidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final YoutubeMetaData metaData;
  const VideoPlayerBothWidget({
    Key? key,
    required this.controller,
    required this.metaData,
  }) : super(key: key);

  @override
  _VideoPlayerBothWidgetState createState() => _VideoPlayerBothWidgetState();
}

class _VideoPlayerBothWidgetState extends State<VideoPlayerBothWidget> {
  Orientation? target;

  @override
  void initState() {
    super.initState();

    NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      final isPortrait = event == NativeDeviceOrientation.portraitUp;
      final isLandscape = event == NativeDeviceOrientation.landscapeLeft ||
          event == NativeDeviceOrientation.landscapeRight;
      final isTargetPortrait = target == Orientation.portrait;
      final isTargetLandscape = target == Orientation.landscape;

      if (isPortrait && isTargetPortrait || isLandscape && isTargetLandscape) {
        target = null;
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    });
  }

  void setOrientation(bool isPortrait) {
    if (isPortrait) {
      Wakelock.disable();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    } else {
      Wakelock.enable();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  @override
  Widget build(BuildContext context) => widget.controller != null
      ? WillPopScope(
          onWillPop: () async {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            return true;
          },
          child: Container(
              color: Colors.black.withOpacity(0.9),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              child: buildVideo()),
        )
      : Center(child: CircularProgressIndicator());

  Widget buildVideo() => OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          setOrientation(isPortrait);

          return Stack(
            fit: isPortrait ? StackFit.passthrough : StackFit.expand,
            children: <Widget>[
               Positioned.fill(
                      child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          icon: Icon(Icons.arrow_back_ios_new_outlined)),
                    )),

              isPortrait
                  ? Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: buildVideoPlayer()),
                    )
                  : buildVideoPlayer(),
            ],
          );
        },
      );

  Widget buildVideoPlayer() {
    final video = YoutubePlayer(
      controller: widget.controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Palette.main,
      topActions: <Widget>[
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            widget.metaData.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );

    return buildFullScreen(child: video);
  }

  Widget buildFullScreen({
    @required Widget? child,
  }) {
    final width = 300.0;
    final height = 200.0;

    return Expanded(
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

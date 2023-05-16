import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoView extends StatefulWidget {
  final String link;
  const VideoView({Key? key,required this.link}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final WebViewController _controller;

  bool isLoading = false;
  
  @override
  void initState() {

    // late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
    //   params = const PlatformWebViewControllerCreationParams();
    // }
    // final WebViewController controller =
    // WebViewController.fromPlatformCreationParams(params);
    // controller
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..loadRequest(
    //   Uri.parse('${widget.link}'),
    // );
    //
    // // #docregion platform_features
    // if (controller.platform is AndroidWebViewController) {
    //   AndroidWebViewController.enableDebugging(true);
    //   (controller.platform as AndroidWebViewController)
    //       .setMediaPlaybackRequiresUserGesture(false);
    // }
    // #enddocregion platform_features

    super.initState();
    makeLoading();
  }
  void makeLoading(){
    Future.delayed(Duration(milliseconds: 400),(){setState(() {
      isLoading = true;
    });});
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
        color: Colors.white,
        onPressed: () {
      Navigator.pop(context, true);
    },
    icon: Icon(Icons.arrow_back_ios_new_outlined),

     ))),
        body: Center(
    child:!isLoading? Center(child: CircularProgressIndicator(color: Palette.main,),) : Container(
      color: Colors.black,
      child: WebView(
        initialUrl: widget.link,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller){
           _controller = controller;
        },

      ),
    ),

    ));
  }
}

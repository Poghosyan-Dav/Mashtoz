import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mashtoz_flutter/config/palette.dart';

class VideoView extends StatefulWidget {
  final String link;
  const VideoView({Key? key, required this.link}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    makeLoading();
  }

  void makeLoading() {
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: !isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Palette.main,
                  ),
                )
              : Container(
                  color: Colors.black,
                  child:  InAppWebView(initialUrlRequest:
                  URLRequest(url: Uri.parse(widget.link))
                  ),
                ),
        ));
  }
}

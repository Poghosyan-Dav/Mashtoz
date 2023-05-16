import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Triangle extends CustomPainter {
  Paint? painter;

  Triangle() {
    painter = Paint()
      ..color = const Color.fromRGBO(83, 66, 77, 1)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(size.width * 1 / 2, size.height * 2.5 / 4);
    path.lineTo(size.width * 3 / 9, size.height * 4 / 4);
    path.lineTo(size.width * 5 / 7.5, size.height * 4 / 4);
    path.close();

    canvas.drawPath(path, painter!);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BottomBar extends StatefulWidget {
  final Function()? onPressed;
  final bool? bottomIcons;
  final Widget? path;

  const BottomBar({
    Key? key,
    this.onPressed,
    this.bottomIcons,
    this.path,
  }) : super(key: key);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: widget.bottomIcons == true ? widget.path : widget.path,
    );
  }
}

class BookBox extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff7A6C73).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(
            0, size.height * 0.01532248, size.width, size.height * 0.3502413),
        paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.3655630);
    path_1.lineTo(size.width, size.height * 0.3655630);
    path_1.lineTo(size.width * 0.9444448, size.height * 0.5406848);
    path_1.lineTo(size.width * 0.05555552, size.height * 0.5406848);
    path_1.lineTo(0, size.height * 0.3655630);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xff190412).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(size.width, size.height * 0.9784870);
    path_2.lineTo(0, size.height * 0.9784848);
    path_2.lineTo(size.width * 0.05555552, size.height * 0.5406848);
    path_2.lineTo(size.width * 0.9444448, size.height * 0.5406848);
    path_2.lineTo(size.width, size.height * 0.9784870);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.5000000, size.height * 0.9784870),
        Offset(size.width * 0.5000000, size.height * 0.5406848), [
      const Color(0xff53424D).withOpacity(1),
      const Color(0xff53424D).withOpacity(0),
      const Color(0xff000000).withOpacity(0.56)
    ], [
      0,
      0.0001,
      1
    ]);
    canvas.drawPath(path_2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

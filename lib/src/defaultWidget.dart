import 'package:flutter/widgets.dart';

import 'types.dart';

/// Default Tip Box
class TooltipDefault extends StatelessWidget {
  final String message;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final double height;
  const TooltipDefault({
    Key? key,
    required this.message,
    required this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Container(
          padding: padding,
          margin: margin,
          decoration: decoration,
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Text(
              message,
              style: textStyle,
            ),
          ),
        ));
  }
}

/// The default drawn triangle hint border
class DefTrianglePainter extends CustomPainter {
  PreferOrientation preferSite;
  Color? color;

  DefTrianglePainter({this.preferSite = PreferOrientation.down, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    Paint paint = new Paint();
    paint.strokeWidth = 2.0;
    paint.color = color ?? Color(0xFFFFA500);
    paint.style = PaintingStyle.fill;
    switch (preferSite) {
      case PreferOrientation.up:
        path.moveTo(0.0, -1.0);
        path.lineTo(size.width / 2, -1.0);
        path.lineTo(size.width / 4, size.height / 2);
        break;
      case PreferOrientation.down:
        path.moveTo(size.width / 4.0, size.height / 2);
        path.lineTo(0.0, size.height + 1);
        path.lineTo(size.width / 2, size.height + 1);
        break;
      case PreferOrientation.left:
        path.moveTo(-1, 0.0);
        path.lineTo(size.width / 2, size.height / 2);
        path.lineTo(-1, size.height);
        break;
      case PreferOrientation.right:
        path.moveTo(size.width, 0.0);
        path.lineTo(size.width / 2, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
      default:
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter customPainter) {
    return true;
  }
}

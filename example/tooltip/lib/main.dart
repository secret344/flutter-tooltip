import 'package:flutter/material.dart';
import 'package:metooltip/default.dart';
import 'package:metooltip/metooltip.dart';
import 'package:metooltip/tooltipBase.dart';
import 'package:metooltip/types.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            MeUiTooltip(
              message: "This is a top tooltip",
              child: Text("Top tooltip"),
              preferOri: PreferOrientation.top,
            ),
            MeUiTooltip(
              message: "This is a right tooltip",
              child: Text("right tooltip"),
              allOffset: 50,
              preferOri: PreferOrientation.right,
            ),
            MeUiTooltip(
              message: "This is a bottom tooltip",
              child: Text("bottom tooltip"),
              preferOri: PreferOrientation.bottom,
            ),
            MeUiTooltip(
              message: "This is a left tooltip",
              child: Text("left tooltip"),
              allOffset: 50,
              preferOri: PreferOrientation.left,
            ),
            MeUiTooltip(
              message:
                  "This is a top tooltip,This is a top tooltip,This is a top tooltip,This is a top tooltip",
              child: Text("Top tooltip"),
              preferOri: PreferOrientation.top,
            ),
            MeUiTooltip(
              message:
                  "This is a right tooltip,This is a right tooltip,This is a right tooltip,This is a right tooltip",
              allOffset: 50,
              child: Text("right tooltip"),
              preferOri: PreferOrientation.right,
            ),
            MeUiTooltip(
              message:
                  "This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip",
              child: Text("bottom tooltip"),
              preferOri: PreferOrientation.bottom,
            ),
            MeUiTooltip(
              message:
                  "This is a left tooltip,This is a left tooltip,This is a left tooltip,This is a left tooltip",
              allOffset: 50,
              child: Text("left tooltip"),
              preferOri: PreferOrientation.left,
            ),
            MeUiTooltip(
              message:
                  "This is a left tooltip,This is a left tooltip,This is a left tooltip,This is a left tooltip",
              allOffset: 50,
              child: Text("custom left tooltip"),
              preferOri: PreferOrientation.left,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTooltip extends TooltipBase {
  final String message;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final Animation<double>? animation;
  final Offset target;
  final double allOffset;
  final PreferOrientation preferOri;
  final OverlayEntry entry;
  final Size targetSize;
  final Function customDismiss;
  final Color? triangleColor;
  CustomTooltip(
      {Key? key,
      required this.message,
      required this.height,
      this.triangleColor,
      this.padding,
      this.margin,
      this.decoration,
      this.textStyle,
      this.animation,
      required this.target,
      required this.allOffset,
      required this.preferOri,
      required this.entry,
      required this.targetSize,
      required this.customDismiss})
      : super(
            key: key,
            message: message,
            height: height,
            triangleColor: triangleColor,
            padding: padding,
            margin: margin,
            decoration: decoration,
            textStyle: textStyle,
            target: target,
            allOffset: allOffset,
            preferOri: preferOri,
            entry: entry,
            targetSize: targetSize,
            customDismiss: customDismiss);

  @override
  Widget getDefaultComputed({
    required PreferOrientation preferOri,
    required String message,
    required double height,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    TextStyle? textStyle,
  }) =>
      TooltipDefault(
        message: message,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        textStyle: textStyle,
      );
  @override
  CustomPaint getTipPainter(PreferOrientation preferOri, Color? triangleColor) {
    return CustomPaint(
        size: Size(15.0, 10),
        painter: _TrianglePainter(preferSite: preferOri, color: Colors.red));
  }
}

class _TrianglePainter extends CustomPainter {
  PreferOrientation preferSite;
  Color? color;

  _TrianglePainter({this.preferSite = PreferOrientation.bottom, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    Paint paint = new Paint();
    paint.strokeWidth = 2.0;
    paint.color = color ?? Color(0xFFFFA500);
    paint.style = PaintingStyle.fill;
    switch (preferSite) {
      case PreferOrientation.top:
        path.moveTo(0.0, -1.0);
        path.lineTo(size.width / 2, -1.0);
        path.lineTo(size.width / 4, size.height / 2);
        break;
      case PreferOrientation.bottom:
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

import 'package:flutter/material.dart';
import 'package:metooltip/metooltip.dart';
import 'package:metooltip/tooltipBase.dart';
import 'package:metooltip/types.dart';

import 'tooltipDefault.dart';

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
              message:
                  "This is a top tooltip,This is a top tooltip,This is a top tooltip,This is a top tooltip",
              allOffset: 50,
              child: Text("custom top tooltip"),
              preferOri: PreferOrientation.top,
              tooltipChild: _getTooltipChild,
              triangleColor: Color.fromARGB(255, 78, 47, 31),
            ),
            MeUiTooltip(
              message:
                  "This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip",
              allOffset: 0,
              child: Text("custom bottom tooltip"),
              preferOri: PreferOrientation.bottom,
              tooltipChild: _getTooltipChild,
              triangleColor: Color.fromARGB(255, 78, 47, 31),
              openMouseEvent: false,
            )
          ],
        ),
      ),
    );
  }

  TooltipBase _getTooltipChild(
      {required String message,
      required double height,
      Color? triangleColor,
      EdgeInsetsGeometry? padding,
      EdgeInsetsGeometry? margin,
      Decoration? decoration,
      TextStyle? textStyle,
      Animation<double>? animation,
      required Offset target,
      required double allOffset,
      required PreferOrientation preferOri,
      required OverlayEntry entry,
      required Size targetSize,
      required Function customDismiss}) {
    return CustomTooltip(
      message: message,
      height: height,
      preferOri: preferOri,
      allOffset: allOffset,
      triangleColor: triangleColor,
      padding: padding,
      margin: margin,
      decoration: decoration,
      textStyle: textStyle,
      target: target,
      entry: entry,
      targetSize: targetSize,
      customDismiss: customDismiss,
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
      myTooltipDefault(
        message: message,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        textStyle: textStyle,
      );

  @override
  CustomPaint customTipPainter(PreferOrientation preferOri) {
    return CustomPaint(
        size: Size(15.0, 10),
        painter: TrianglePainter(preferSite: preferOri, color: triangleColor));
  }

  @override
  void clickTooltip(customDismiss) {
    print("消失");
    customDismiss();
  }
}
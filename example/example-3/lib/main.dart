import 'package:flutter/material.dart';
import 'package:metooltip/metooltip.dart';

import 'defwidget.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MeTooltip(
          message:
              "This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip",
          allOffset: 0,
          child: Text("custom bottom tooltip"),
          preferOri: PreferOrientation.down,
          tooltipChild: _getTooltipChild,
          triangleColor: Color.fromARGB(255, 78, 47, 31),
        ),
      ),
    );
  }

  TooltipBase _getTooltipChild(DefTooltipType p) {
    return CustomTooltip(
      message: p.message,
      height: p.height,
      preferOri: p.preferOri,
      allOffset: p.allOffset,
      triangleColor: p.triangleColor,
      padding: p.padding,
      margin: p.margin,
      decoration: p.decoration,
      animation: p.animation,
      textStyle: p.textStyle,
      target: p.target,
      entry: p.entry,
      targetSize: p.targetSize,
      customDismiss: p.customDismiss,
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
      required Animation<double> animation,
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
            animation: animation,
            textStyle: textStyle,
            target: target,
            allOffset: allOffset,
            preferOri: preferOri,
            entry: entry,
            targetSize: targetSize,
            customDismiss: customDismiss);

  @override
  Widget getDefaultComputed(Animation<double>? animation) => MyTooltipDefault(
        message: message,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        textStyle: textStyle,
        animation: animation!,
      );

  @override
  Widget customTipPainter() {
    return CustomPaint(
        size: Size(15.0, 10),
        painter:
            DefTrianglePainter(preferSite: preferOri, color: triangleColor));
  }

  @override
  void clickTooltip(customDismiss) {
    print("消失");
    customDismiss();
  }

  @override
  Widget getCustomAnimation({required Animation<double> animation}) {
    return getDefaultTooltip(preferOri, animation);
  }
}

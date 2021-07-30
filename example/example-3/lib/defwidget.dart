import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTooltipDefault extends AnimatedWidget {
  final String message;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final double height;
  final Animation<double> animation;
  const MyTooltipDefault(
      {Key? key,
      required this.message,
      required this.height,
      required this.animation,
      this.padding,
      this.margin,
      this.decoration,
      this.textStyle})
      : super(key: key, listenable: animation);
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Opacity(
            opacity: _opacityTween.evaluate(animation),
            child: Container(
                height: _sizeTween.evaluate(animation),
                width: _sizeTween.evaluate(animation),
                margin: EdgeInsets.all(0),
                color: Colors.blue,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Image(
                      image: AssetImage("images/images.jpg"),
                      width: 300,
                    ),
                    Container(
                        width: 300,
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
                        ))
                  ],
                ))));
  }
}

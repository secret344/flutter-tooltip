import 'package:flutter/widgets.dart';

enum PreferOrientation { left, right, up, down }

class DefTooltipType {
  final String message;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final Animation<double> animation;
  final Offset target;
  final double allOffset;
  final PreferOrientation preferOri;
  final OverlayEntry entry;
  final Size targetSize;
  final Function customDismiss;
  final Color? triangleColor;
  final bool ignorePointer;
  DefTooltipType(
      {Key? key,
      required this.message,
      required this.height,
      bool? ignorePointer,
      this.triangleColor,
      this.padding,
      this.margin,
      this.decoration,
      this.textStyle,
      required this.animation,
      required this.target,
      required this.allOffset,
      required this.preferOri,
      required this.entry,
      required this.targetSize,
      required this.customDismiss})
      : ignorePointer = ignorePointer ?? false;
}

class DefaultTooltipType {
  final String message;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final double height;
  final PreferOrientation preferOri;
  const DefaultTooltipType(
      {Key? key,
      required this.message,
      required this.height,
      required this.preferOri,
      this.padding,
      this.margin,
      this.decoration,
      this.textStyle});
}


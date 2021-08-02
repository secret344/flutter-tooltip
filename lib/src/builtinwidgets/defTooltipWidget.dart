import 'package:flutter/widgets.dart';

import '../../metooltip.dart';

class DefTooltipWidget extends TooltipBase {
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
  DefTooltipWidget(
      {Key? key,
      required this.message,
      required this.height,
      this.triangleColor,
      this.padding,
      bool? ignorePointer,
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
      : ignorePointer = ignorePointer ?? false,
        super(
            key: key,
            message: message,
            height: height,
            triangleColor: triangleColor,
            padding: padding,
            margin: margin,
            decoration: decoration,
            textStyle: textStyle,
            target: target,
            ignorePointer: ignorePointer,
            allOffset: allOffset,
            preferOri: preferOri,
            entry: entry,
            targetSize: targetSize,
            animation: animation,
            customDismiss: customDismiss);

  @override
  Widget getDefaultComputed(Animation<double>? animation) => TooltipDefault(
        message: message,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        textStyle: textStyle,
      );

  @override
  Widget customTipPainter() {
    return super.customTipPainter();
  }

  @override
  void clickTooltip(customDismiss) {
    customDismiss();
  }
}

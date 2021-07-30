import 'package:flutter/widgets.dart';

import '../metooltip.dart';

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

abstract class SortTooltipWidget {
  @protected
  Widget getDefaultComputed(Animation<double>? animation);

  @protected
  Widget customTipPainter();

  Widget getDefaultTooltip(
      PreferOrientation preferOri, Animation<double>? animation) {
    Widget defComputed = getDefaultComputed(animation);
    Widget result;
    Widget tipPainter = customTipPainter();

    /// CustomSingleChildLayout可以获取父组件和子组件的布局区域。并可以对子组件进行盒约束及偏移定位。一句话来说用于排布一个组件
    switch (preferOri) {
      case PreferOrientation.right:
        result = Row(mainAxisSize: MainAxisSize.min, children: [
          tipPainter,
          Flexible(
            fit: FlexFit.loose,
            child: defComputed,
          )
        ]);
        break;
      case PreferOrientation.left:
        result = Row(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            fit: FlexFit.loose,
            child: defComputed,
          ),
          tipPainter,
        ]);
        break;
      case PreferOrientation.down:
        result = Column(mainAxisSize: MainAxisSize.min, children: [
          tipPainter,
          defComputed,
        ]);
        break;
      default:
        result = Column(mainAxisSize: MainAxisSize.min, children: [
          defComputed,
          tipPainter,
        ]);
    }
    return result;
  }
}

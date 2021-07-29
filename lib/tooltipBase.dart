import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:metooltip/types.dart';

abstract class TooltipBase extends StatefulWidget {
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
  TooltipBase(
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
      : ignorePointer = ignorePointer ?? false,
        super(key: key);

  @override
  _TooltipBaseState createState() => _TooltipBaseState();

  /// 你可以根据preferOri参数返回合适的Widget
  /// You can return the appropriate widget based on the preferOri parameter
  @protected
  Widget getDefaultComputed({
    required PreferOrientation preferOri,
    required String message,
    required double height,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    TextStyle? textStyle,
  });

  /// Custom tooltip edge widgets.
  /// eg：The default triangle around the edge of the tooltip.
  @protected
  CustomPaint customTipPainter(PreferOrientation preferOri);

  /// Click on the tooltip event
  @protected
  void clickTooltip(Function customDismiss);
}

class _TooltipBaseState extends State<TooltipBase> {
  double arrowHeight = 10;
  @override
  Widget build(BuildContext context) {
    double customVerticalOffset =
        math.max(widget.allOffset - arrowHeight, arrowHeight);
    Widget defComputed = widget.getDefaultComputed(
      preferOri: widget.preferOri,
      message: widget.message,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      decoration: widget.decoration,
      textStyle: widget.textStyle,
    );
    Widget result;
    Widget tipPainter = widget.customTipPainter(widget.preferOri);

    /// CustomSingleChildLayout可以获取父组件和子组件的布局区域。并可以对子组件进行盒约束及偏移定位。一句话来说用于排布一个组件
    switch (widget.preferOri) {
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
      case PreferOrientation.bottom:
        customVerticalOffset = math.max(widget.allOffset, arrowHeight);
        result = Column(mainAxisSize: MainAxisSize.min, children: [
          tipPainter,
          defComputed,
        ]);
        break;
      default:
        customVerticalOffset = math.max(widget.allOffset, arrowHeight);
        result = Column(mainAxisSize: MainAxisSize.min, children: [
          defComputed,
          tipPainter,
        ]);
    }

    return Positioned.fill(
        // 切断 super.hitTest
        child: IgnorePointer(
            ignoring: widget.ignorePointer,
            child: CustomSingleChildLayout(
                delegate: _TooltipPositionDelegate(
                    target: widget.target,
                    allOffset: customVerticalOffset,
                    preferOri: widget.preferOri,
                    targetSize: widget.targetSize),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    widget.clickTooltip(widget.customDismiss);
                  },
                  child: FadeTransition(
                    opacity: widget.animation,
                    child: result,
                  ),
                ))));
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  final Offset target;
  final double allOffset;
  final PreferOrientation preferOri;
  final Size targetSize;
  _TooltipPositionDelegate(
      {required this.target,
      required this.allOffset,
      required this.preferOri,
      required this.targetSize})
      : assert(target != null),
        assert(allOffset != null),
        assert(preferOri != null);

  /// 约束限制子控件大小
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    switch (preferOri) {
      case PreferOrientation.top:
      case PreferOrientation.bottom:
        return positionDependentBox(
          size: size,
          childSize: childSize,
          target: target,
          verticalOffset: allOffset,
          preferBelow: preferOri == PreferOrientation.bottom ? true : false,
        );
      default:
        return customHorizontalPositionDependentBox(
            size: size,
            childSize: childSize,
            target: target,
            horizontalOffset: allOffset,
            preferOri: preferOri);
    }
  }

  /// 是否需要重新布局
  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        allOffset != oldDelegate.allOffset ||
        preferOri != oldDelegate.preferOri;
  }
}

// Get Tooltip Horizontal Offset
Offset customHorizontalPositionDependentBox({
  required Size size, // 父组件的大小
  required Size childSize, // 子组件的大小
  required Offset target, // 目标节点中心偏移坐标
  required PreferOrientation preferOri, // 方向
  double horizontalOffset = 0.0, // 自定义水平偏移量
  double margin = 10.0, // 边距
}) {
  final bool fitsRight =
      target.dx + horizontalOffset + childSize.width <= size.width - margin;
  final bool fitsLeft =
      target.dx - horizontalOffset - childSize.width >= margin;

  final bool tooltipRight = preferOri == PreferOrientation.right
      ? fitsRight || !fitsLeft
      : !(fitsLeft || !fitsRight);
  double x;
  if (tooltipRight)
    x = math.min(
        target.dx + horizontalOffset, size.width - childSize.width - margin);
  else
    x = math.max(target.dx - horizontalOffset - childSize.width, margin);

  double y;
  if (size.height - margin * 2.0 < childSize.height) {
    y = (size.height - childSize.height) / 2.0;
  } else {
    final double normalizedTargetY =
        target.dy.clamp(margin, size.height - margin);
    final double edge = margin + childSize.height / 2.0;
    if (normalizedTargetY < edge) {
      y = margin;
    } else if (normalizedTargetY > size.height - edge) {
      y = size.height - margin - childSize.height;
    } else {
      y = normalizedTargetY - childSize.height / 2.0;
    }
  }
  return Offset(x, y);
}

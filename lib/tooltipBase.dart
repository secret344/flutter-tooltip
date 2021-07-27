import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:metooltip/types.dart';

import 'default.dart';

abstract class TooltipBase extends StatefulWidget {
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
  TooltipBase(
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
      : super(key: key);

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

  @protected
  CustomPaint getTipPainter(PreferOrientation preferOri, Color? triangleColor);
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
    Widget tipPainter =
        widget.getTipPainter(widget.preferOri, widget.triangleColor);

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

    return CustomSingleChildLayout(
        delegate: _TooltipPositionDelegate(
            target: widget.target,
            allOffset: customVerticalOffset,
            preferOri: widget.preferOri,
            targetSize: widget.targetSize),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            dismiss(widget.customDismiss);
          },
          child: result,
        ));
  }

  @mustCallSuper
  void dismiss(Function customDismiss) {
    customDismiss();
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
    print(childSize);
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
        return customParallelPositionDependentBox(
            size: size,
            childSize: childSize,
            target: target,
            levelOffset: allOffset,
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

Offset customParallelPositionDependentBox({
  required Size size, // 父组件的大小
  required Size childSize, // 子组件的大小
  required Offset target, // 目标节点中心偏移坐标
  required PreferOrientation preferOri, // 方向
  double levelOffset = 0.0, // 自定义垂直偏移量
  double margin = 10.0, // 边距
}) {
  assert(size != null);
  assert(childSize != null);
  assert(target != null);
  assert(levelOffset != null);
  assert(preferOri != null);
  assert(margin != null);

  final bool fitsRight =
      target.dx + levelOffset + childSize.width <= size.width - margin;
  final bool fitsLeft = target.dx - levelOffset - childSize.width >= margin;

  final bool tooltipRight = preferOri == PreferOrientation.right
      ? fitsRight || !fitsLeft
      : !(fitsLeft || !fitsRight);
  double x;
  if (tooltipRight)
    x = math.min(
        target.dx + levelOffset, size.width - childSize.width - margin);
  else
    x = math.max(target.dx - levelOffset - childSize.width, margin);

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

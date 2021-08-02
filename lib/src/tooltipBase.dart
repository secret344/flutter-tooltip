import 'package:flutter/widgets.dart';

import 'defaultWidget.dart';
import 'types.dart';
import 'utils.dart';

/// If you need to customize Tooltip,
/// use the tooltipChild parameter with the value of a class that inherits from TooltipBase (configure it according to your needs).
///
/// Reference example: example/example-2 ; example/example-3
abstract class TooltipBase extends StatefulWidget with SortTooltipWidget {
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

  /// 你可以根据preferOri参数返回合适的Widget.
  ///
  /// You can return the appropriate widget based on the preferOri parameter
  @protected
  Widget getDefaultComputed(Animation<double>? animation);

  /// Custom tooltip edge widgets.
  ///
  /// eg：The default triangle around the edge of the tooltip.
  Widget customTipPainter() {
    return CustomPaint(
        size: Size(15.0, 10),
        painter:
            DefTrianglePainter(preferSite: preferOri, color: triangleColor));
  }

  /// Click on the tooltip event
  @protected
  void clickTooltip(Function customDismiss);

  /// Customized transition animation
  Widget getCustomAnimation({required Animation<double> animation}) {
    return FadeTransition(
      opacity: animation,
      // This will call getDefaultComputed and pass animation as an argument.
      child: getDefaultTooltip(preferOri, animation),
    );
  }
}

class _TooltipBaseState extends State<TooltipBase> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        // 切断 super.hitTest
        child: IgnorePointer(
            ignoring: widget.ignorePointer,
            child: CustomSingleChildLayout(
                delegate: _TooltipPositionDelegate(
                    target: widget.target,
                    allOffset: widget.allOffset,
                    preferOri: widget.preferOri,
                    targetSize: widget.targetSize),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    widget.clickTooltip(widget.customDismiss);
                  },
                  child: widget.getCustomAnimation(animation: widget.animation),
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
      required this.targetSize});

  /// 约束限制子控件大小
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  /// TODO: does it need to be configurable?
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    switch (preferOri) {
      case PreferOrientation.up:
      case PreferOrientation.down:
        // Use flutter's default calculation
        return positionDependentBox(
          size: size,
          childSize: childSize,
          target: target,
          verticalOffset: allOffset,
          preferBelow: preferOri == PreferOrientation.down ? true : false,
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

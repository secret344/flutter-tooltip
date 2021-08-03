import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

import 'builtinwidgets/defTooltipWidget.dart';
import 'tooltipBase.dart';
import 'types.dart';

/// Expose the widget key
GlobalKey<_MeTooltipState> meUiTooltipKey = GlobalKey();

/// If you do not understand the meaning of these parameters, please try it yourself, or see the example.
///
/// Basic api
/// Usage examples:
///
/// MeTooltip(
///   message: "This is a right tooltip",
///   child: Text("right tooltip"),
///   allOffset: 50,
///   preferOri: PreferOrientation.right,
/// ),
class MeTooltip extends StatefulWidget {
  /// Tip box target widget
  final Widget? child;

  /// Custom Tip Box Widget
  final TooltipBase Function(DefTooltipType)? tooltipChild;

  /// Tip Message
  final String? message;

  /// Tip Box Offset
  final double? allOffset;

  /// Tip box orientation
  final PreferOrientation? preferOri;

  /// Tip box height
  final double? height;

  /// Tip box outer margin
  final EdgeInsetsGeometry? margin;

  /// Margin inside the prompt box
  final EdgeInsetsGeometry? padding;
  final bool? excludeFromSemantics;

  /// Tip box text style
  final TextStyle? textStyle;

  /// Tip box background style
  final BoxDecoration? decoration;

  /// Cue box triangle background color
  final Color? triangleColor;

  /// Close mouse events
  final bool openMouseEvent;

  final Duration? waitDuration;

  final Duration? showDuration;

  /// hitTest
  final bool? ignorePointer;
  const MeTooltip(
      {Key? key,
      this.child,
      this.tooltipChild,
      this.triangleColor,
      this.ignorePointer,
      this.message,
      this.allOffset,
      this.preferOri,
      this.height,
      this.margin,
      this.padding,
      this.excludeFromSemantics,
      this.decoration,
      this.textStyle,
      this.openMouseEvent = true,
      this.showDuration,
      this.waitDuration,
      bool? isShow})
      : super(key: key);

  @override
  _MeTooltipState createState() => _MeTooltipState();
}

class _MeTooltipState extends State<MeTooltip>
    with SingleTickerProviderStateMixin {
  static const double _defaultVerticalOffset = 24.0;
  static const EdgeInsetsGeometry _defaultMargin = EdgeInsets.zero;
  static const Duration _fadeInDuration = Duration(milliseconds: 150);
  static const Duration _fadeOutDuration = Duration(milliseconds: 75);
  static const Duration _defaultShowDuration = Duration(milliseconds: 1500);
  static const Duration _defaultWaitDuration = Duration.zero;

  late double height;
  late EdgeInsetsGeometry padding;
  late EdgeInsetsGeometry margin;
  late Decoration decoration;
  late TextStyle textStyle;
  late double verticalOffset;
  late PreferOrientation preferLMR;
  late bool excludeFromSemantics;
  late bool _mouseIsConnected;
  OverlayEntry? _entry;
  Timer? _hideTimer;
  Timer? _showTimer;
  late Duration showDuration;
  late Duration waitDuration;
  late AnimationController _controller;
  late Color triangleColor;
  bool _longPressActivated = false;
  @override
  void initState() {
    super.initState();
    _mouseIsConnected = RendererBinding.instance!.mouseTracker.mouseIsConnected;
    // 默认动画
    _controller = AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this, // ticker
    )..addStatusListener(_handleStatusChanged);

    /**
     * RendererBinding 是渲染树和Flutter引擎的胶水层
     * 负责管理帧重绘、窗口尺寸和渲染相关参数变化的监听。
     */
    RendererBinding.instance!.mouseTracker
        .addListener(_handleMouseTrackerChange);
    // 全局指针事件 当点击其他地方时，隐藏。
    // Flutter中处理手势的抽象服务类，继承自BindingBase类
    GestureBinding.instance!.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  @override
  void deactivate() {
    if (_entry != null) {
      _hideTooltip(immediately: true);
    }
    _showTimer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    GestureBinding.instance!.pointerRouter
        .removeGlobalRoute(_handlePointerEvent);
    RendererBinding.instance!.mouseTracker
        .removeListener(_handleMouseTrackerChange);
    if (_entry != null) _removeEntry();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    verticalOffset = widget.allOffset ?? _defaultVerticalOffset;
    preferLMR = widget.preferOri ?? PreferOrientation.up;
    height = widget.height ?? _getDefaultTooltipHeight();
    margin = widget.margin ?? _defaultMargin;
    padding = widget.padding ?? _getDefaultPadding();
    excludeFromSemantics = widget.excludeFromSemantics ?? false;

    final TextStyle defaultTextStyle; // 默认字体样式
    final BoxDecoration defaultDecoration; // 默认Container child后的背景
    final Color defaultTriangleColor;
    final ThemeData theme = Theme.of(context);
    // dark模式
    if (theme.brightness == Brightness.dark) {
      defaultTextStyle = theme.textTheme.bodyText2!.copyWith(
        color: Colors.black,
        fontSize: _getDefaultFontSize(),
      );
      defaultDecoration = BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      );
      defaultTriangleColor = Colors.white.withOpacity(0.9);
    } else {
      defaultTextStyle = theme.textTheme.bodyText2!.copyWith(
        color: Colors.white,
        fontSize: _getDefaultFontSize(),
      );
      defaultDecoration = BoxDecoration(
        color: Colors.grey[700]!.withOpacity(0.9),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      );
      defaultTriangleColor = Colors.grey[700]!.withOpacity(0.9);
    }

    decoration = widget.decoration ?? defaultDecoration;
    textStyle = widget.textStyle ?? defaultTextStyle;
    triangleColor = widget.triangleColor ?? defaultTriangleColor;
    waitDuration = widget.waitDuration ?? _defaultWaitDuration;
    showDuration = widget.showDuration ?? _defaultShowDuration;
    Widget result = GestureDetector(
      child: Semantics(
        child: widget.child,
        label: excludeFromSemantics ? null : widget.message,
      ),
      excludeFromSemantics: true,
      behavior: HitTestBehavior.opaque,
      onLongPress: _handleLongPress,
      onTap: _showTooltip,
    );

    if (_mouseIsConnected && widget.openMouseEvent) {
      result = MouseRegion(
        onEnter: (PointerEnterEvent event) => _showTooltip(),
        onExit: (PointerExitEvent event) => _hideTooltip(),
        child: result,
      );
    }

    return result;
  }

  /// 长按事件
  void _handleLongPress() {
    _longPressActivated = true;
    final bool tooltipCreated = _showTooltip(immediately: true)!;
    if (tooltipCreated) Feedback.forLongPress(context);
  }

  bool? _showTooltip({bool immediately = false}) {
    // 清空长按_hideTimer上次的动画
    _hideTimer?.cancel();
    _hideTimer = null;
    if (immediately) {
      // 立即执行 需要清除之前的启动动画
      _showTimer?.cancel();
      _showTimer = null;
      return _ensureTooltipVisible();
    }
    // 延迟显示
    _showTimer = Timer(waitDuration, _ensureTooltipVisible);
  }

  void _hideTooltip({bool immediately = false}) {
    if (immediately) {
      return _removeEntry();
    }
    // 清空_showTimer的动画 既然要隐藏就彻底清除
    _showTimer?.cancel();
    _showTimer = null;
    if (_longPressActivated) {
      _hideTimer = Timer(showDuration, _controller.reverse);
    } else {
      _controller.reverse();
    }
    _longPressActivated = false;
  }

  void _removeEntry() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    _entry?.remove();
    _entry = null;
  }

  bool _ensureTooltipVisible() {
    if (_entry != null) {
      // 如果已经存在 立即显示
      _controller.forward();
      return false;
    }
    _createNewEntry();
    _controller.forward();
    return true;
  }

  void _createNewEntry() {
    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    )!;
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Size targetSize = box.size;
    // localToGlobal 指的是将某个容器内的某一个点转换成全局坐标
    // 获取中心位置全局坐标
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );
    _entry = OverlayEntry(builder: (BuildContext context) {
      return widget.tooltipChild != null
          ? widget.tooltipChild!(DefTooltipType(
              message: widget.message ?? "",
              height: height,
              padding: padding,
              margin: margin,
              entry: _entry!,
              decoration: decoration,
              textStyle: textStyle,
              triangleColor: triangleColor,
              animation: CurvedAnimation(
                parent: _controller,
                curve: Curves.fastOutSlowIn,
              ),
              target: target,
              allOffset: verticalOffset,
              preferOri: preferLMR,
              targetSize: targetSize,
              customDismiss: _hideTooltip))
          : Directionality(
              textDirection: Directionality.of(context),
              child: DefTooltipWidget(
                  message: widget.message ?? "",
                  height: height,
                  padding: padding,
                  margin: margin,
                  entry: _entry!,
                  decoration: decoration,
                  textStyle: textStyle,
                  triangleColor: triangleColor,
                  ignorePointer: widget.ignorePointer,
                  animation: CurvedAnimation(
                    parent: _controller,
                    curve: Curves.fastOutSlowIn,
                  ),
                  target: target,
                  allOffset: verticalOffset,
                  preferOri: preferLMR,
                  targetSize: targetSize,
                  customDismiss: _hideTooltip),
            );
    });
    overlayState.insert(_entry!);
    SemanticsService.tooltip(widget.message ?? "");
  }

  _handleMouseTrackerChange() {
    // [State]对象当前是否在树中。
    if (!mounted) {
      return;
    }
    final bool mouseIsConnected =
        RendererBinding.instance!.mouseTracker.mouseIsConnected;
    if (_mouseIsConnected != mouseIsConnected) {
      setState(() {
        _mouseIsConnected = mouseIsConnected;
      });
    }
  }

  _handlePointerEvent(PointerEvent event) {
    if (_entry == null || !widget.openMouseEvent) {
      return;
    }
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _hideTooltip();
    } else if (event is PointerDownEvent) {
      _hideTooltip();
    }
  }

  _handleStatusChanged(AnimationStatus state) {
    if (state == AnimationStatus.dismissed) {
      // 动画结束删除实体 长按持久显示的清理
      _hideTooltip(immediately: true);
    }
  }

  double _getDefaultTooltipHeight() {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return 24.0;
      default:
        return 32.0;
    }
  }

  EdgeInsets _getDefaultPadding() {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const EdgeInsets.symmetric(horizontal: 8.0);
      default:
        return const EdgeInsets.symmetric(horizontal: 16.0);
    }
  }

  double _getDefaultFontSize() {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return 10.0;
      default:
        return 14.0;
    }
  }
}

import 'dart:ui';
import 'dart:math' as math;

import 'types.dart';

// Get Tooltip Horizontal Offset
Offset customHorizontalPositionDependentBox({
  required Size size,
  required Size childSize,
  required Offset target,
  required PreferOrientation preferOri,
  double horizontalOffset = 0.0,
  double margin = 10.0,
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

import 'dart:math';

import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_typings.dart';
import 'package:touchable/touchable.dart';

EdgeStyle _defaultStyleBuilder(Edge edge) {
  return EdgeStyle(arrowType: edge.arrowType);
}

class LinesPainter extends CustomPainter {
  final List<Edge> edges;
  final BuildContext context;
  final EdgeStyleBuilder? styleBuilder;
  final EdgePathBuilder? pathBuilder;

  final GestureBackgroundTapCallback? onCanvasTap;
  final GestureEdgeTapDownCallback? onEdgeTapDown;
  final PaintingStyle? edgePaintStyleForTouch;

  final GestureEdgeTapUpCallback? onEdgeTapUp;
  final GestureEdgeLongPressStartCallback? onEdgeLongPressStart;

  final GestureEdgeLongPressEndCallback? onEdgeLongPressEnd;
  final GestureEdgeLongPressMoveUpdateCallback? onEdgeLongPressMoveUpdate;

  final GestureEdgeForcePressStartCallback? onEdgeForcePressStart;
  final GestureEdgeForcePressEndCallback? onEdgeForcePressEnd;

  final GestureEdgeForcePressPeakCallback? onEdgeForcePressPeak;
  final GestureEdgeForcePressUpdateCallback? onEdgeForcePressUpdate;

  final GestureEdgeTapDownCallback? onEdgeSecondaryTapDown;

  final GestureEdgeTapUpCallback? onEdgeSecondaryTapUp;

  const LinesPainter(
    this.context,
    this.edges, {
    this.onCanvasTap,
    this.onEdgeTapDown,
    this.edgePaintStyleForTouch,
    this.onEdgeTapUp,
    this.onEdgeLongPressStart,
    this.onEdgeLongPressEnd,
    this.onEdgeLongPressMoveUpdate,
    this.onEdgeForcePressStart,
    this.onEdgeForcePressEnd,
    this.onEdgeForcePressPeak,
    this.onEdgeForcePressUpdate,
    this.onEdgeSecondaryTapDown,
    this.onEdgeSecondaryTapUp,
    this.styleBuilder,
    this.pathBuilder,
  });

  bool areNoListenersDefined() {
    return onEdgeTapDown == null &&
        onEdgeTapUp == null &&
        onEdgeLongPressStart == null &&
        onEdgeLongPressEnd == null &&
        onEdgeLongPressMoveUpdate == null &&
        onEdgeForcePressStart == null &&
        onEdgeForcePressEnd == null &&
        onEdgeForcePressPeak == null &&
        onEdgeForcePressUpdate == null &&
        onEdgeSecondaryTapDown == null &&
        onEdgeSecondaryTapUp == null;
  }

  @override
  void paint(Canvas c, Size size) {
    var canvas = TouchyCanvas(context, c);
    var background = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
        background,
        onTapDown: onCanvasTap != null ? onCanvasTap : null);
    List<Edge> _state = edges;
    _state.forEach((e) {
      final points = e.points.reversed.toList();
      final style =
          styleBuilder == null ? _defaultStyleBuilder(e) : styleBuilder!(e);
      final path = pathBuilder == null
          ? _defaultEdgePathBuilder(
              e.from.toInput(), e.to.toInput(), points, style)
          : pathBuilder!(e.from.toInput(), e.to.toInput(), points, style);
      path.close();
      final paint = style.linePaint;
      c.drawPath(
        path,
        paint,
      );

      if (areNoListenersDefined()) return;

      // add wider transparent lines with made off hit dots on top to track gestures
      final gestureHitRadius = max(style.linePaint.strokeWidth, 10.0);
      var p = style.linePaint
        ..color = Colors.transparent
        ..style = PaintingStyle.fill
        ..strokeWidth = gestureHitRadius;

      var pp = pathBuilder != null
          ? pathBuilder!(e.from.toInput(), e.to.toInput(), points, style)
          : _getPathFromPoints(e.from.toInput(), e.to.toInput(), points, style);
      pp = _createHitPath(pp, gestureHitRadius);

      canvas.drawPath(pp, p,
          paintStyleForTouch: PaintingStyle.fill,
          onTapDown: onEdgeTapDown != null
              ? (details) => onEdgeTapDown!(details, e)
              : null,
          onTapUp: onEdgeTapUp != null
              ? (details) => onEdgeTapUp!(details, e)
              : null,
          onLongPressStart: onEdgeLongPressStart != null
              ? (details) => onEdgeLongPressStart!(details, e)
              : null,
          onLongPressEnd: onEdgeLongPressEnd != null
              ? (details) => onEdgeLongPressEnd!(details, e)
              : null,
          onLongPressMoveUpdate: onEdgeLongPressMoveUpdate != null
              ? (details) => onEdgeLongPressMoveUpdate!(details, e)
              : null,
          onForcePressStart: onEdgeForcePressStart != null
              ? (details) => onEdgeForcePressStart!(details, e)
              : null,
          onForcePressEnd: onEdgeForcePressEnd != null
              ? (details) => onEdgeForcePressEnd!(details, e)
              : null,
          onForcePressPeak: onEdgeForcePressPeak != null
              ? (details) => onEdgeForcePressPeak!(details, e)
              : null,
          onForcePressUpdate: onEdgeForcePressUpdate != null
              ? (details) => onEdgeForcePressUpdate!(details, e)
              : null,
          onSecondaryTapDown: onEdgeSecondaryTapDown != null
              ? (details) => onEdgeSecondaryTapDown!(details, e)
              : null,
          onSecondaryTapUp: onEdgeSecondaryTapUp != null
              ? (details) => onEdgeSecondaryTapUp!(details, e)
              : null);
    });
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return true;
  }
}

Path _getPathFromPoints(
    NodeInput from, NodeInput to, List<List<double>> points, EdgeStyle style) {
  var path = Path();

  List<Offset> offsetPoints = points.map((p) => Offset(p[0], p[1])).toList();
  List<Offset> smoothPoints = _smoothCorners(offsetPoints, style.borderRadius);

  path.moveTo(smoothPoints.first.dx, smoothPoints.first.dy);
  for (int i = 1; i < smoothPoints.length; i++) {
    if (smoothPoints[i] is ArcPoint) {
      ArcPoint arcPoint = smoothPoints[i] as ArcPoint;
      path.arcToPoint(
        arcPoint.end,
        radius: Radius.circular(arcPoint.radius),
        clockwise: arcPoint.clockwise,
      );
    } else {
      path.lineTo(smoothPoints[i].dx, smoothPoints[i].dy);
    }
  }
  return path;
}

Path _defaultEdgePathBuilder(
    NodeInput from, NodeInput to, List<List<double>> points, EdgeStyle style) {
  Path path = _getPathFromPoints(from, to, points, style);
  Path styledPath = _applyLineStyle(path, style.lineStyle, style.dashLength,
      style.gapLength, style.dotLength);

  if (style.arrowType == EdgeArrowType.none) {
    return styledPath;
  }
  return ArrowPath.make(
      path: styledPath,
      isDoubleSided: style.arrowType == EdgeArrowType.both,
      tipLength: style.tipLength,
      tipAngle: style.tipAngle);
}

List<Offset> _smoothCorners(List<Offset> points, double radius) {
  if (points.length < 3 || radius <= 0) return points;

  List<Offset> smoothPoints = [];
  smoothPoints.add(points.first);

  for (int i = 1; i < points.length - 1; i++) {
    Offset prev = points[i - 1];
    Offset curr = points[i];
    Offset next = points[i + 1];

    Offset toPrev = prev - curr;
    Offset toNext = next - curr;

    double angle = _angleBetween(toPrev, toNext);

    double actualRadius =
        min(radius, min(toPrev.distance / 2, toNext.distance / 2));

    Offset toPrevNorm = toPrev / toPrev.distance;
    Offset toNextNorm = toNext / toNext.distance;

    Offset cornerStart = curr + toPrevNorm * actualRadius;
    Offset cornerEnd = curr + toNextNorm * actualRadius;

    smoothPoints.add(cornerStart);
    smoothPoints.add(ArcPoint(cornerEnd, actualRadius, angle < 0));
  }

  smoothPoints.add(points.last);
  return smoothPoints;
}

double _angleBetween(Offset v1, Offset v2) {
  return atan2(v1.dx * v2.dy - v1.dy * v2.dx, v1.dx * v2.dx + v1.dy * v2.dy);
}

class ArcPoint extends Offset {
  final Offset end;
  final double radius;
  final bool clockwise;

  ArcPoint(this.end, this.radius, this.clockwise) : super(end.dx, end.dy);
}

Path _applyLineStyle(Path originalPath, LineStyle style, double dashLength,
    double gapLength, double dotLength) {
  if (style == LineStyle.solid) {
    return originalPath;
  }
  var path = Path();
  var metrics = originalPath.computeMetrics();

  for (var metric in metrics) {
    var length = metric.length;
    var distance = 0.0;

    while (distance < length) {
      var tangent = metric.getTangentForOffset(distance)!;
      var start = tangent.position;
      var remainingLength = length - distance;

      switch (style) {
        case LineStyle.solid:
          return originalPath;
        case LineStyle.dashed:
          var dashEnd = metric
              .getTangentForOffset(
                  distance + dashLength.clamp(0, remainingLength))!
              .position;
          path.moveTo(start.dx, start.dy);
          path.lineTo(dashEnd.dx, dashEnd.dy);
          distance += dashLength + gapLength;
          break;
        case LineStyle.dotted:
          // draw last line at the and of the line to make arrows look ok
          if (distance + dotLength + gapLength >= length) {
            var dashEnd = metric
                .getTangentForOffset(
                    distance + dashLength.clamp(0, remainingLength))!
                .position;
            path.moveTo(start.dx, start.dy);
            path.lineTo(dashEnd.dx, dashEnd.dy);
            distance += dashLength + gapLength;
            break;
          }
          path.addOval(Rect.fromCircle(center: start, radius: dotLength / 2));
          distance += dotLength + gapLength;
          break;
        case LineStyle.dashDotted:
          var dashEnd = metric
              .getTangentForOffset(
                  distance + dashLength.clamp(0, remainingLength))!
              .position;
          path.moveTo(start.dx, start.dy);
          path.lineTo(dashEnd.dx, dashEnd.dy);
          distance += dashLength + gapLength;

          if (distance < length) {
            var dotPosition = metric.getTangentForOffset(distance)!.position;
            path.addOval(
                Rect.fromCircle(center: dotPosition, radius: dotLength / 2));
            distance += dotLength + gapLength;
          }
          break;
      }
    }
  }

  return path;
}

Path _createHitPath(Path inputPath, double hitWidth) {
  final hitPath = Path();
  final metric = inputPath.computeMetrics().first;
  final halfWidth = hitWidth / 2;

  var distance = 0.0;
  final increment = 5.0;

  while (distance < metric.length) {
    final tangent = metric.getTangentForOffset(distance)!;
    final normal = Offset(-tangent.vector.dy, tangent.vector.dx);

    final outerPoint = tangent.position + normal * halfWidth;

    if (distance == 0) {
      hitPath.moveTo(outerPoint.dx, outerPoint.dy);
    } else {
      hitPath.lineTo(outerPoint.dx, outerPoint.dy);
    }

    distance += increment;
  }

  distance = metric.length;
  while (distance > 0) {
    final tangent = metric.getTangentForOffset(distance)!;
    final normal = Offset(-tangent.vector.dy, tangent.vector.dx);

    final innerPoint = tangent.position - normal * halfWidth;

    hitPath.lineTo(innerPoint.dx, innerPoint.dy);

    distance -= increment;
  }
  hitPath.close();
  return hitPath;
}

import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_typings.dart';
import 'package:touchable/touchable.dart';

Paint _defaultPaintBuilder(Edge edge) {
  return Paint()
    ..color = Color(0xFF000000)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 2;
}

class LinesPainter extends CustomPainter {
  final List<Edge> edges;
  final BuildContext context;
  final EdgePaintBuilder? paintBuilder;
  final EdgePathBuilder? pathBuilder;
  final double tipLength;
  final double tipAngle;

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

  Path _defaultEdgePathBuilder(NodeInput from, NodeInput to,
      List<List<double>> points, EdgeArrowType arrowType) {
    var path = Path();
    path.moveTo(points[0][0], points[0][1]);
    points.sublist(1).forEach((p) => path.lineTo(p[0], p[1]));
    if (arrowType == EdgeArrowType.none) {
      return path;
    }
    return ArrowPath.make(
        path: path,
        isDoubleSided: arrowType == EdgeArrowType.both,
        tipLength: tipLength,
        tipAngle: tipAngle);
  }

  const LinesPainter(
    this.context,
    this.edges, {
    required this.tipLength,
    required this.tipAngle,
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
    this.paintBuilder,
    this.pathBuilder,
  });

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
      var points = e.points.reversed.toList();
      var path = pathBuilder == null
          ? _defaultEdgePathBuilder(
              e.from.toInput(), e.to.toInput(), points, e.arrowType)
          : pathBuilder!(e.from.toInput(), e.to.toInput(), points, e.arrowType);
      final paint =
          paintBuilder == null ? _defaultPaintBuilder(e) : paintBuilder!(e);
      c.drawPath(
        path,
        paint,
      );
      // add transparent wider lines on top to track gestures
      for (int i = 1; i < points.length; i++) {
        var p = Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = paint.strokeWidth * 3;
        canvas.drawLine(
          Offset(points[i - 1][0], points[i - 1][1]),
          Offset(points[i][0], points[i][1]),
          p,
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
              : null,
        );
      }
    });
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return true;
  }
}

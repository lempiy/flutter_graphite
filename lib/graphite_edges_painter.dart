import 'dart:math';

import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:touchable/touchable.dart';

class Edge {
  final List<List<double>> points;
  final MatrixNode from;
  final MatrixNode to;
  final EdgeArrowType arrowType;

  Edge(this.points, this.from, this.to, this.arrowType);
}

enum Direction { top, bottom, left, right }

Direction getXVertexDirection(int x1, int x2) {
  return x1 < x2 ? Direction.right : Direction.left;
}

Direction getYVertexDirection(int y1, int y2) {
  return y1 < y2 ? Direction.bottom : Direction.top;
}

Direction getVectorDirection(int x1, int y1, int x2, int y2) {
  return y1 == y2 ? getXVertexDirection(x1, x2) : getYVertexDirection(y1, y2);
}

double getMargin(AnchorMargin margin, double distance) {
  if (margin == AnchorMargin.none) return 0;
  return margin == AnchorMargin.start ? -distance : distance;
}

Paint _defaultPaintBuilder(Edge edge) {
  return Paint()
    ..color = Color(0xFF000000)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 2;
}

typedef EdgePaintBuilder = Paint Function(Edge edge);
typedef GestureEdgeTapDownCallback = void Function(
    TapDownDetails details, Edge edge);
typedef GestureEdgeTapUpCallback = void Function(
    TapUpDetails details, Edge edge);

typedef GestureEdgeLongPressStartCallback = void Function(
    LongPressStartDetails details, Edge edge);
typedef GestureEdgeLongPressEndCallback = void Function(
    LongPressEndDetails details, Edge edge);
typedef GestureEdgeLongPressMoveUpdateCallback = void Function(
    LongPressMoveUpdateDetails details, Edge edge);
typedef GestureEdgeForcePressStartCallback = void Function(
    ForcePressDetails details, Edge edge);
typedef GestureEdgeForcePressEndCallback = void Function(
    ForcePressDetails details, Edge edge);
typedef GestureEdgeForcePressPeakCallback = void Function(
    ForcePressDetails details, Edge edge);
typedef GestureEdgeForcePressUpdateCallback = void Function(
    ForcePressDetails details, Edge edge);
typedef GestureEdgeDragStartCallback = void Function(
    DragStartDetails details, Edge edge);
typedef GestureEdgeDragUpdateCallback = void Function(
    DragUpdateDetails details, Edge edge);
typedef GestureEdgeDragDownCallback = void Function(
    DragDownDetails details, Edge edge);

typedef EdgePathBuilder = Path Function(NodeInput income, NodeInput node,
    List<List<double>> points, EdgeArrowType arrowType);

class LinesPainter extends CustomPainter {
  final Matrix matrix;
  final Map<String, MatrixNode> matrixMap;
  final double defaultCellWidth;
  final double defaultCellHeight;
  final double cellPadding;
  final double contactEdgesDistance;
  final BuildContext context;
  final EdgePaintBuilder? paintBuilder;
  final EdgePathBuilder? pathBuilder;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;

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

  List<Edge> collectEdges(MatrixNode node, Map<String, MatrixNode> edges) {
    return node.renderIncomes.map((i) => edges[i]).fold([],
        (List<Edge> acc, MatrixNode? income) {
      List<List<double>> points = [];
      var incomeNode = edges[income!.id];
      var startNode = node;
      var margins = getEdgeMargins(startNode, incomeNode!);
      var nodeMargin = margins[0];
      var incomeMargin = margins[1];
      var direction = getVectorDirection(
          startNode.x, startNode.y, incomeNode.x, incomeNode.y);
      var directions = pointResolversMap[direction]!;
      var from = directions[0], to = directions[1];
      final defaultCellSize =
          NodeSize(width: defaultCellWidth, height: defaultCellHeight);
      List<double> startPoint = getPointWithResolver(
          from,
          defaultCellSize,
          cellPadding,
          contactEdgesDistance,
          startNode,
          nodeMargin,
          orientation);
      points.add(startPoint);
      while (incomeNode!.isAnchor) {
        margins = getEdgeMargins(startNode, incomeNode);
        nodeMargin = margins[0];
        incomeMargin = margins[1];
        direction = getVectorDirection(
            startNode.x, startNode.y, incomeNode.x, incomeNode.y);
        directions = pointResolversMap[direction]!;
        from = directions[0];
        to = directions[1];
        points.add(getPointWithResolver(to, defaultCellSize, cellPadding,
            contactEdgesDistance, incomeNode, incomeMargin, orientation));
        startNode = incomeNode;
        incomeNode = edges[incomeNode.renderIncomes[0]];
      }
      margins = getEdgeMargins(startNode, incomeNode);
      nodeMargin = margins[0];
      incomeMargin = margins[1];
      direction = getVectorDirection(
          startNode.x, startNode.y, incomeNode.x, incomeNode.y);
      directions = pointResolversMap[direction]!;
      from = directions[0];
      to = directions[1];
      points.add(getPointWithResolver(to, defaultCellSize, cellPadding,
          contactEdgesDistance, incomeNode, incomeMargin, orientation));
      final edgeInput = incomeNode.next.firstWhere((e) => e.outcome == node.id);
      acc.add(Edge(points, incomeNode, node, edgeInput.type));
      return acc;
    });
  }

  const LinesPainter(
    this.context,
    this.matrix,
    this.matrixMap,
    this.defaultCellWidth,
    this.defaultCellHeight,
    this.contactEdgesDistance,
    this.orientation, {
    required this.cellPadding,
    required this.tipLength,
    required this.tipAngle,
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

    List<Edge> _state = [];
    matrixMap.forEach((key, value) {
      if (value.isAnchor) return;
      _state.addAll(collectEdges(value, matrixMap));
    });
    _state.forEach((e) {
      var points = e.points.reversed.toList();
      var path = pathBuilder == null
          ? _defaultEdgePathBuilder(
              e.from.toInput(), e.to.toInput(), points, e.arrowType)
          : pathBuilder!(e.from.toInput(), e.to.toInput(), points, e.arrowType);
      final paint =
          paintBuilder == null ? _defaultPaintBuilder(e) : paintBuilder!(e);

      canvas.drawPath(
        path,
        paint,
        paintStyleForTouch: PaintingStyle.fill,
      );
      // add transparent wider lines on top to track gestures
      for (int i = 1; i < points.length; i++) {
        var p = Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = paint.strokeWidth * 3;
        canvas.drawLine(Offset(points[i - 1][0], points[i - 1][1]),
            Offset(points[i][0], points[i][1]), p,
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
      }
    });
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return true;
  }

  double _getHighestHeightInARow(int y) {
    return matrix.s[y].fold(
        0,
        (acc, node) => max(
            acc,
            (node == null || node.size == null)
                ? defaultCellHeight
                : node.size!.height));
  }

  double _getWidestWidthInAColumn(int x) {
    double acc = 0;
    for (var y = 0; y < matrix.height(); y++) {
      final node = matrix.getByCoords(x, y);
      acc = max(
          acc,
          (node == null || node.size == null)
              ? defaultCellWidth
              : node.size!.width);
    }
    return acc;
  }

  // exclusive
  double _getWidthToPoint(int x, int y, double padding) {
    double distance = 0;
    int from = 0;
    while (from != x) {
      double w = _getWidestWidthInAColumn(from);
      distance += (w + padding * 2);
      from++;
    }
    return distance;
  }

  // exclusive
  double _getHeightToPoint(int x, int y, double padding) {
    double distance = 0;
    int from = 0;
    while (from != y) {
      double h = _getHighestHeightInARow(from);
      distance += (h + padding * 2);
      from++;
    }
    return distance;
  }

  List<double> getCellCenter(
      NodeSize defaultCellSize,
      double padding,
      double cellX,
      double cellY,
      double distance,
      AnchorMargin margin,
      MatrixOrientation orientation) {
    double outset = getMargin(margin, distance);
    final cellWidth = _getWidestWidthInAColumn(cellX.floor());
    final cellHeight = _getHighestHeightInARow(cellY.floor());

    double x = _getWidthToPoint(cellX.floor(), cellY.floor(), padding) +
        (cellWidth + padding * 2) * 0.5;
    double y = _getHeightToPoint(cellX.floor(), cellY.floor(), padding) +
        (cellHeight + padding * 2) * 0.5;
    if (orientation == MatrixOrientation.Horizontal) {
      x += outset;
    } else {
      y += outset;
    }
    return [x, y];
  }

  List<double> getCellEntry(
      MatrixNode node,
      Direction direction,
      NodeSize defaultCellSize,
      double padding,
      double cellX,
      double cellY,
      double distance,
      AnchorMargin margin,
      MatrixOrientation orientation) {
    final w = _getWidestWidthInAColumn(cellX.floor());
    final h = _getHighestHeightInARow(cellY.floor());
    final cw = node.size?.width ?? defaultCellSize.width;
    final ch = node.size?.height ?? defaultCellSize.height;
    final cellHorizontalPadding = (cw != w ? padding + (w - cw) * .5 : padding);
    final cellVerticalPadding = (ch != h ? padding + (h - ch) * .5 : padding);

    switch (direction) {
      case Direction.top:
        final x = getCellCenter(defaultCellSize, padding, cellX, cellY,
            distance, margin, orientation)[0];
        final y = _getHeightToPoint(cellX.floor(), cellY.floor(), padding) +
            cellVerticalPadding;
        return [x, y];
      case Direction.bottom:
        final x = getCellCenter(defaultCellSize, padding, cellX, cellY,
            distance, margin, orientation)[0];
        final y = _getHeightToPoint(cellX.floor(), cellY.floor(), padding) +
            (ch + cellVerticalPadding);
        return [x, y];
      case Direction.right:
        final y = getCellCenter(defaultCellSize, padding, cellX, cellY,
            distance, margin, orientation)[1];
        final x = _getWidthToPoint(cellX.floor(), cellY.floor(), padding) +
            (cw + cellHorizontalPadding);
        return [x, y];
      case Direction.left:
        final y = getCellCenter(defaultCellSize, padding, cellX, cellY,
            distance, margin, orientation)[1];
        final x = _getWidthToPoint(cellX.floor(), cellY.floor(), padding) +
            cellHorizontalPadding;
        return [x, y];
    }
  }

  List<double> getPointWithResolver(
      Direction direction,
      NodeSize defaultCellSize,
      double padding,
      double distance,
      MatrixNode item,
      AnchorMargin margin,
      MatrixOrientation orientation) {
    if (item.isAnchor) {
      return getCellCenter(defaultCellSize, padding, item.x.toDouble(),
          item.y.toDouble(), distance, margin, orientation);
    } else {
      return getCellEntry(item, direction, defaultCellSize, padding,
          item.x.toDouble(), item.y.toDouble(), distance, margin, orientation);
    }
  }
}

List<AnchorMargin> getEdgeMargins(MatrixNode node, MatrixNode income) {
  if (node.isAnchor && income.isAnchor) {
    return [node.anchorMargin!, income.anchorMargin!];
  } else if (node.isAnchor) {
    return [node.anchorMargin!, node.anchorMargin!];
  } else if (income.isAnchor) {
    return [income.anchorMargin!, income.anchorMargin!];
  } else {
    return [AnchorMargin.none, AnchorMargin.none];
  }
}

List<double> applyMargin(AnchorMargin margin, List<double> point,
    double distance, MatrixOrientation orientation) {
  if (margin == AnchorMargin.none) return point;
  if (orientation == MatrixOrientation.Horizontal &&
      margin == AnchorMargin.start) return [point[0] - distance, point[1]];
  if (orientation == MatrixOrientation.Vertical && margin == AnchorMargin.start)
    return [point[0], point[1] - distance];
  if (orientation == MatrixOrientation.Horizontal && margin == AnchorMargin.end)
    return [point[0] + distance, point[1]];
  if (orientation == MatrixOrientation.Vertical && margin == AnchorMargin.end)
    return [point[0], point[1] + distance];
  return point;
}

const pointResolversMap = {
  Direction.top: [Direction.top, Direction.bottom],
  Direction.bottom: [Direction.bottom, Direction.top],
  Direction.right: [Direction.right, Direction.left],
  Direction.left: [Direction.left, Direction.right]
};

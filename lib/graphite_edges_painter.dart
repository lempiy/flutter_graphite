import 'dart:async';
import 'dart:ui';

import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:touchable/touchable.dart';

class Edge {
  final List<List<double>> points;
  final MatrixNode from;
  final MatrixNode to;

  Edge(this.points, this.from, this.to);
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

List<double> getCellCenter(
    double cellSize,
    double padding,
    double cellX,
    double cellY,
    double distance,
    AnchorMargin margin,
    MatrixOrientation orientation) {
  var outset = getMargin(margin, distance);
  var x = cellX * cellSize + cellSize * 0.5;
  var y = cellY * cellSize + cellSize * 0.5;
  if (orientation == MatrixOrientation.Horizontal) {
    x += outset;
  } else {
    y += outset;
  }
  return [x, y];
}

List<double> getCellEntry(
    Direction direction,
    double cellSize,
    double padding,
    double cellX,
    double cellY,
    double distance,
    AnchorMargin margin,
    MatrixOrientation orientation) {
  switch (direction) {
    case Direction.top:
      var x = getCellCenter(
          cellSize, padding, cellX, cellY, distance, margin, orientation)[0];
      var y = cellY * cellSize + padding;
      return [x, y];
    case Direction.bottom:
      var x = getCellCenter(
          cellSize, padding, cellX, cellY, distance, margin, orientation)[0];
      var y = cellY * cellSize + (cellSize - padding);
      return [x, y];
    case Direction.right:
      var y = getCellCenter(
          cellSize, padding, cellX, cellY, distance, margin, orientation)[1];
      var x = cellX * cellSize + (cellSize - padding);
      return [x, y];
    case Direction.left:
      var y = getCellCenter(
          cellSize, padding, cellX, cellY, distance, margin, orientation)[1];
      var x = cellX * cellSize + padding;
      return [x, y];
  }
  return [cellX, cellY];
}

List<double> getPointWithResolver(
    Direction direction,
    double cellSize,
    double padding,
    double distance,
    MatrixNode item,
    AnchorMargin margin,
    MatrixOrientation orientation) {
  if (item.isAnchor) {
    return getCellCenter(cellSize, padding, item.x.toDouble(),
        item.y.toDouble(), distance, margin, orientation);
  } else {
    return getCellEntry(direction, cellSize, padding, item.x.toDouble(),
        item.y.toDouble(), distance, margin, orientation);
  }
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

class LinesPainter extends CustomPainter {
  final Map<String, MatrixNode> matrixMap;
  final double cellWidth;
  final double cellPadding;
  final double contactEdgesDistance;
  final BuildContext context;
  final EdgePaintBuilder paintBuilder;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;

  final GestureEdgeTapDownCallback onEdgeTapDown;
  final PaintingStyle edgePaintStyleForTouch;

  final GestureEdgeTapUpCallback onEdgeTapUp;
  final GestureEdgeLongPressStartCallback onEdgeLongPressStart;

  final GestureEdgeLongPressEndCallback onEdgeLongPressEnd;
  final GestureEdgeLongPressMoveUpdateCallback onEdgeLongPressMoveUpdate;

  final GestureEdgeForcePressStartCallback onEdgeForcePressStart;
  final GestureEdgeForcePressEndCallback onEdgeForcePressEnd;

  final GestureEdgeForcePressPeakCallback onEdgeForcePressPeak;
  final GestureEdgeForcePressUpdateCallback onEdgeForcePressUpdate;

  final GestureEdgeDragStartCallback onEdgePanStart;
  final GestureEdgeDragUpdateCallback onEdgePanUpdate;

  final GestureEdgeDragDownCallback onEdgePanDown;
  final GestureEdgeTapDownCallback onEdgeSecondaryTapDown;

  final GestureEdgeTapUpCallback onEdgeSecondaryTapUp;

  List<Edge> collectEdges(MatrixNode node, Map<String, MatrixNode> edges) {
    return node.renderIncomes != null
        ? node.renderIncomes.map((i) => edges[i]).fold([],
            (List<Edge> acc, MatrixNode income) {
            List<List<double>> points = [];
            var incomeNode = edges[income.id];
            var startNode = node;
            var margins = getEdgeMargins(startNode, incomeNode);
            var nodeMargin = margins[0];
            var incomeMargin = margins[1];
            var direction = getVectorDirection(
                startNode.x, startNode.y, incomeNode.x, incomeNode.y);
            var directions = pointResolversMap[direction];
            var from = directions[0], to = directions[1];
            List<double> startPoint = getPointWithResolver(
                from,
                cellWidth,
                cellPadding,
                contactEdgesDistance,
                startNode,
                nodeMargin,
                orientation);
            points.add(startPoint);
            while (incomeNode.isAnchor) {
              margins = getEdgeMargins(startNode, incomeNode);
              nodeMargin = margins[0];
              incomeMargin = margins[1];
              direction = getVectorDirection(
                  startNode.x, startNode.y, incomeNode.x, incomeNode.y);
              directions = pointResolversMap[direction];
              from = directions[0];
              to = directions[1];
              points.add(getPointWithResolver(to, cellWidth, cellPadding,
                  contactEdgesDistance, incomeNode, incomeMargin, orientation));
              startNode = incomeNode;
              incomeNode = edges[incomeNode.renderIncomes[0]];
            }
            margins = getEdgeMargins(startNode, incomeNode);
            nodeMargin = margins[0];
            incomeMargin = margins[1];
            direction = getVectorDirection(
                startNode.x, startNode.y, incomeNode.x, incomeNode.y);
            directions = pointResolversMap[direction];
            from = directions[0];
            to = directions[1];
            points.add(getPointWithResolver(to, cellWidth, cellPadding,
                contactEdgesDistance, incomeNode, incomeMargin, orientation));
            acc.add(Edge(points, node, incomeNode));
            return acc;
          })
        : [];
  }

  const LinesPainter(
    this.context,
    this.matrixMap,
    this.cellWidth,
    this.contactEdgesDistance,
    this.orientation, {
    this.cellPadding,
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
    this.onEdgePanStart,
    this.onEdgePanUpdate,
    this.onEdgePanDown,
    this.onEdgeSecondaryTapDown,
    this.onEdgeSecondaryTapUp,
    this.paintBuilder,
    this.tipLength,
    this.tipAngle,
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
      var path = Path();
      path.moveTo(points[0][0], points[0][1]);
      points.sublist(1).forEach((p) => path.lineTo(p[0], p[1]));
      final paint =
          paintBuilder == null ? _defaultPaintBuilder(e) : paintBuilder(e);
      path =
          ArrowPath.make(path: path, tipLength: tipLength, tipAngle: tipAngle);
      canvas.drawPath(
        path,
        paint,
        paintStyleForTouch: edgePaintStyleForTouch,
        onTapDown: onEdgeTapDown != null
            ? (details) => onEdgeTapDown(details, e)
            : null,
        onTapUp:
            onEdgeTapUp != null ? (details) => onEdgeTapUp(details, e) : null,
        onLongPressStart: onEdgeLongPressStart != null
            ? (details) => onEdgeLongPressStart(details, e)
            : null,
        onLongPressEnd: onEdgeLongPressEnd != null
            ? (details) => onEdgeLongPressEnd(details, e)
            : null,
        onLongPressMoveUpdate: onEdgeLongPressMoveUpdate != null
            ? (details) => onEdgeLongPressMoveUpdate(details, e)
            : null,
        onForcePressStart: onEdgeForcePressStart != null
            ? (details) => onEdgeForcePressStart(details, e)
            : null,
        onForcePressEnd: onEdgeForcePressEnd != null
            ? (details) => onEdgeForcePressEnd(details, e)
            : null,
        onForcePressPeak: onEdgeForcePressPeak != null
            ? (details) => onEdgeForcePressPeak(details, e)
            : null,
        onForcePressUpdate: onEdgeForcePressUpdate != null
            ? (details) => onEdgeForcePressUpdate(details, e)
            : null,
        onPanStart: onEdgePanStart != null
            ? (details) => onEdgePanStart(details, e)
            : null,
        onPanUpdate: onEdgePanUpdate != null
            ? (details) => onEdgePanUpdate(details, e)
            : null,
        onPanDown: onEdgePanDown != null
            ? (details) => onEdgePanDown(details, e)
            : null,
        onSecondaryTapDown: onEdgeSecondaryTapDown != null
            ? (details) => onEdgeSecondaryTapDown(details, e)
            : null,
        onSecondaryTapUp: onEdgeSecondaryTapUp != null
            ? (details) => onEdgeSecondaryTapUp(details, e)
            : null,
      );
    });
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return false;
  }
}

List<AnchorMargin> getEdgeMargins(MatrixNode node, MatrixNode income) {
  if (node.isAnchor && income.isAnchor) {
    return [node.anchorMargin, income.anchorMargin];
  } else if (node.isAnchor) {
    return [node.anchorMargin, node.anchorMargin];
  } else if (income.isAnchor) {
    return [income.anchorMargin, income.anchorMargin];
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

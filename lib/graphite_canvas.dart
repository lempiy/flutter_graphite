import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_cell.dart';
import 'package:graphite/graphite_edges_painter.dart';
import 'package:graphite/graphite_typings.dart';
import 'package:graphite/utils.dart';
import 'package:touchable/touchable.dart';

class GraphiteCanvas extends StatefulWidget {
  final Size defaultCellSize;
  final EdgeInsets cellPadding;
  final double contactEdgesDistance;
  final Matrix matrix;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;
  final double maxScale;
  final double minScale;
  final NodeCellBuilder? builder;
  final OverlayBuilder? overlayBuilder;
  final ContentWrapperBuilder? contentWrapperBuilder;
  final EdgeLabels? edgeLabels;
  final TransformationController? transformationController;
  final Clip clipBehavior;

  final GestureNodeTapDownCallback? onNodeTapDown;

  final GestureNodeTapUpCallback? onNodeTapUp;
  final GestureNodeLongPressStartCallback? onNodeLongPressStart;

  final GestureNodeLongPressEndCallback? onNodeLongPressEnd;
  final GestureNodeLongPressMoveUpdateCallback? onNodeLongPressMoveUpdate;

  final GestureNodeForcePressStartCallback? onNodeForcePressStart;
  final GestureNodeForcePressEndCallback? onNodeForcePressEnd;

  final GestureNodeForcePressPeakCallback? onNodeForcePressPeak;
  final GestureNodeForcePressUpdateCallback? onNodeForcePressUpdate;

  final GestureNodePanStartCallback? onNodePanStart;
  final GestureNodePanUpdateCallback? onNodePanUpdate;

  final GestureNodePanDownCallback? onNodePanDown;
  final GestureNodeTapDownCallback? onNodeSecondaryTapDown;

  final GestureNodeTapUpCallback? onNodeSecondaryTapUp;

  // Edge
  final EdgePaintBuilder? paintBuilder;
  final EdgePathBuilder? pathBuilder;

  final GestureEdgeTapDownCallback? onEdgeTapDown;

  final GestureTapCallback? onCanvasTap;
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

  const GraphiteCanvas({
    Key? key,
    required this.defaultCellSize,
    required this.matrix,
    required this.cellPadding,
    required this.contactEdgesDistance,
    required this.orientation,
    required this.tipLength,
    required this.tipAngle,
    required this.maxScale,
    required this.minScale,
    required this.clipBehavior,
    this.overlayBuilder,
    this.contentWrapperBuilder,
    this.edgeLabels,
    this.transformationController,
    this.onEdgeTapDown,
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
    this.onCanvasTap,
    this.paintBuilder,
    this.pathBuilder,
    this.onNodeTapDown,
    this.onNodeTapUp,
    this.onNodeLongPressStart,
    this.onNodeLongPressEnd,
    this.onNodeLongPressMoveUpdate,
    this.onNodeForcePressStart,
    this.onNodeForcePressEnd,
    this.onNodeForcePressPeak,
    this.onNodeForcePressUpdate,
    this.onNodePanStart,
    this.onNodePanUpdate,
    this.onNodePanDown,
    this.onNodeSecondaryTapDown,
    this.onNodeSecondaryTapUp,
    this.builder,
  }) : super(key: key);

  @override
  _GraphiteCanvasState createState() => _GraphiteCanvasState();
}

class _GraphiteCanvasState extends State<GraphiteCanvas> {
  final StreamController<Gesture> touchController =
      StreamController.broadcast();
  StreamSubscription? streamSubscription;
  late TransformationController _transformationController;

  @override
  initState() {
    _transformationController =
        widget.transformationController ?? TransformationController();
    super.initState();
  }

  Future<void> addStreamListener(Function(Gesture) callBack) async {
    await streamSubscription?.cancel();
    streamSubscription = touchController.stream.listen(callBack);
  }

  double _getWidthOfCanvas() {
    return getWidthOfCanvas(
        widget.matrix, widget.defaultCellSize.width, widget.cellPadding);
  }

  double _getHeightOfCanvas() {
    return getHeightOfCanvas(
        widget.matrix, widget.defaultCellSize.height, widget.cellPadding);
  }

  double _getHighestHeightInARow(int y) {
    return getHighestHeightInARow(
        widget.matrix, widget.defaultCellSize.height, y);
  }

  double _getWidestWidthInAColumn(int x) {
    return getWidestWidthInAColumn(
        widget.matrix, widget.defaultCellSize.width, x);
  }

  // exclusive
  double _getWidthToPoint(int x, int y, EdgeInsets padding) {
    double distance = 0;
    int from = 0;
    while (from != x) {
      double w = _getWidestWidthInAColumn(from);
      distance += (w + padding.left + padding.right);
      from++;
    }
    return distance;
  }

  // exclusive
  double _getHeightToPoint(int x, int y, EdgeInsets padding) {
    double distance = 0;
    int from = 0;
    while (from != y) {
      double h = _getHighestHeightInARow(from);
      distance += (h + padding.top + padding.bottom);
      from++;
    }
    return distance;
  }

  Widget _buildCell(MatrixNode node) {
    final w = _getWidestWidthInAColumn(node.x);
    final h = _getHighestHeightInARow(node.y);
    final cellWidth = node.size?.width ?? widget.defaultCellSize.width;
    final cellHeight = node.size?.height ?? widget.defaultCellSize.height;
    final cellHorizontalPadding = (cellWidth != w
        ? widget.cellPadding.left + (w - cellWidth) * .5
        : widget.cellPadding.left);
    final cellVerticalPadding = (cellHeight != h
        ? widget.cellPadding.top + (h - cellHeight) * .5
        : widget.cellPadding.top);

    final dx = _getWidthToPoint(node.x, node.y, widget.cellPadding);
    final dy = _getHeightToPoint(node.x, node.y, widget.cellPadding);
    return Positioned(
      top: dy + cellVerticalPadding,
      left: dx + cellHorizontalPadding,
      child: SizedBox(
        width: cellWidth,
        height: cellHeight,
        child: GraphiteCell(
            node: node,
            rect: Rect.fromLTWH(dx + cellHorizontalPadding,
                dy + cellVerticalPadding, cellWidth, cellHeight),
            builder: widget.builder,
            onNodeTapDown: widget.onNodeTapDown,
            onNodeTapUp: widget.onNodeTapUp,
            onNodeLongPressStart: widget.onNodeLongPressStart,
            onNodeLongPressEnd: widget.onNodeLongPressEnd,
            onNodeLongPressMoveUpdate: widget.onNodeLongPressMoveUpdate,
            onNodeForcePressStart: widget.onNodeForcePressStart,
            onNodeForcePressEnd: widget.onNodeForcePressEnd,
            onNodeForcePressPeak: widget.onNodeForcePressPeak,
            onNodeForcePressUpdate: widget.onNodeForcePressUpdate,
            onNodePanStart: widget.onNodePanStart,
            onNodePanUpdate: widget.onNodePanUpdate,
            onNodePanDown: widget.onNodePanDown,
            onNodeSecondaryTapDown: widget.onNodeSecondaryTapDown,
            onNodeSecondaryTapUp: widget.onNodeSecondaryTapUp),
      ),
    );
  }

  List<MatrixNode> _getNodes() {
    List<MatrixNode> items = [];
    for (int y = 0; y < widget.matrix.height(); y++) {
      for (int x = 0; x < widget.matrix.width(); x++) {
        final cell = widget.matrix.getByCoords(x, y);
        if (cell == null) continue;
        cell.all.forEach((n) {
          final node = MatrixNode.fromNodeOutput(x: x, y: y, nodeOutput: n);
          if (!node.isAnchor) items.add(node);
        });
      }
    }
    return items;
  }

  List<Widget> _buildGrid(List<MatrixNode> nodes) {
    return nodes.map((n) => _buildCell(n)).toList();
  }

  List<Widget> _buildOverlay(
      BuildContext context, List<MatrixNode> nodes, List<Edge> edges) {
    return widget.overlayBuilder != null
        ? widget.overlayBuilder!(context, nodes, edges)
        : [];
  }

  Widget _drawHorizontalEdgeLabel(BuildContext context, Edge edge) {
    final canvasHeight = _getHeightOfCanvas();
    final canvasWidth = _getWidthOfCanvas();

    final line = getHorizontalLine(edge.points);
    final width = (line[0][0] - line[1][0]).abs();
    final entry = line[0][0] > line[1][0] ? line[1] : line[0];

    return Positioned(
      left: entry[0] - canvasWidth * .5 + width * .5,
      top: widget.edgeLabels!.alignment == EdgeLabelTextAlignment.after
          ? entry[1]
          : null,
      bottom: widget.edgeLabels!.alignment == EdgeLabelTextAlignment.after
          ? null
          : canvasHeight - entry[1],
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: canvasWidth,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [widget.edgeLabels!.builder(context, edge, false)],
        ),
      ),
    );
  }

  Widget _drawVerticalEdgeLabel(BuildContext context, Edge edge) {
    final canvasHeight = _getHeightOfCanvas();
    final canvasWidth = _getWidthOfCanvas();

    final line = getVerticalLine(edge.points);
    final height = (line[0][1] - line[1][1]).abs();
    final entry = line[0][1] > line[1][1] ? line[1] : line[0];

    return Positioned(
      top: entry[1] - canvasHeight * .5 + height * .5,
      left: widget.edgeLabels!.alignment == EdgeLabelTextAlignment.after
          ? entry[0]
          : null,
      right: widget.edgeLabels!.alignment == EdgeLabelTextAlignment.after
          ? null
          : canvasWidth - entry[0],
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: canvasHeight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [widget.edgeLabels!.builder(context, edge, true)],
        ),
      ),
    );
  }

  Widget _buildEdgeLabel(BuildContext context, Edge edge) {
    switch (widget.edgeLabels!.positionPriority) {
      case EdgeLabelPositionPriority.horizontal:
        return getHorizontalLine(edge.points).length > 0
            ? _drawHorizontalEdgeLabel(context, edge)
            : _drawVerticalEdgeLabel(context, edge);
      case EdgeLabelPositionPriority.vertical:
        return getVerticalLine(edge.points).length > 0
            ? _drawVerticalEdgeLabel(context, edge)
            : _drawHorizontalEdgeLabel(context, edge);
      case EdgeLabelPositionPriority.none:
        return widget.orientation == MatrixOrientation.Horizontal
            ? _drawHorizontalEdgeLabel(context, edge)
            : _drawVerticalEdgeLabel(context, edge);
    }
  }

  List<Widget> _buildEdgeLabels(BuildContext context, List<Edge> edges) {
    if (widget.edgeLabels == null) return [];

    return edges.map((e) => _buildEdgeLabel(context, e)).toList();
  }

  List<Edge> _edgesList() {
    final matrixMap = widget.matrix.normalize();
    List<Edge> _state = [];
    matrixMap.forEach((key, value) {
      if (value.isAnchor) return;
      _state.addAll(collectEdges(value, matrixMap));
    });
    return _state;
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
      final defaultCellSize = NodeSize(
          width: widget.defaultCellSize.width,
          height: widget.defaultCellSize.height);
      List<double> startPoint = getPointWithResolver(
          from,
          defaultCellSize,
          widget.cellPadding,
          widget.contactEdgesDistance,
          startNode,
          nodeMargin,
          widget.orientation);
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
        points.add(getPointWithResolver(
            to,
            defaultCellSize,
            widget.cellPadding,
            widget.contactEdgesDistance,
            incomeNode,
            incomeMargin,
            widget.orientation));
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
      points.add(getPointWithResolver(
          to,
          defaultCellSize,
          widget.cellPadding,
          widget.contactEdgesDistance,
          incomeNode,
          incomeMargin,
          widget.orientation));
      final edgeInput = incomeNode.next.firstWhere((e) => e.outcome == node.id);
      acc.add(Edge(points, incomeNode, node, edgeInput.type));
      return acc;
    });
  }

  List<double> getCellCenter(
      NodeSize defaultCellSize,
      EdgeInsets padding,
      double cellX,
      double cellY,
      double distance,
      AnchorMargin margin,
      MatrixOrientation orientation) {
    double outset = getMargin(margin, distance);
    final cellWidth = _getWidestWidthInAColumn(cellX.floor());
    final cellHeight = _getHighestHeightInARow(cellY.floor());

    double x = _getWidthToPoint(cellX.floor(), cellY.floor(), padding) +
        cellWidth * .5 +
        padding.left;
    double y = _getHeightToPoint(cellX.floor(), cellY.floor(), padding) +
        cellHeight * .5 +
        padding.top;
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
      EdgeInsets padding,
      double cellX,
      double cellY,
      double distance,
      AnchorMargin margin,
      MatrixOrientation orientation) {
    final w = _getWidestWidthInAColumn(cellX.floor());
    final h = _getHighestHeightInARow(cellY.floor());
    final cw = node.size?.width ?? defaultCellSize.width;
    final ch = node.size?.height ?? defaultCellSize.height;

    final actualPadding = getPaddingFromDirection(padding, direction);
    final cellHorizontalPadding =
        (cw != w ? actualPadding + (w - cw) * .5 : actualPadding);
    final cellVerticalPadding =
        (ch != h ? actualPadding + (h - ch) * .5 : actualPadding);

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
      EdgeInsets padding,
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

  Widget _buildCanvas(BuildContext context, List<Edge> edges, Size size) {
    return Container(
      width: size.width,
      height: size.height,
      child: Builder(builder: (ctx) {
        return CustomPaint(
          size: Size.infinite,
          painter: LinesPainter(
            ctx,
            edges,
            tipLength: widget.tipLength,
            tipAngle: widget.tipAngle,
            paintBuilder: widget.paintBuilder,
            onEdgeTapDown: widget.onEdgeTapDown,
            onEdgeTapUp: widget.onEdgeTapUp,
            onEdgeLongPressStart: widget.onEdgeLongPressStart,
            onEdgeLongPressEnd: widget.onEdgeLongPressEnd,
            onEdgeLongPressMoveUpdate: widget.onEdgeLongPressMoveUpdate,
            onEdgeForcePressStart: widget.onEdgeForcePressStart,
            onEdgeForcePressEnd: widget.onEdgeForcePressEnd,
            onEdgeForcePressPeak: widget.onEdgeForcePressPeak,
            onEdgeForcePressUpdate: widget.onEdgeForcePressUpdate,
            onEdgeSecondaryTapDown: widget.onEdgeSecondaryTapDown,
            onEdgeSecondaryTapUp: widget.onEdgeSecondaryTapUp,
            pathBuilder: widget.pathBuilder,
          ),
        );
      }),
    );
  }

  Widget _buildStack(BuildContext context, Size size) {
    final edges = _edgesList();
    final nodes = _getNodes();
    return Stack(
      clipBehavior: widget.clipBehavior,
      children: <Widget>[
        _buildCanvas(context, edges, size),
        ..._buildGrid(nodes),
        ..._buildEdgeLabels(context, edges),
        ..._buildOverlay(context, nodes, edges),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Size(_getWidthOfCanvas(), _getHeightOfCanvas());
    return TouchDetectionController(touchController, addStreamListener,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: InteractiveViewer(
            clipBehavior: widget.clipBehavior,
            maxScale: widget.maxScale,
            minScale: widget.minScale,
            constrained: false,
            transformationController: _transformationController,
            child: widget.contentWrapperBuilder != null
                ? widget.contentWrapperBuilder!(
                    context, size, _buildStack(context, size))
                : _buildStack(context, size),
          ),
          onTap: () {
            if (widget.onCanvasTap != null) {
              widget.onCanvasTap!();
            }
          },
          onTapDown: (TapDownDetails tapDetail) {
            touchController.add(Gesture(
                GestureType.onTapDown,
                TapDownDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  kind: tapDetail.kind,
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                )));
          },
          onTapUp: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onTapUp,
                TapUpDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  kind: tapDetail.kind,
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                )));
          },
          onLongPressStart: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onLongPressStart,
                LongPressStartDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                )));
          },
          onLongPressEnd: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onLongPressEnd,
                LongPressEndDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                )));
          },
          onLongPressMoveUpdate: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onLongPressMoveUpdate,
                LongPressMoveUpdateDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                )));
          },
          onForcePressStart: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onForcePressStart,
                ForcePressDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                  pressure: tapDetail.pressure,
                )));
          },
          onForcePressEnd: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onForcePressEnd,
                ForcePressDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                  pressure: tapDetail.pressure,
                )));
          },
          onForcePressPeak: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onForcePressPeak,
                ForcePressDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                  pressure: tapDetail.pressure,
                )));
          },
          onForcePressUpdate: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onForcePressUpdate,
                ForcePressDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                  pressure: tapDetail.pressure,
                )));
          },
          onSecondaryTapDown: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onSecondaryTapDown,
                TapDownDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  kind: tapDetail.kind,
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                )));
          },
          onSecondaryTapUp: (tapDetail) {
            touchController.add(Gesture(
                GestureType.onSecondaryTapUp,
                TapUpDetails(
                  globalPosition: _transformationController
                      .toScene(tapDetail.globalPosition),
                  kind: tapDetail.kind,
                  localPosition: _transformationController
                      .toScene(tapDetail.localPosition),
                )));
          },
        ));
  }

  @override
  void dispose() {
    touchController.close();
    super.dispose();
  }
}

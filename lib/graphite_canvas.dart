import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_cell.dart';
import 'package:graphite/graphite_edges_painter.dart';
import 'package:graphite/utils.dart';
import 'package:touchable/touchable.dart';

class GraphiteCanvas extends StatefulWidget {
  final double defaultCellWidth;
  final double defaultCellHeight;
  final double cellPadding;
  final double contactEdgesDistance;
  final Matrix matrix;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;
  final double maxScale;
  final double minScale;
  final NodeCellBuilder? builder;
  final OverlayBuilder? overlayBuilder;

  final GestureNodeTapDownCallback? onNodeTapDown;

  final GestureNodeTapUpCallback? onNodeTapUp;
  final GestureNodeLongPressStartCallback? onNodeLongPressStart;

  final GestureNodeLongPressEndCallback? onNodeLongPressEnd;
  final GestureNodeLongPressMoveUpdateCallback? onNodeLongPressMoveUpdate;

  final GestureNodeForcePressStartCallback? onNodeForcePressStart;
  final GestureNodeForcePressEndCallback? onNodeForcePressEnd;

  final GestureNodeForcePressPeakCallback? onNodeForcePressPeak;
  final GestureNodeForcePressUpdateCallback? onNodeForcePressUpdate;

  final GestureNodeDragStartCallback? onNodePanStart;
  final GestureNodeDragUpdateCallback? onNodePanUpdate;

  final GestureNodeDragDownCallback? onNodePanDown;
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
    required this.defaultCellWidth,
    required this.defaultCellHeight,
    required this.matrix,
    required this.cellPadding,
    required this.contactEdgesDistance,
    required this.orientation,
    required this.tipLength,
    required this.tipAngle,
    required this.maxScale,
    required this.minScale,
    this.overlayBuilder,
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
  final _transformationController = TransformationController();

  Future<void> addStreamListener(Function(Gesture) callBack) async {
    await streamSubscription?.cancel();
    streamSubscription = touchController.stream.listen(callBack);
  }

  double _getWidthOfCanvas() {
    return getWidthOfCanvas(
        widget.matrix, widget.defaultCellWidth, widget.cellPadding);
  }

  double _getHeightOfCanvas() {
    return getHeightOfCanvas(
        widget.matrix, widget.defaultCellHeight, widget.cellPadding);
  }

  List<MatrixNode?> getListFromMatrix(Matrix mtx) {
    return mtx.s.asMap().entries.fold([], (result, entry) {
      var y = entry.key, row = entry.value;
      result.addAll(row.asMap().entries.map((cellEntry) {
        var x = cellEntry.key, cell = cellEntry.value;
        return cell == null
            ? null
            : MatrixNode.fromNodeOutput(x: x, y: y, nodeOutput: cell);
      }));
      return result;
    });
  }

  double _getHighestHeightInARow(int y) {
    return getHighestHeightInARow(widget.matrix, widget.defaultCellHeight, y);
  }

  double _getWidestWidthInAColumn(int x) {
    return getWidestWidthInAColumn(widget.matrix, widget.defaultCellWidth, x);
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

  Widget _buildCell(MatrixNode node) {
    final w = _getWidestWidthInAColumn(node.x);
    final h = _getHighestHeightInARow(node.y);
    final cellWidth = node.size?.width ?? widget.defaultCellWidth;
    final cellHeight = node.size?.height ?? widget.defaultCellHeight;
    final cellHorizontalPadding = (cellWidth != w
        ? widget.cellPadding + (w - cellWidth) * .5
        : widget.cellPadding);
    final cellVerticalPadding = (cellHeight != h
        ? widget.cellPadding + (h - cellHeight) * .5
        : widget.cellPadding);

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
            rect: Rect.fromLTWH(dx + cellHorizontalPadding, dy + cellVerticalPadding, cellWidth, cellHeight),
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

  List<Widget> _buildGrid() {
    List<Widget> items = [];
    for (int y = 0; y < widget.matrix.height(); y++) {
      for (int x = 0; x < widget.matrix.width(); x++) {
        final node = widget.matrix.getByCoords(x, y) != null
            ? MatrixNode.fromNodeOutput(
                x: x, y: y, nodeOutput: widget.matrix.getByCoords(x, y)!)
            : null;
        if (node != null && !node.isAnchor) items.add(_buildCell(node));
      }
    }
    return items;
  }

  List<Widget> _buildOverlay(BuildContext context) {
    return widget.overlayBuilder != null ? [widget.overlayBuilder!(context)] : [];
  }

  @override
  Widget build(BuildContext context) {
    return TouchDetectionController(touchController, addStreamListener,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: InteractiveViewer(
            maxScale: widget.maxScale,
            minScale: widget.minScale,
            constrained: false,
            transformationController: _transformationController,
            child: Stack(
              children: <Widget>[
                Container(
                  width: _getWidthOfCanvas(),
                  height: _getHeightOfCanvas(),
                  child: Builder(builder: (ctx) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: LinesPainter(
                        ctx,
                        widget.matrix,
                        widget.matrix.normalize(),
                        widget.defaultCellWidth,
                        widget.defaultCellHeight,
                        widget.contactEdgesDistance,
                        widget.orientation,
                        tipLength: widget.tipLength,
                        tipAngle: widget.tipAngle,
                        cellPadding: widget.cellPadding,
                        paintBuilder: widget.paintBuilder,
                        onEdgeTapDown: widget.onEdgeTapDown,
                        onEdgeTapUp: widget.onEdgeTapUp,
                        onEdgeLongPressStart: widget.onEdgeLongPressStart,
                        onEdgeLongPressEnd: widget.onEdgeLongPressEnd,
                        onEdgeLongPressMoveUpdate:
                            widget.onEdgeLongPressMoveUpdate,
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
                ),
                ..._buildGrid(),
                ..._buildOverlay(context),
              ],
            ),
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

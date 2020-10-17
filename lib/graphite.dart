library graphite;

import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:graphite/core/graph.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_cell.dart';
import 'package:graphite/graphite_edges_painter.dart';
import 'package:graphite/graphite_root.dart';

export 'package:graphite/core/typings.dart';
export 'package:graphite/graphite_cell.dart';
export 'package:graphite/graphite_edges_painter.dart';

class DirectGraph extends StatefulWidget {
  const DirectGraph(
      {@required this.list,
      @required this.cellWidth,
      @required this.cellPadding,
      Key key,
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
      this.onEdgePanStart,
      this.onEdgePanUpdate,
      this.onEdgePanDown,
      this.onEdgeSecondaryTapDown,
      this.onEdgeSecondaryTapUp,
      this.paintBuilder,
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
      this.contactEdgesDistance = 5.0,
      this.orientation = MatrixOrientation.Horizontal,
      this.tipAngle = math.pi * 0.1,
      this.tipLength = 10.0,
      this.maxScale = 3.5,
      this.minScale = 0.25,
      this.pathBuilder})
      : super(key: key);

  final double cellWidth;
  final double cellPadding;
  final List<NodeInput> list;
  final double contactEdgesDistance;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;
  final double maxScale;
  final double minScale;

  // Node
  final NodeCellBuilder builder;

  final GestureNodeTapDownCallback onNodeTapDown;

  final GestureNodeTapUpCallback onNodeTapUp;
  final GestureNodeLongPressStartCallback onNodeLongPressStart;

  final GestureNodeLongPressEndCallback onNodeLongPressEnd;
  final GestureNodeLongPressMoveUpdateCallback onNodeLongPressMoveUpdate;

  final GestureNodeForcePressStartCallback onNodeForcePressStart;
  final GestureNodeForcePressEndCallback onNodeForcePressEnd;

  final GestureNodeForcePressPeakCallback onNodeForcePressPeak;
  final GestureNodeForcePressUpdateCallback onNodeForcePressUpdate;

  final GestureNodeDragStartCallback onNodePanStart;
  final GestureNodeDragUpdateCallback onNodePanUpdate;

  final GestureNodeDragDownCallback onNodePanDown;
  final GestureNodeTapDownCallback onNodeSecondaryTapDown;

  final GestureNodeTapUpCallback onNodeSecondaryTapUp;

  // Edge
  final EdgePaintBuilder paintBuilder;
  final EdgePathBuilder pathBuilder;

  final GestureTapCallback onCanvasTap;
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
  @override
  _DirectGraphState createState() => _DirectGraphState();
}

class _DirectGraphState extends State<DirectGraph> {
  Graph toGraph(List<NodeInput> list) {
    return Graph(list: list);
  }

  List<NodeOutput> getListFromTMatrix(Matrix mtx) {
    return mtx.s.expand((v) => v).toList();
  }

  Widget getRoot(BuildContext context, Matrix mtx) {
    return GraphiteRoot(
      mtx: mtx,
      cellWidth: widget.cellWidth,
      cellPadding: widget.cellPadding,
      contactEdgesDistance: widget.contactEdgesDistance,
      orientation: widget.orientation,
      builder: widget.builder,
      tipLength: widget.tipLength,
      tipAngle: widget.tipAngle,
      onCanvasTap: widget.onCanvasTap,
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
      onNodeSecondaryTapUp: widget.onNodeSecondaryTapUp,
      paintBuilder: widget.paintBuilder,
      onEdgeTapDown: widget.onEdgeTapDown,
      edgePaintStyleForTouch: widget.edgePaintStyleForTouch,
      onEdgeTapUp: widget.onEdgeTapUp,
      onEdgeLongPressStart: widget.onEdgeLongPressStart,
      onEdgeLongPressEnd: widget.onEdgeLongPressEnd,
      onEdgeLongPressMoveUpdate: widget.onEdgeLongPressMoveUpdate,
      onEdgeForcePressStart: widget.onEdgeForcePressStart,
      onEdgeForcePressEnd: widget.onEdgeForcePressEnd,
      onEdgeForcePressPeak: widget.onEdgeForcePressPeak,
      onEdgeForcePressUpdate: widget.onEdgeForcePressUpdate,
      onEdgePanStart: widget.onEdgePanStart,
      onEdgePanUpdate: widget.onEdgePanUpdate,
      onEdgePanDown: widget.onEdgePanDown,
      onEdgeSecondaryTapDown: widget.onEdgeSecondaryTapDown,
      onEdgeSecondaryTapUp: widget.onEdgeSecondaryTapUp,
      minScale: widget.minScale,
      maxScale: widget.maxScale,
      pathBuilder: widget.pathBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    var graph = this.toGraph(widget.list);
    var mtx = graph.traverse();
    if (widget.orientation == MatrixOrientation.Vertical) {
      mtx = mtx.rotate();
    }
    return getRoot(context, mtx);
  }
}

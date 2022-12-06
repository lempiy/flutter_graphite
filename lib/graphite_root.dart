import 'package:flutter/widgets.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite_cell.dart';
import 'package:graphite/graphite_canvas.dart';
import 'package:graphite/graphite_edges_painter.dart';

class GraphiteRoot extends StatefulWidget {
  final Matrix mtx;
  final double defaultCellWidth;
  final double defaultCellHeight;
  final double cellPadding;
  final double contactEdgesDistance;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;
  final double maxScale;
  final double minScale;

  // Node
  final NodeCellBuilder? builder;

  // Overlay
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

  final GestureTapCallback? onCanvasTap;
  final GestureEdgeTapDownCallback? onEdgeTapDown;

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

  GraphiteRoot({
    required this.mtx,
    required this.defaultCellWidth,
    required this.defaultCellHeight,
    required this.cellPadding,
    required this.tipLength,
    required this.tipAngle,
    required this.maxScale,
    required this.minScale,
    required this.orientation,
    required this.contactEdgesDistance,
    this.overlayBuilder,
    this.onEdgeTapDown,
    this.onEdgeTapUp,
    this.onCanvasTap,
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
    this.pathBuilder,
  });
  @override
  _GraphiteRootState createState() => _GraphiteRootState();
}

class _GraphiteRootState extends State<GraphiteRoot> {
  @override
  Widget build(BuildContext context) {
    return GraphiteCanvas(
        matrix: widget.mtx,
        defaultCellWidth: widget.defaultCellWidth,
        defaultCellHeight: widget.defaultCellHeight,
        overlayBuilder: widget.overlayBuilder,
        cellPadding: widget.cellPadding,
        contactEdgesDistance: widget.contactEdgesDistance,
        orientation: widget.orientation,
        paintBuilder: widget.paintBuilder,
        onCanvasTap: widget.onCanvasTap,
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
        tipAngle: widget.tipAngle,
        tipLength: widget.tipLength,
        maxScale: widget.maxScale,
        minScale: widget.minScale,
        pathBuilder: widget.pathBuilder,
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
        onNodeSecondaryTapUp: widget.onNodeSecondaryTapUp);
  }
}

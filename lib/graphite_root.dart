import 'package:flutter/widgets.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_canvas.dart';
import 'package:graphite/graphite_typings.dart';

class GraphiteRoot extends StatefulWidget {
  final Matrix mtx;
  final Size defaultCellSize;
  final EdgeInsets cellPadding;
  final double contactEdgesDistance;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;
  final double maxScale;
  final double minScale;
  final TransformationController? transformationController;
  final Clip clipBehavior;

  // Node
  final NodeCellBuilder? builder;

  // Overlay
  final OverlayBuilder? overlayBuilder;

  // Edge label
  final EdgeLabels? edgeLabels;

  final ContentWrapperBuilder? contentWrapperBuilder;

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
    required this.defaultCellSize,
    required this.cellPadding,
    required this.tipLength,
    required this.tipAngle,
    required this.maxScale,
    required this.minScale,
    required this.orientation,
    required this.contactEdgesDistance,
    required this.clipBehavior,
    this.transformationController,
    this.overlayBuilder,
    this.contentWrapperBuilder,
    this.edgeLabels,
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
        defaultCellSize: widget.defaultCellSize,
        overlayBuilder: widget.overlayBuilder,
        contentWrapperBuilder: widget.contentWrapperBuilder,
        clipBehavior: widget.clipBehavior,
        transformationController: widget.transformationController,
        edgeLabels: widget.edgeLabels,
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

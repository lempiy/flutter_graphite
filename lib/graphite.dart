library graphite;

import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:graphite/core/graph.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_root.dart';
import 'package:graphite/graphite_typings.dart';

export 'package:graphite/graphite_typings.dart';
export 'package:graphite/core/typings.dart';

class DirectGraph extends StatefulWidget {
  /// Graph source defined as [list] of [NodeInput]'s. Root or entry point for
  /// graph is selected as first found node without incomes or the first node
  /// in the [list] if there's no nodes without incomes.
  final List<NodeInput> list;

  /// Default cell size for any node where [NodeInput.size] is null.
  final Size defaultCellSize;

  /// Padding between nodes. By increasing it's value edges length is also increased.
  final EdgeInsets cellPadding;

  /// if set to true all node outcomes will be centered relatively to it's parent
  /// as much as it's possible in rectangular space. Useful to create tree-like
  /// structures with [Alignment.center]. Defaults to false.
  final bool centered;

  /// Distance between backward and forward oriented edge when they enter the same node.
  /// Defaults to 5.0. Set it to zero if you need to center all edges entry points.
  final double contactEdgesDistance;

  /// Output graph with [MatrixOrientation.Horizontal] orientation or
  /// [MatrixOrientation.Vertical]. Use [MatrixOrientation.Horizontal] for row
  /// views and [MatrixOrientation.Vertical] for column views.
  final MatrixOrientation orientation;

  /// is the length (in pixels) of each of the 2 lines making the arrow.
  /// Ignored if using custom [pathBuilder] is set.
  final double tipLength;

  /// [tipAngle] is the angle (in radians) between each of the 2 lines making the arrow and the curve at this point.
  /// Ignored if using custom [pathBuilder] is set.
  final double tipAngle;

  /// Value for internal [InteractiveViewer.maxScale].
  final double maxScale;

  /// Value for internal [InteractiveViewer.minScale].
  final double minScale;

  /// Value for internal [InteractiveViewer.clipBehavior] and [Stack.clipBehavior].
  final Clip clipBehavior;

  /// Builder function to render custom node Widget. Fires upon each node build call
  /// and provides info about node as [MatrixNode].
  final NodeCellBuilder? nodeBuilder;

  /// Builder function to render custom Widget on top of the graph inside [InteractiveViewer].
  /// Fires upon each build call and provides info about all current nodes and edges including
  /// their position (x,y) in [Stack]. Return [Positioned] Widget with coordinates in particular
  /// position to create interactive tooltips.
  final OverlayBuilder? overlayBuilder;

  /// List of params to draw labels on top or above the edges. Useful to comment
  /// relations between entities.
  final EdgeLabels? edgeLabels;

  /// [GestureDetector.onTapDown] for node widget.
  final GestureNodeTapDownCallback? onNodeTapDown;

  /// [GestureDetector.onTapUp] for node widget.
  final GestureNodeTapUpCallback? onNodeTapUp;

  /// [GestureDetector.onLongPressStart] for node widget.
  final GestureNodeLongPressStartCallback? onNodeLongPressStart;

  /// [GestureDetector.onLongPressEnd] for node widget.
  final GestureNodeLongPressEndCallback? onNodeLongPressEnd;

  /// [GestureDetector.onLongPressMoveUpdate] for node widget.
  final GestureNodeLongPressMoveUpdateCallback? onNodeLongPressMoveUpdate;

  /// [GestureDetector.onForcePressStart] for node widget.
  final GestureNodeForcePressStartCallback? onNodeForcePressStart;

  /// [GestureDetector.onForcePressEnd] for node widget.
  final GestureNodeForcePressEndCallback? onNodeForcePressEnd;

  /// [GestureDetector.onForcePressPeak] for node widget.
  final GestureNodeForcePressPeakCallback? onNodeForcePressPeak;

  /// [GestureDetector.onForcePressUpdate] for node widget.
  final GestureNodeForcePressUpdateCallback? onNodeForcePressUpdate;

  /// [GestureDetector.onPanStart] for node widget.
  final GestureNodePanStartCallback? onNodePanStart;

  /// [GestureDetector.onPanUpdate] for node widget.
  final GestureNodePanUpdateCallback? onNodePanUpdate;

  /// [GestureDetector.onPanDown] for node widget.
  final GestureNodePanDownCallback? onNodePanDown;

  /// [GestureDetector.onSecondaryTapDown] for node widget.
  final GestureNodeTapDownCallback? onNodeSecondaryTapDown;

  /// [GestureDetector.onSecondaryTapUp] for node widget.
  final GestureNodeTapUpCallback? onNodeSecondaryTapUp;

  /// [Path] builder function to draw custom shaped edges.
  /// Called on each canvas render cycle, provides info about each
  /// edge as [Edge]. If set, arrows on tip of each path wont be added.
  final EdgePaintBuilder? paintBuilder;

  /// [Paint] builder function to provide custom style for node edges.
  /// Called on each canvas render cycle, provides info about each
  /// edge as [Edge].
  final EdgePathBuilder? pathBuilder;

  /// [GestureDetector.onTapDown] event on any point inside canvas.
  /// Maybe used to bind action cancel event.
  final GestureBackgroundTapCallback? onCanvasTap;

  /// [GestureDetector.onTapDown]
  final GestureEdgeTapDownCallback? onEdgeTapDown;

  /// [GestureDetector.onTapUp] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeTapUpCallback? onEdgeTapUp;

  /// [GestureDetector.onLongPressStart] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeLongPressStartCallback? onEdgeLongPressStart;

  /// [GestureDetector.onLongPressEnd] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeLongPressEndCallback? onEdgeLongPressEnd;

  /// [GestureDetector.onLongPressMoveUpdate] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeLongPressMoveUpdateCallback? onEdgeLongPressMoveUpdate;

  /// [GestureDetector.onForcePressStart] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeForcePressStartCallback? onEdgeForcePressStart;

  /// [GestureDetector.onForcePressEnd] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeForcePressEndCallback? onEdgeForcePressEnd;

  /// [GestureDetector.onForcePressPeak] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeForcePressPeakCallback? onEdgeForcePressPeak;

  /// [GestureDetector.onForcePressUpdate] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeForcePressUpdateCallback? onEdgeForcePressUpdate;

  /// [GestureDetector.onTapDown] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeTapDownCallback? onEdgeSecondaryTapDown;

  /// [GestureDetector.onTapUp] for edge. Has two times wider
  /// hitbox then edges width to improve UX.
  final GestureEdgeTapUpCallback? onEdgeSecondaryTapUp;

  /// Draw direct graph using [list] of [NodeInput]'s as source.
  ///
  /// Use [defaultCellSize] to provide default cell size for each node. You can always provide
  /// custom cell size for specific node using [NodeInput.size] parameter inside each of instances.
  ///
  /// Use [cellPadding] to set padding between nodes. Note, that increasing [cellPadding] will
  /// increase edges length, which might be useful if you need more space to add overlays or labels.
  ///
  /// [tipLength] is the length (in pixels) of each of the 2 lines making the arrow.
  /// Ignored if using custom [pathBuilder] is set.
  ///
  /// [tipAngle] is the angle (in radians) between each of the 2 lines making the arrow and the curve at this point.
  /// Ignored if using custom [pathBuilder] is set. Defaults to [math.pi] * 0.1.
  ///
  /// If [clipBehavior] clipBehavior of internal InteractiveViewer and Stack.
  /// Defaults to [Clip.hardEdge].
  ///
  /// [transformationController] is [TransformationController] instance for internal [InteractiveViewer].
  /// Can be used to programmatically control graphs view.
  ///
  /// [contentWrapperBuilder] builder function to add wrapper for internal
  /// [InteractiveViewer] content. Useful when you need to add internal padding or
  /// to center content using [MediaQuery].
  ///
  /// [centered] if set to true all node outcomes will be centered relatively to it's parent
  /// as much as it's possible in rectangular space. Defaults to false.
  ///
  /// [nodeBuilder] builder function to customize node Widget.
  ///
  /// [contactEdgesDistance] distance between backward and forward oriented edge
  /// on their contact. If set to 0.0 contact edges collide into one just like two
  /// backward or two forward oriented edges. Defaults to 5.0.
  ///
  /// [maxScale] maxScale value for internal [InteractiveViewer.maxScale]. Defaults to 2.5.
  ///
  /// [minScale] minScale value for internal [InteractiveViewer.minScale]. Defaults to 0.25.
  ///
  /// [pathBuilder] is a [Path] provider function to draw custom shaped edges. If provided
  /// arrows wont be added. May be used to highlight particular relations.
  ///
  /// [paintBuilder] is a [Paint] provider function to customize color, width and style
  /// of edges. May be used to highlight particular relations.
  ///
  /// [overlayBuilder] builder function to create interactive overlays on top of graph.
  /// For instance, tooltips, hovers or node detail panels.
  ///
  /// [edgeLabels] details to add text (or custom widget) labels to edges.
  ///
  /// [onCanvasTap] any point on canvas tap handler. Useful to cancel actions related
  /// to other handlers. For instance, hide tooltip.
  ///
  /// [orientation] draw graph with [MatrixOrientation.Horizontal] orientation or
  /// [MatrixOrientation.Vertical]. Defaults to [MatrixOrientation.Horizontal].
  ///
  /// [onEdgeTapDown],[onEdgeTapUp],[onEdgeLongPressStart],[onEdgeLongPressEnd],
  /// [onEdgeLongPressMoveUpdate],[onEdgeForcePressStart],[onEdgeForcePressEnd],
  /// [onEdgeForcePressPeak],[onEdgeForcePressUpdate],
  /// [onEdgeSecondaryTapDown],[onEdgeSecondaryTapUp] gesture events for
  /// edges interactions. See [GestureDetector] for details. No pan/drag events since it conflicts
  /// with [InteractiveViewer]'s pan events.
  ///
  /// [onNodeTapDown],[onNodeTapUp],[onNodeLongPressStart],
  /// [onNodeLongPressEnd],[onNodeLongPressMoveUpdate],[onNodeForcePressStart],
  /// [onNodeForcePressEnd],[onNodeForcePressPeak],[onNodeForcePressUpdate],
  /// [onNodePanStart],[onNodePanUpdate],[onNodePanDown],
  /// [onNodeSecondaryTapDown],[onNodeSecondaryTapUp] gesture events for nodes.
  /// See [GestureDetector] for details.
  DirectGraph({
    super.key,
    required this.list,
    required this.defaultCellSize,
    required this.cellPadding,
    this.clipBehavior = Clip.hardEdge,
    this.centered = false,
    this.nodeBuilder,
    this.contactEdgesDistance = 5.0,
    this.orientation = MatrixOrientation.Horizontal,
    this.tipAngle = math.pi * 0.1,
    this.tipLength = 10.0,
    this.maxScale = 2.5,
    this.minScale = 0.25,
    this.pathBuilder,
    this.paintBuilder,
    this.overlayBuilder,
    this.edgeLabels,
    this.onCanvasTap,
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
  });

  @override
  _DirectGraphState createState() => _DirectGraphState();
}

class _DirectGraphState extends State<DirectGraph> {
  Graph toGraph(List<NodeInput> list, bool centered) {
    return Graph(list: list, centred: centered);
  }

  Widget getRoot(BuildContext context, Matrix mtx) {
    return GraphiteRoot(
      mtx: mtx,
      defaultCellSize: widget.defaultCellSize,
      overlayBuilder: widget.overlayBuilder,
      edgeLabels: widget.edgeLabels,
      cellPadding: widget.cellPadding,
      clipBehavior: widget.clipBehavior,
      contactEdgesDistance: widget.contactEdgesDistance,
      orientation: widget.orientation,
      builder: widget.nodeBuilder,
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
      minScale: widget.minScale,
      maxScale: widget.maxScale,
      pathBuilder: widget.pathBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    var graph = this.toGraph(widget.list, widget.centered);
    var mtx = graph.traverse();
    if (widget.orientation == MatrixOrientation.Vertical) {
      mtx = mtx.rotate();
    }
    return getRoot(context, mtx);
  }
}

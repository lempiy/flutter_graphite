import 'package:flutter/widgets.dart';
import 'package:graphite/core/typings.dart';

typedef NodeCellBuilder = Widget Function(
    BuildContext context, MatrixNode node);

typedef GestureNodeTapDownCallback = void Function(
    TapDownDetails details, MatrixNode node);
typedef GestureNodeTapUpCallback = void Function(
    TapUpDetails details, MatrixNode node);

typedef GestureNodeLongPressStartCallback = void Function(
    LongPressStartDetails details, MatrixNode node);
typedef GestureNodeLongPressEndCallback = void Function(
    LongPressEndDetails details, MatrixNode node);
typedef GestureNodeLongPressMoveUpdateCallback = void Function(
    LongPressMoveUpdateDetails details, MatrixNode node);
typedef GestureNodeForcePressStartCallback = void Function(
    ForcePressDetails details, MatrixNode node);
typedef GestureNodeForcePressEndCallback = void Function(
    ForcePressDetails details, MatrixNode node);
typedef GestureNodeForcePressPeakCallback = void Function(
    ForcePressDetails details, MatrixNode node);
typedef GestureNodeForcePressUpdateCallback = void Function(
    ForcePressDetails details, MatrixNode node);
typedef GestureNodeDragStartCallback = void Function(
    DragStartDetails details, MatrixNode node);
typedef GestureNodeDragUpdateCallback = void Function(
    DragUpdateDetails details, MatrixNode node);
typedef GestureNodeDragDownCallback = void Function(
    DragDownDetails details, MatrixNode node);

Widget _defaultNodeCellBuilder(BuildContext context, MatrixNode node) {
  return Container(
    alignment: Alignment.center,
    child: Text(node.id),
    color: Color(0xFF26A69A),
  );
}

class GraphiteCell extends StatefulWidget {
  final MatrixNode node;
  final double cellPadding;

  final NodeCellBuilder? builder;

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

  const GraphiteCell({
    required this.node,
    required this.cellPadding,
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
  });
  @override
  _GraphiteCellState createState() => _GraphiteCellState();
}

class _GraphiteCellState extends State<GraphiteCell> {
  @override
  Widget build(BuildContext context) {
    var node = widget.node;
    return node.isAnchor
        ? IgnorePointer(child: Container())
        : Container(
            padding: EdgeInsets.all(widget.cellPadding),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: widget.onNodeTapDown != null
                  ? (details) => widget.onNodeTapDown!(details, node)
                  : null,
              onTapUp: widget.onNodeTapUp != null
                  ? (details) => widget.onNodeTapUp!(details, node)
                  : null,
              onLongPressStart: widget.onNodeLongPressStart != null
                  ? (details) => widget.onNodeLongPressStart!(details, node)
                  : null,
              onLongPressEnd: widget.onNodeLongPressEnd != null
                  ? (details) => widget.onNodeLongPressEnd!(details, node)
                  : null,
              onLongPressMoveUpdate: widget.onNodeLongPressMoveUpdate != null
                  ? (details) => widget.onNodeLongPressMoveUpdate!(details, node)
                  : null,
              onForcePressStart: widget.onNodeForcePressStart != null
                  ? (details) => widget.onNodeForcePressStart!(details, node)
                  : null,
              onForcePressEnd: widget.onNodeForcePressEnd != null
                  ? (details) => widget.onNodeForcePressEnd!(details, node)
                  : null,
              onForcePressPeak: widget.onNodeForcePressPeak != null
                  ? (details) => widget.onNodeForcePressPeak!(details, node)
                  : null,
              onForcePressUpdate: widget.onNodeForcePressUpdate != null
                  ? (details) => widget.onNodeForcePressUpdate!(details, node)
                  : null,
              onPanStart: widget.onNodePanStart != null
                  ? (details) => widget.onNodePanStart!(details, node)
                  : null,
              onPanUpdate: widget.onNodePanUpdate != null
                  ? (details) => widget.onNodePanUpdate!(details, node)
                  : null,
              onPanDown: widget.onNodePanDown != null
                  ? (details) => widget.onNodePanDown!(details, node)
                  : null,
              onSecondaryTapDown: widget.onNodeSecondaryTapDown != null
                  ? (details) => widget.onNodeSecondaryTapDown!(details, node)
                  : null,
              onSecondaryTapUp: widget.onNodeSecondaryTapUp != null
                  ? (details) => widget.onNodeSecondaryTapUp!(details, node)
                  : null,
              child: Builder(builder: (ctx) {
                return widget.builder == null
                    ? _defaultNodeCellBuilder(ctx, node)
                    : widget.builder!(ctx, node);
              }),
            ),
          );
  }
}

class GraphiteAnchor extends StatefulWidget {
  @override
  _GraphiteAnchorState createState() => _GraphiteAnchorState();
}

class _GraphiteAnchorState extends State<GraphiteAnchor> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(),
    );
  }
}

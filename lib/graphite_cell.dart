import 'package:flutter/widgets.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_typings.dart';

Widget _defaultNodeCellBuilder(BuildContext context, MatrixNode node) {
  return Container(
    decoration: BoxDecoration(border: Border.all()),
    alignment: Alignment.center,
    child: Text(node.id),
  );
}

class GraphiteCell extends StatefulWidget {
  final MatrixNode node;
  final Rect rect;

  final Key? key;

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

  final GestureNodePanStartCallback? onNodePanStart;
  final GestureNodePanUpdateCallback? onNodePanUpdate;

  final GestureNodePanDownCallback? onNodePanDown;
  final GestureNodeTapDownCallback? onNodeSecondaryTapDown;

  final GestureNodeTapUpCallback? onNodeSecondaryTapUp;

  const GraphiteCell({
    this.key,
    required this.node,
    required this.rect,
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
    return Container(
      child: GestureDetector(
        onTapDown: widget.onNodeTapDown != null
            ? (details) => widget.onNodeTapDown!(details, node, widget.rect)
            : null,
        onTapUp: widget.onNodeTapUp != null
            ? (details) => widget.onNodeTapUp!(details, node, widget.rect)
            : null,
        onLongPressStart: widget.onNodeLongPressStart != null
            ? (details) =>
                widget.onNodeLongPressStart!(details, node, widget.rect)
            : null,
        onLongPressEnd: widget.onNodeLongPressEnd != null
            ? (details) =>
                widget.onNodeLongPressEnd!(details, node, widget.rect)
            : null,
        onLongPressMoveUpdate: widget.onNodeLongPressMoveUpdate != null
            ? (details) =>
                widget.onNodeLongPressMoveUpdate!(details, node, widget.rect)
            : null,
        onForcePressStart: widget.onNodeForcePressStart != null
            ? (details) =>
                widget.onNodeForcePressStart!(details, node, widget.rect)
            : null,
        onForcePressEnd: widget.onNodeForcePressEnd != null
            ? (details) =>
                widget.onNodeForcePressEnd!(details, node, widget.rect)
            : null,
        onForcePressPeak: widget.onNodeForcePressPeak != null
            ? (details) =>
                widget.onNodeForcePressPeak!(details, node, widget.rect)
            : null,
        onForcePressUpdate: widget.onNodeForcePressUpdate != null
            ? (details) =>
                widget.onNodeForcePressUpdate!(details, node, widget.rect)
            : null,
        onPanStart: widget.onNodePanStart != null
            ? (details) => widget.onNodePanStart!(details, node, widget.rect)
            : null,
        onPanUpdate: widget.onNodePanUpdate != null
            ? (details) => widget.onNodePanUpdate!(details, node, widget.rect)
            : null,
        onPanDown: widget.onNodePanDown != null
            ? (details) => widget.onNodePanDown!(details, node, widget.rect)
            : null,
        onSecondaryTapDown: widget.onNodeSecondaryTapDown != null
            ? (details) =>
                widget.onNodeSecondaryTapDown!(details, node, widget.rect)
            : null,
        onSecondaryTapUp: widget.onNodeSecondaryTapUp != null
            ? (details) =>
                widget.onNodeSecondaryTapUp!(details, node, widget.rect)
            : null,
        child: Builder(builder: (ctx) {
          return widget.builder == null
              ? _defaultNodeCellBuilder(ctx, node)
              : widget.builder!(ctx, node);
        }),
        //child: Container(),
      ),
    );
  }
}

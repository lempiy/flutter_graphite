import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite_cell.dart';

class GraphiteGrid extends StatefulWidget {
  final Matrix matrix;
  final double cellWidth;
  final double cellPadding;

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

  GraphiteGrid({
    @required this.matrix,
    @required this.cellWidth,
    @required this.cellPadding,
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
  _GraphiteGridState createState() => _GraphiteGridState();
}

class _GraphiteGridState extends State<GraphiteGrid> {
  List<MatrixNode> getListFromMatrix(Matrix mtx) {
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

  @override
  Widget build(BuildContext context) {
    var width = widget.matrix.width();
    var height = widget.matrix.height();
    var data = this.getListFromMatrix(widget.matrix);
    return Container(
      //padding: EdgeInsets.all(30.0),
      width: (widget.cellWidth * width).toDouble(),
      height: (widget.cellWidth * height).toDouble(),
      child: GridView.count(
        crossAxisCount: width,
        childAspectRatio: 1,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        children: data.map<Widget>((node) {
          return node == null
              ? IgnorePointer(child: Container())
              : GraphiteCell(
                  node: node,
                  cellPadding: widget.cellPadding,
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
        }).toList(),
      ),
    );
  }
}

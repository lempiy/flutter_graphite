import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite_edges_painter.dart';
import 'package:touchable/touchable.dart';

class GraphiteEdges extends StatefulWidget {
  final Widget child;
  final double cellWidth;
  final double cellPadding;
  final double contactEdgesDistance;
  final Matrix matrix;
  final MatrixOrientation orientation;
  final double tipLength;
  final double tipAngle;
  final double maxScale;
  final double minScale;

  // Edge
  final EdgePaintBuilder? paintBuilder;
  final EdgePathBuilder? pathBuilder;

  final GestureEdgeTapDownCallback? onEdgeTapDown;
  final PaintingStyle? edgePaintStyleForTouch;

  final GestureTapCallback? onCanvasTap;
  final GestureEdgeTapUpCallback? onEdgeTapUp;
  final GestureEdgeLongPressStartCallback? onEdgeLongPressStart;

  final GestureEdgeLongPressEndCallback? onEdgeLongPressEnd;
  final GestureEdgeLongPressMoveUpdateCallback? onEdgeLongPressMoveUpdate;

  final GestureEdgeForcePressStartCallback? onEdgeForcePressStart;
  final GestureEdgeForcePressEndCallback? onEdgeForcePressEnd;

  final GestureEdgeForcePressPeakCallback? onEdgeForcePressPeak;
  final GestureEdgeForcePressUpdateCallback? onEdgeForcePressUpdate;

  final GestureEdgeDragStartCallback? onEdgePanStart;
  final GestureEdgeDragUpdateCallback? onEdgePanUpdate;

  final GestureEdgeDragDownCallback? onEdgePanDown;
  final GestureEdgeTapDownCallback? onEdgeSecondaryTapDown;

  final GestureEdgeTapUpCallback? onEdgeSecondaryTapUp;

  const GraphiteEdges({
    Key? key,
    required this.child,
    required this.cellWidth,
    required this.matrix,
    required this.cellPadding,
    required this.contactEdgesDistance,
    required this.orientation,
    required this.tipLength,
    required this.tipAngle,
    required this.maxScale,
    required this.minScale,
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
    this.onCanvasTap,
    this.paintBuilder,
    this.pathBuilder,
  }) : super(key: key);

  @override
  _GraphiteEdgesState createState() => _GraphiteEdgesState();
}

class _GraphiteEdgesState extends State<GraphiteEdges> {
  final StreamController<Gesture> touchController =
      StreamController.broadcast();
  StreamSubscription? streamSubscription;

  Future<void> addStreamListener(Function(Gesture) callBack) async {
    await streamSubscription?.cancel();
    streamSubscription = touchController.stream.listen(callBack);
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
            child: Stack(
              children: <Widget>[
                Container(
                  width: (widget.cellWidth * widget.matrix.width()).toDouble(),
                  height:
                      (widget.cellWidth * widget.matrix.height()).toDouble(),
                  child: Builder(builder: (ctx) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: LinesPainter(
                        ctx,
                        widget.matrix.normalize(),
                        widget.cellWidth,
                        widget.contactEdgesDistance ,
                        widget.orientation,
                        tipLength: widget.tipLength,
                        tipAngle: widget.tipAngle,
                        cellPadding: widget.cellPadding,
                        paintBuilder: widget.paintBuilder,
                        onEdgeTapDown: widget.onEdgeTapDown,
                        edgePaintStyleForTouch: widget.edgePaintStyleForTouch,
                        onEdgeTapUp: widget.onEdgeTapUp,
                        onEdgeLongPressStart: widget.onEdgeLongPressStart,
                        onEdgeLongPressEnd: widget.onEdgeLongPressEnd,
                        onEdgeLongPressMoveUpdate:
                            widget.onEdgeLongPressMoveUpdate,
                        onEdgeForcePressStart: widget.onEdgeForcePressStart,
                        onEdgeForcePressEnd: widget.onEdgeForcePressEnd,
                        onEdgeForcePressPeak: widget.onEdgeForcePressPeak,
                        onEdgeForcePressUpdate: widget.onEdgeForcePressUpdate,
                        onEdgePanStart: widget.onEdgePanStart,
                        onEdgePanUpdate: widget.onEdgePanUpdate,
                        onEdgePanDown: widget.onEdgePanDown,
                        onEdgeSecondaryTapDown: widget.onEdgeSecondaryTapDown,
                        onEdgeSecondaryTapUp: widget.onEdgeSecondaryTapUp,
                        pathBuilder: widget.pathBuilder,
                      ),
                    );
                  }),
                ),
                widget.child,
              ],
            ),
          ),
          onTap: () {
            if (widget.onCanvasTap != null) {
              widget.onCanvasTap!();
            }
          },
          onTapDown: (tapDetail) {
            touchController.add(Gesture(GestureType.onTapDown, tapDetail));
          },
          onTapUp: (tapDetail) {
            touchController.add(Gesture(GestureType.onTapUp, tapDetail));
          },
          onLongPressStart: (tapDetail) {
            touchController
                .add(Gesture(GestureType.onLongPressStart, tapDetail));
          },
          onLongPressEnd: (tapDetail) {
            touchController.add(Gesture(GestureType.onLongPressEnd, tapDetail));
          },
          onLongPressMoveUpdate: (tapDetail) {
            touchController
                .add(Gesture(GestureType.onLongPressMoveUpdate, tapDetail));
          },
          onForcePressStart: (tapDetail) {
            touchController
                .add(Gesture(GestureType.onForcePressStart, tapDetail));
          },
          onForcePressEnd: (tapDetail) {
            touchController
                .add(Gesture(GestureType.onForcePressEnd, tapDetail));
          },
          onForcePressPeak: (tapDetail) {
            touchController
                .add(Gesture(GestureType.onForcePressPeak, tapDetail));
          },
          onForcePressUpdate: (tapDetail) {
            touchController
                .add(Gesture(GestureType.onForcePressUpdate, tapDetail));
          },
          onPanStart: (tapDetail) {
            touchController.add(Gesture(GestureType.onPanStart, tapDetail));
          },
          onPanUpdate: (tapDetail) {
            touchController.add(Gesture(GestureType.onPanUpdate, tapDetail));
          },
          onPanDown: (tapDetail) {
            touchController.add(Gesture(GestureType.onPanDown, tapDetail));
          },
          onSecondaryTapDown: (tapDetail) {
            touchController
                .add(Gesture(GestureType.onSecondaryTapDown, tapDetail));
          },
          onSecondaryTapUp: (tapDetail) {
            touchController
                .add(Gesture(GestureType.onSecondaryTapUp, tapDetail));
          },
        ));
  }

  @override
  void dispose() {
    touchController.close();
    super.dispose();
  }
}

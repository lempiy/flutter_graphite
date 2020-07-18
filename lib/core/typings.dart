import 'package:meta/meta.dart';
import 'dart:convert';

enum NodeType {
  unknown,
  rootSimple,
  rootSplit,
  simple,
  split,
  join,
  splitJoin,
}

enum AnchorOrientation {
  none,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

enum AnchorMargin { none, start, end }

List<NodeInput> nodeInputFromJson(String str) =>
    List<NodeInput>.from(json.decode(str).map((x) => NodeInput.fromJson(x)));

String nodeInputToJson(List<NodeInput> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NodeInput {
  NodeInput({
    @required this.id,
    @required this.next,
  });

  final String id;
  final List<String> next;

  factory NodeInput.fromJson(Map<String, dynamic> json) => NodeInput(
        id: json["id"] == null ? null : json["id"],
        next: json["next"] == null
            ? null
            : List<String>.from(json["next"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "next": next == null ? null : List<dynamic>.from(next.map((x) => x)),
      };
}

enum AnchorType {
  unknown,
  join,
  split,
  loop,
}

class MatrixNode extends NodeOutput {
  MatrixNode({
    @required this.x,
    @required this.y,
    @required String id,
    @required List<String> next,
    AnchorType anchorType,
    String from,
    String to,
    AnchorOrientation orientation,
    bool isAnchor,
    AnchorMargin anchorMargin,
    List<String> passedIncomes,
    List<String> renderIncomes,
    int childrenOnMatrix,
  }) : super(
          id: id,
          next: next,
          anchorType: anchorType,
          from: from,
          to: to,
          orientation: orientation,
          isAnchor: isAnchor,
          anchorMargin: anchorMargin,
          passedIncomes: passedIncomes,
          renderIncomes: renderIncomes,
          childrenOnMatrix: childrenOnMatrix,
        );
  static MatrixNode fromNodeOutput(
      {@required int x, @required int y, @required NodeOutput nodeOutput}) {
    return MatrixNode(
      x: x,
      y: y,
      id: nodeOutput.id,
      next: nodeOutput.next,
      anchorType: nodeOutput.anchorType,
      from: nodeOutput.from,
      to: nodeOutput.to,
      orientation: nodeOutput.orientation,
      isAnchor: nodeOutput.isAnchor,
      anchorMargin: nodeOutput.anchorMargin,
      passedIncomes: nodeOutput.passedIncomes,
      renderIncomes: nodeOutput.renderIncomes,
      childrenOnMatrix: nodeOutput.childrenOnMatrix,
    );
  }

  final int x;
  final int y;
}

class NodeOutput extends NodeInput {
  NodeOutput({
    @required String id,
    @required List<String> next,
    this.anchorType,
    this.from,
    this.to,
    this.orientation,
    this.isAnchor,
    this.passedIncomes,
    this.renderIncomes,
    this.childrenOnMatrix,
    this.anchorMargin,
  }) : super(id: id, next: next);

  AnchorType anchorType;
  String from;
  String to;
  AnchorOrientation orientation;
  AnchorMargin anchorMargin;

  bool isAnchor;
  List<String> passedIncomes;
  List<String> renderIncomes;
  int childrenOnMatrix;
}

class LoopNode {
  LoopNode({
    this.id,
    this.node,
    this.x,
    this.y,
    this.isSelfLoop,
  });

  String id;
  NodeOutput node;
  int x;
  int y;
  bool isSelfLoop;
}

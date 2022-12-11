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

enum MatrixOrientation {
  Horizontal,
  Vertical,
}

List<NodeInput> nodeInputFromJson(String str) =>
    List<NodeInput>.from(json.decode(str).map((x) => NodeInput.fromJson(x)));

String nodeInputToJson(List<NodeInput> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

enum EdgeArrowType { none, one, both }

class EdgeInput {
  /// Input data for node's edge.
  /// [outcome] *unique* identifier of the outcome node. Outcome node should exist
  /// in [DirectGraph.list].
  /// [type] style of arrows to be drawn on the edge if [DirectGraph.pathBuilder] is not
  /// defined and default builder is used.
  EdgeInput({
    required this.outcome,
    this.type = EdgeArrowType.one,
  });

  /// [outcome] *unique* identifier of the outcome node. Outcome node should exist
  /// in [DirectGraph.list].
  final String outcome;

  /// style of arrows to be drawn on the edge
  /// [EdgeArrowType.none] draw no arrows.
  /// [EdgeArrowType.one] draw arrow only at the end of the edge.
  /// [EdgeArrowType.both] draw arrows on both sides of the edge.
  final EdgeArrowType type;

  factory EdgeInput.fromJson(Map<String, dynamic> json) => EdgeInput(
        outcome: json["outcome"] == null ? null : json["outcome"],
        type: json["type"] == null
            ? EdgeArrowType.one
            : EdgeInput.typeFromString(json["type"]),
      );

  static EdgeArrowType typeFromString(String typeAsString) {
    switch (typeAsString) {
      case "both":
        return EdgeArrowType.both;
      case "none":
        return EdgeArrowType.none;
      default:
        return EdgeArrowType.one;
    }
  }

  String typeToString() {
    switch (type) {
      case EdgeArrowType.both:
        return "both";
      case EdgeArrowType.none:
        return "none";
      default:
        return "one";
    }
  }

  Map<String, dynamic> toJson() => {
        "outcome": outcome,
        "type": typeToString(),
      };
}

class NodeSize {
  final double width;
  final double height;

  const NodeSize({
    required this.width,
    required this.height,
  });

  factory NodeSize.fromJson(Map<String, dynamic> json) => NodeSize(
        width: json["width"] == null ? 0 : (json["width"] as double),
        height: json["height"] == null ? 0 : (json["height"] as double),
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
      };
}

class NodeInput {
  /// Input data for graphite graph's node.
  /// [id] *unique* id of the node.
  /// [next] outcomes list for the node defined as list of [EdgeInput]'s.
  /// custom [size] of the node to override [DirectGraph.defaultCellSize].
  NodeInput({
    required this.id,
    required this.next,
    this.size,
  });

  /// [NodeSize] of the node to override [DirectGraph.defaultCellSize] .
  final NodeSize? size;

  /// *unique* identifier of the node.
  final String id;

  /// outcomes list for the node defined as list of [EdgeInput]'s.
  final List<EdgeInput> next;

  double? getWidth() {
    return size == null ? 0 : size!.width;
  }

  double? getHeight() {
    return size == null ? 0 : size!.height;
  }

  factory NodeInput.fromJson(Map<String, dynamic> json) => NodeInput(
      id: json["id"] == null ? null : json["id"],
      next:
          List<EdgeInput>.from(json["next"].map((x) => EdgeInput.fromJson(x))),
      size: json["size"] == null ? null : NodeSize.fromJson(json["size"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "next": List<dynamic>.from(next.map((x) => x.toJson())),
        "size": size == null ? null : size!.toJson(),
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
    required this.x,
    required this.y,
    required String id,
    required List<EdgeInput> next,
    NodeSize? size,
    AnchorType? anchorType,
    String? from,
    String? to,
    AnchorOrientation? orientation,
    bool isAnchor = false,
    AnchorMargin? anchorMargin,
    List<String> passedIncomes = const [],
    List<String> renderIncomes = const [],
    int? childrenOnMatrix,
  }) : super(
          id: id,
          next: next,
          size: size,
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
      {required int x, required int y, required NodeOutput nodeOutput}) {
    return MatrixNode(
      x: x,
      y: y,
      size: nodeOutput.size,
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

  /// column index of node inside two dimensional matrix
  final int x;

  /// row index of node inside two dimensional matrix
  final int y;

  NodeInput toInput() {
    return NodeInput(id: id, next: next, size: size);
  }
}

class NodeOutput extends NodeInput {
  NodeOutput({
    required String id,
    required List<EdgeInput> next,
    NodeSize? size,
    this.anchorType,
    this.from,
    this.to,
    this.orientation,
    this.isAnchor = false,
    this.passedIncomes = const [],
    this.renderIncomes = const [],
    this.childrenOnMatrix,
    this.anchorMargin,
  }) : super(id: id, next: next, size: size);

  Map<AnchorMargin, NodeOutput> anchors = {};
  NodeOutput? node;

  AnchorType? anchorType;
  String? from;
  String? to;
  AnchorOrientation? orientation;
  AnchorMargin? anchorMargin;

  bool isAnchor;
  List<String> passedIncomes = [];
  List<String> renderIncomes = [];
  int? childrenOnMatrix;
}

class LoopNode {
  LoopNode({
    required this.id,
    required this.node,
    required this.x,
    required this.y,
    this.isSelfLoop = false,
  });

  String id;
  NodeOutput node;
  int x;
  int y;
  bool isSelfLoop;
}

class Edge {
  final List<List<double>> points;
  final MatrixNode from;
  final MatrixNode to;
  final EdgeArrowType arrowType;

  Edge(this.points, this.from, this.to, this.arrowType);
}

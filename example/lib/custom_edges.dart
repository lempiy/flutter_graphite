import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';

const presetComplex = '['
    '{"id":"A","next":[{"outcome":"B","type":"one"}]},'
    '{"id":"U","next":[{"outcome":"G","type":"one"}]},'
    '{"id":"B","next":[{"outcome":"C","type":"one"},{"outcome":"D","type":"one"},{"outcome":"E","type":"one"},{"outcome":"F","type":"one"},{"outcome":"M","type":"one"}]},'
    '{"id":"C","next":[{"outcome":"G","type":"one"}]},'
    '{"id":"D","next":[{"outcome":"H","type":"one"}]},'
    '{"id":"E","next":[{"outcome":"H","type":"one"}]},'
    '{"id":"F","next":[{"outcome":"W","type":"one"},{"outcome":"N","type":"one"},{"outcome":"O","type":"one"}]},'
    '{"id":"W","next":[]},'
    '{"id":"N","next":[{"outcome":"I","type":"one"}]},'
    '{"id":"O","next":[{"outcome":"P","type":"one"}]},'
    '{"id":"P","next":[{"outcome":"I","type":"one"}]},'
    '{"id":"M","next":[{"outcome":"L","type":"one"}]},'
    '{"id":"G","next":[{"outcome":"I","type":"one"}]},'
    '{"id":"H","next":[{"outcome":"J","type":"one"}]},'
    '{"id":"I","next":[]},'
    '{"id":"J","next":[{"outcome":"K","type":"one"}]},'
    '{"id":"K","next":[{"outcome":"L","type":"one"}]},'
    '{"id":"L","next":[]}'
    ']';

class CustomEdgesPage extends StatefulWidget {
  final Widget Function(BuildContext context) bottomBar;

  const CustomEdgesPage({Key? key, required this.bottomBar}) : super(key: key);
  @override
  CustomEdgesPageState createState() {
    return CustomEdgesPageState();
  }
}

class CustomEdgesPageState extends State<CustomEdgesPage> {
  List<NodeInput> list = nodeInputFromJson(presetComplex);
  Map<String, bool> selected = {};
  void _onItemSelected(String nodeId) {
    setState(() {
      selected[nodeId] =
          selected[nodeId] == null || !selected[nodeId]! ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          leading: const Icon(Icons.view_comfy),
          title: const Text('Custom Edges Example')),
      body: InteractiveViewer(
        constrained: false,
        child: DirectGraph(
          list: list,
          defaultCellSize: const Size(104.0, 104.0),
          cellPadding: const EdgeInsets.all(14),
          contactEdgesDistance: 5.0,
          orientation: MatrixOrientation.Vertical,
          centered: false,
          onEdgeTapDown: (details, edge) {
            print("${edge.from.id}->${edge.to.id}");
          },
          nodeBuilder: (ctx, node) {
            return Card(
              child: Center(
                child: Text(
                  node.id,
                  style: selected[node.id] ?? false
                      ? const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)
                      : const TextStyle(fontSize: 20.0),
                ),
              ),
            );
          },
          styleBuilder: (edge) {
            var p = Paint()
              ..color = Colors.blueGrey
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round
              ..strokeWidth = 2;
            LineStyle lineStyle = LineStyle.solid;
            switch (edge.from.id) {
              case "U":
                lineStyle = LineStyle.dotted;
                break;
              case "C":
                lineStyle = LineStyle.dashed;
                break;
              case "M":
                lineStyle = LineStyle.dashDotted;
                break;
            }
            if ((selected[edge.from.id] ?? false) &&
                (selected[edge.to.id] ?? false)) {
              p.color = Colors.red;
            }
            return EdgeStyle(
                lineStyle: lineStyle, borderRadius: 40, linePaint: p);
          },
          onNodeTapDown: (_, node, __) {
            _onItemSelected(node.id);
          },
        ),
      ),
      bottomNavigationBar: widget.bottomBar(context),
    );
  }
}

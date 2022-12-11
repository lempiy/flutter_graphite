import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';
import 'dart:math';

List<NodeInput> flowChart = [
  NodeInput(id: "start", next: [EdgeInput(outcome: "process")]),
  NodeInput(id: "documents", next: [EdgeInput(outcome: "process")]),
  NodeInput(id: "process", next: [EdgeInput(outcome: "decision")]),
  NodeInput(
      id: "decision",
      size: const NodeSize(width: 100, height: 100),
      next: [EdgeInput(outcome: "processA"), EdgeInput(outcome: "processB")]),
  NodeInput(id: "processA", next: [EdgeInput(outcome: "end")]),
  NodeInput(id: "processB", next: [EdgeInput(outcome: "end")]),
  NodeInput(id: "end", next: []),
];

enum FlowStepType { start, documents, decision, process, end }

class FlowStep {
  final String text;
  final FlowStepType type;

  FlowStep({required this.text, required this.type});
}

Map<String, FlowStep> data = {
  "start": FlowStep(text: "Start", type: FlowStepType.start),
  "documents": FlowStep(text: "Documents", type: FlowStepType.documents),
  "process": FlowStep(text: "Process", type: FlowStepType.process),
  "decision": FlowStep(text: "Decision", type: FlowStepType.decision),
  "processA": FlowStep(text: "Process A", type: FlowStepType.process),
  "processB": FlowStep(text: "Process B", type: FlowStepType.process),
  "end": FlowStep(text: "End", type: FlowStepType.end),
};

class FlowchartPage extends StatefulWidget {
  final Widget Function(BuildContext context) bottomBar;

  const FlowchartPage({Key? key, required this.bottomBar}) : super(key: key);
  @override
  FlowchartPageState createState() => FlowchartPageState();
}

class FlowchartPageState extends State<FlowchartPage> {
  _buildNode(NodeInput node) {
    final info = data[node.id]!;
    switch (info.type) {
      case FlowStepType.start:
        return Start(data: info);
      case FlowStepType.documents:
        return Document(data: info);
      case FlowStepType.decision:
        return Decision(data: info);
      case FlowStepType.process:
        return Process(data: info);
      case FlowStepType.end:
        return End(data: info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = flowChart;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.view_module),
          title: const Text('Flowchart Example')),
      body: Stack(
        children: [
          DirectGraph(
            list: list,
            defaultCellSize: const Size(250.0, 100.0),
            cellPadding:
                const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
            contactEdgesDistance: 0,
            orientation: MatrixOrientation.Vertical,
            nodeBuilder: (BuildContext context, NodeInput node) => Padding(
                padding: const EdgeInsets.all(5), child: _buildNode(node)),
            contentWrapperBuilder:
                (BuildContext context, Size contentSize, Widget child) =>
                    SizedBox(
              width: max(screenSize.width, contentSize.width),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child,
                ],
              ),
            ),
            centered: true,
            minScale: .1,
            maxScale: 1,
          ),
        ],
      ),
      bottomNavigationBar: widget.bottomBar(context),
    );
  }
}

class Start extends StatelessWidget {
  final FlowStep data;

  const Start({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: Colors.green),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        color: Colors.greenAccent,
      ),
      child: Center(
        child: Text(
          data.text,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}

class Document extends StatelessWidget {
  final FlowStep data;

  const Document({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.grey,
      ),
      child: Center(
        child: Text(
          data.text,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}

class Process extends StatelessWidget {
  final FlowStep data;

  const Process({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: Colors.orange),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.orangeAccent,
      ),
      child: Center(
        child: Text(
          data.text,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}

class Decision extends StatelessWidget {
  final FlowStep data;

  const Decision({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Colors.deepOrangeAccent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.orangeAccent,
            ),
          ),
        ),
        SizedBox(
          child: Center(
            child: Text(
              data.text,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        )
      ],
    );
  }
}

class End extends StatelessWidget {
  final FlowStep data;

  const End({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: Colors.red),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        color: Colors.redAccent,
      ),
      child: Center(
        child: Text(
          data.text,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}

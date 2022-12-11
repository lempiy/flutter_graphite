import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';

class DigimonData {
  final String imageUrl;
  final String title;
  final int level;

  DigimonData(
      {required this.imageUrl, required this.title, required this.level});
}

Map<String, DigimonData> data = {
  "botomon":
      DigimonData(title: "Botomon", level: 0, imageUrl: "assets/botomon.jpeg"),
  "koromon":
      DigimonData(title: "Koromon", level: 1, imageUrl: "assets/koromon.jpeg"),
  "agumon":
      DigimonData(title: "Agumon", level: 2, imageUrl: "assets/Agumon.jpeg"),
  "agumon_savers": DigimonData(
      title: "Agumon (Savers)",
      level: 2,
      imageUrl: "assets/Agumon(savers).jpeg"),
  "greymon":
      DigimonData(title: "Greymon", level: 3, imageUrl: "assets/Greymon.jpeg"),
  "tyranomon": DigimonData(
      title: "Tyranomon", level: 3, imageUrl: "assets/Tyranomon.jpeg"),
  "geo_greymon": DigimonData(
      title: "Geo-Greymon", level: 3, imageUrl: "assets/GeoGreymon.jpeg"),
  "agumon_burst": DigimonData(
      title: "Agumon (Burst mode)",
      level: 3,
      imageUrl: "assets/Agumon(Burst).png"),
  "metal_greymon": DigimonData(
      title: "Metal Greymon", level: 4, imageUrl: "assets/MetalGreymon.jpeg"),
  "master_tyranomon": DigimonData(
      title: "Master Greymon",
      level: 4,
      imageUrl: "assets/MasterTyranomon.jpeg"),
  "goldromon": DigimonData(
      title: "Goldromon", level: 5, imageUrl: "assets/Goddramon.jpeg"),
  "rize_greymon": DigimonData(
      title: "Rize Greymon", level: 4, imageUrl: "assets/RizeGreymon.jpeg"),
  "shine_greymon": DigimonData(
      title: "Shine Greymon", level: 6, imageUrl: "assets/ShineGreymon.jpeg"),
  "war_greymon": DigimonData(
      title: "War Greymon", level: 6, imageUrl: "assets/WarGreymon.jpeg"),
  "skull_greymon": DigimonData(
      title: "Skull Greymon", level: 4, imageUrl: "assets/SkullGreymon.jpeg"),
  "ancient_greymon": DigimonData(
      title: "Ancient Greymon",
      level: 6,
      imageUrl: "assets/AncientGreymon.jpeg"),
  "victory_greymon": DigimonData(
      title: "Victory Greymon",
      level: 7,
      imageUrl: "assets/VictoryGreymon.jpeg"),
  "shine_greymon_burst": DigimonData(
      title: "Shine Greymon (Burst mode)",
      level: 7,
      imageUrl: "assets/ShineGreymonBurstMode.jpeg"),
  "shine_greymon_ruin": DigimonData(
      title: "Shine Greymon (Ruin mode)",
      level: 7,
      imageUrl: "assets/ShineGreymonRuinMode.jpeg"),
};

List<NodeInput> imagePreset = [
  NodeInput(
      id: "botomon",
      size: const NodeSize(width: 50, height: 50),
      next: [EdgeInput(outcome: "koromon", type: EdgeArrowType.one)]),
  NodeInput(
      id: "koromon",
      size: const NodeSize(width: 100, height: 100),
      next: [
        EdgeInput(outcome: "agumon", type: EdgeArrowType.one),
        EdgeInput(outcome: "agumon_savers", type: EdgeArrowType.one)
      ]),
  NodeInput(id: "agumon", size: const NodeSize(width: 120, height: 120), next: [
    EdgeInput(outcome: "greymon", type: EdgeArrowType.one),
    EdgeInput(outcome: "tyranomon", type: EdgeArrowType.one),
    EdgeInput(outcome: "geo_greymon", type: EdgeArrowType.one),
    EdgeInput(outcome: "agumon_burst", type: EdgeArrowType.one)
  ]),
  NodeInput(
      id: "agumon_savers",
      size: const NodeSize(width: 120, height: 120),
      next: [
        EdgeInput(outcome: "geo_greymon", type: EdgeArrowType.one),
        EdgeInput(outcome: "agumon_burst", type: EdgeArrowType.both)
      ]),
  NodeInput(
      id: "greymon",
      size: const NodeSize(width: 180, height: 180),
      next: [
        EdgeInput(outcome: "metal_greymon", type: EdgeArrowType.one),
        EdgeInput(outcome: "skull_greymon", type: EdgeArrowType.one)
      ]),
  NodeInput(
      id: "tyranomon",
      size: const NodeSize(width: 140, height: 140),
      next: [EdgeInput(outcome: "master_tyranomon", type: EdgeArrowType.one)]),
  NodeInput(
      id: "geo_greymon",
      size: const NodeSize(width: 180, height: 180),
      next: [EdgeInput(outcome: "rize_greymon", type: EdgeArrowType.one)]),
  NodeInput(
      id: "agumon_burst",
      size: const NodeSize(width: 140, height: 140),
      next: [EdgeInput(outcome: "rize_greymon", type: EdgeArrowType.one)]),
  NodeInput(
      id: "metal_greymon",
      size: const NodeSize(width: 180, height: 180),
      next: [
        EdgeInput(outcome: "war_greymon", type: EdgeArrowType.one),
        EdgeInput(outcome: "ancient_greymon", type: EdgeArrowType.one)
      ]),
  NodeInput(
      id: "skull_greymon",
      size: const NodeSize(width: 180, height: 180),
      next: [EdgeInput(outcome: "war_greymon", type: EdgeArrowType.one)]),
  NodeInput(
      id: "master_tyranomon",
      size: const NodeSize(width: 160, height: 160),
      next: [EdgeInput(outcome: "goldromon", type: EdgeArrowType.one)]),
  NodeInput(
      id: "goldromon", size: const NodeSize(width: 320, height: 320), next: []),
  NodeInput(
      id: "rize_greymon",
      size: const NodeSize(width: 260, height: 260),
      next: [
        EdgeInput(outcome: "victory_greymon", type: EdgeArrowType.one),
        EdgeInput(outcome: "shine_greymon", type: EdgeArrowType.one)
      ]),
  NodeInput(
      id: "shine_greymon",
      size: const NodeSize(width: 300, height: 300),
      next: [
        EdgeInput(outcome: "shine_greymon_burst", type: EdgeArrowType.one),
        EdgeInput(outcome: "shine_greymon_ruin", type: EdgeArrowType.one)
      ]),
  NodeInput(
      id: "shine_greymon_burst",
      size: const NodeSize(width: 300, height: 300),
      next: []),
  NodeInput(
      id: "shine_greymon_ruin",
      size: const NodeSize(width: 300, height: 300),
      next: []),
  NodeInput(
      id: "war_greymon",
      size: const NodeSize(width: 220, height: 220),
      next: [EdgeInput(outcome: "victory_greymon", type: EdgeArrowType.one)]),
  NodeInput(
      id: "ancient_greymon",
      size: const NodeSize(width: 300, height: 300),
      next: []),
  NodeInput(
      id: "victory_greymon",
      size: const NodeSize(width: 360, height: 360),
      next: []),
];

class CurrentNodeInfo {
  final NodeInput node;
  final Rect rect;
  final DigimonData data;

  CurrentNodeInfo({required this.node, required this.rect, required this.data});
}

class DigimonPage extends StatefulWidget {
  final Widget Function(BuildContext context) bottomBar;

  const DigimonPage({Key? key, required this.bottomBar}) : super(key: key);
  @override
  DigimonPageState createState() => DigimonPageState();
}

class DigimonPageState extends State<DigimonPage>
    with SingleTickerProviderStateMixin {
  CurrentNodeInfo? _currentNodeInfo;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _tooltip(BuildContext context) {
    const tooltipHeight = 75.0;
    const maxWidth = 310.0;
    _animationController.reset();
    _animationController.forward();
    return Positioned(
        top: _currentNodeInfo!.rect.top - tooltipHeight,
        left: _currentNodeInfo!.rect.left +
            _currentNodeInfo!.rect.width * .5 -
            maxWidth * .5,
        child: SizedBox(
          width: maxWidth,
          height: tooltipHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(225),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          _currentNodeInfo!.data.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          "Level: ${_currentNodeInfo!.data.level}",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> _buildOverlay(
      BuildContext context, List<NodeInput> nodes, List<Edge> edges) {
    return _currentNodeInfo == null ? [] : [_tooltip(context)];
  }

  _onNodeTap(TapUpDetails details, NodeInput node, Rect nodeRect) {
    setState(() {
      _currentNodeInfo =
          CurrentNodeInfo(node: node, rect: nodeRect, data: data[node.id]!);
    });
  }

  _onCanvasTap() {
    setState(() {
      _currentNodeInfo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.view_module),
          title: const Text('Overlays Example')),
      body: Container(
        color: Colors.white,
        child: DirectGraph(
          list: imagePreset,
          defaultCellSize: const Size(100.0, 100.0),
          cellPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          contactEdgesDistance: 5.0,
          orientation: MatrixOrientation.Horizontal,
          clipBehavior: Clip.none,
          centered: true,
          minScale: .1,
          maxScale: 3,
          overlayBuilder:
              (BuildContext context, List<NodeInput> nodes, List<Edge> edges) =>
                  _buildOverlay(context, nodes, edges),
          contentWrapperBuilder:
              (BuildContext context, Size size, Widget child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: child),
          onCanvasTap: _onCanvasTap,
          onNodeTapUp: _onNodeTap,
          nodeBuilder: (BuildContext context, NodeInput node) => FittedBox(
            child: Image.asset(data[node.id]!.imageUrl),
            //child: Image.asset(data[node.id]!.imageUrl),
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomBar(context),
    );
  }
}

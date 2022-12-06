import 'package:flutter/material.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';

void main() => runApp(const MyApp());
const presetBasic =
    '[{"id":"A","next":[{"outcome":"B","type":"one"}],"size":{"width": 75.0, "height": 75.0}},{"id":"B","size":{"width": 200.0, "height": 50.0},"next":[{"outcome":"C","type":"one"},{"outcome":"D","type":"one"},{"outcome":"E","type":"one"}]},{"id":"C","next":[{"outcome":"F","type":"one"}]},{"id":"D","next":[{"outcome":"J","type":"one"}],"size":{"width": 25.0, "height": 175.0}},{"id":"E","next":[{"outcome":"J","type":"one"}]},{"id":"J","size": {"width": 75.0, "height": 75.0},"next":[{"outcome":"I","type":"one"}]},{"id":"I","next":[{"outcome":"H","type":"one"}]},{"id":"F","next":[{"outcome":"K","type":"one"}]},{"id":"K","size":{"width":50.0,"height":50.0},"next":[{"outcome":"L","type":"one"},{"outcome":"C","type":"one"}]},{"id":"H","next":[{"outcome":"L","type":"one"}]},{"id":"L","next":[{"outcome":"P","type":"one"}]},{"id":"P","next":[{"outcome":"M","type":"one"},{"outcome":"N","type":"one"}]},{"id":"M","next":[]},{"id":"N","next":[]}]';

const presetComplex =
    '[{"id":"A","next":[{"outcome":"B","type":"one"}]},{"id":"U","next":[{"outcome":"G","type":"one"}]},{"id":"B","next":[{"outcome":"C","type":"one"},{"outcome":"D","type":"one"},{"outcome":"E","type":"one"},{"outcome":"F","type":"one"},{"outcome":"M","type":"one"}]},{"id":"C","next":[{"outcome":"G","type":"one"}]},{"id":"D","next":[{"outcome":"H","type":"one"}]},{"id":"E","next":[{"outcome":"H","type":"one"}]},{"id":"F","next":[{"outcome":"W","type":"one"},{"outcome":"N","type":"one"},{"outcome":"O","type":"one"}]},{"id":"W","next":[]},{"id":"N","next":[{"outcome":"I","type":"one"}]},{"id":"O","next":[{"outcome":"P","type":"one"}]},{"id":"P","next":[{"outcome":"I","type":"one"}]},{"id":"M","next":[{"outcome":"L","type":"one"}]},{"id":"G","next":[{"outcome":"I","type":"one"}]},{"id":"H","next":[{"outcome":"J","type":"one"}]},{"id":"I","next":[]},{"id":"J","next":[{"outcome":"K","type":"one"}]},{"id":"K","next":[{"outcome":"L","type":"one"}]},{"id":"L","next":[]}]';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Graphite',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Colors.white,
      ),
      home: const BasicPage(),
      routes: routes,
    );
  }
}

class BasicPage extends StatefulWidget {
  const BasicPage({Key? key}) : super(key: key);
  @override
  BasicPageState createState() => BasicPageState();
}

class BasicPageState extends State<BasicPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (_, __, ___) => [
                  const BasicPage(),
                  const ImagePage(),
                  const CustomPage()
                ][index]));
  }

  @override
  Widget build(BuildContext context) {
    var list = nodeInputFromJson(presetBasic);
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.view_module),
          title: const Text('Basic Example')),
      body: DirectGraph(
        list: list,
        defaultCellWidth: 100.0,
        defaultCellHeight: 100.0,
        cellPadding: 15.0,
        contactEdgesDistance: 5.0,
        orientation: MatrixOrientation.Vertical,
        centered: true,
        minScale: 1,
        maxScale: 1,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module),
            label: 'Basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_comfy),
            label: 'Custom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);
  @override
  ImagePageState createState() => ImagePageState();
}

class CurrentNodeInfo {
  final MatrixNode node;
  final Rect rect;
  final DigimonData data;

  CurrentNodeInfo({required this.node, required this.rect, required this.data});
}

class ImagePageState extends State<ImagePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (_, __, ___) => [
                  const BasicPage(),
                  const ImagePage(),
                  const CustomPage()
                ][index]));
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

  Widget _buildOverlay(BuildContext context) {
    return _currentNodeInfo == null ? Container() : _tooltip(context);
  }

  _onNodeTap(TapUpDetails details, MatrixNode node, Rect nodeRect) {
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
          title: const Text('Image Example')),
      body: Container(
        color: Colors.white,
        child: DirectGraph(
          list: imagePreset,
          defaultCellWidth: 100.0,
          defaultCellHeight: 100.0,
          cellPadding: 25.0,
          contactEdgesDistance: 5.0,
          orientation: MatrixOrientation.Horizontal,
          centered: true,
          minScale: .1,
          maxScale: 3,
          overlayBuilder: (BuildContext context) => _buildOverlay(context),
          onCanvasTap: _onCanvasTap,
          onNodeTapUp: _onNodeTap,
          builder: (BuildContext context, MatrixNode node) => FittedBox(
            child: Image.asset(data[node.id]!.imageUrl),
            //child: Image.asset(data[node.id]!.imageUrl),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module),
            label: 'Basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_comfy),
            label: 'Custom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class CustomPage extends StatefulWidget {
  const CustomPage({Key? key}) : super(key: key);
  @override
  CustomPageState createState() {
    return CustomPageState();
  }
}

class CustomPageState extends State<CustomPage> {
  List<NodeInput> list = nodeInputFromJson(presetComplex);
  int _selectedIndex = 2;
  Map<String, bool> selected = {};
  void _onItemSelected(String nodeId) {
    setState(() {
      selected[nodeId] =
          selected[nodeId] == null || !selected[nodeId]! ? true : false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (_, __, ___) => [
                  const BasicPage(),
                  const ImagePage(),
                  const CustomPage()
                ][index]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          leading: const Icon(Icons.view_comfy),
          title: const Text('Custom Example')),
      body: DirectGraph(
        list: list,
        defaultCellWidth: 104.0,
        defaultCellHeight: 104.0,
        cellPadding: 14.0,
        contactEdgesDistance: 5.0,
        orientation: MatrixOrientation.Vertical,
        pathBuilder: customEdgePathBuilder,
        centered: false,
        builder: (ctx, node) {
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
        paintBuilder: (edge) {
          var p = Paint()
            ..color = Colors.blueGrey
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 2;
          if ((selected[edge.from.id] ?? false) &&
              (selected[edge.to.id] ?? false)) {
            p.color = Colors.red;
          }
          return p;
        },
        onNodeTapDown: (_, node, __) {
          _onItemSelected(node.id);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module),
            label: 'Basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_comfy),
            label: 'Custom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/home': (BuildContext context) => const BasicPage(),
  '/image': (BuildContext context) => const ImagePage(),
  '/complex': (BuildContext context) => const CustomPage(),
};

Path customEdgePathBuilder(NodeInput from, NodeInput to,
    List<List<double>> points, EdgeArrowType arrowType) {
  var path = Path();
  path.moveTo(points[0][0], points[0][1]);
  points.sublist(1).forEach((p) {
    path.lineTo(p[0], p[1]);
  });
  return path;
}

import 'package:flutter/material.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/graphite.dart';

void main() => runApp(MyApp());
const presetBasic = '[{"id":"A","next":["B"]},{"id":"B","next":["C","D","E"]},'
    '{"id":"C","next":["F"]},{"id":"D","next":["J"]},{"id":"E","next":["J"]},'
    '{"id":"J","next":["I"]},{"id":"I","next":["H"]},{"id":"F","next":["K"]},'
    '{"id":"K","next":["L"]},{"id":"H","next":["L"]},{"id":"L","next":["P"]},'
    '{"id":"P","next":["M","N"]},{"id":"M","next":[]},{"id":"N","next":[]}]';

const presetComplex = '[{"id":"A","next":["B"]},{"id":"U","next":["G"]},'
    '{"id":"B","next":["C","D","E","F","M"]},{"id":"C","next":["G"]},'
    '{"id":"D","next":["H"]},{"id":"E","next":["H"]},{"id":"F","next":["N","O"]},'
    '{"id":"N","next":["I"]},{"id":"O","next":["P"]},{"id":"P","next":["I"]},'
    '{"id":"M","next":["L"]},{"id":"G","next":["I"]},{"id":"H","next":["J"]},'
    '{"id":"I","next":[]},{"id":"J","next":["K"]},'
    '{"id":"K","next":["L"]},{"id":"L","next":[]}]';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Graphite',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BasicPage(),
      routes: routes,
    );
  }
}

class BasicPage extends StatefulWidget {
  BasicPage({Key key}) : super(key: key);
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (_, __, ___) =>
                index == 0 ? BasicPage() : CustomPage()));
  }

  @override
  Widget build(BuildContext context) {
    var list = nodeInputFromJson(presetBasic);
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.view_module), title: Text('Basic Example')),
      body: DirectGraph(
        list: list,
        cellWidth: 136.0,
        cellPadding: 24.0,
        contactEdgesDistance: 10.0,
        orientation: MatrixOrientation.Vertical,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module),
            title: Text('Basic'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_comfy),
            title: Text('Custom'),
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
  CustomPage({Key key}) : super(key: key);
  @override
  _CustomPageState createState() {
    return _CustomPageState();
  }
}

class _CustomPageState extends State<CustomPage> {
  List<NodeInput> list = nodeInputFromJson(presetComplex);
  int _selectedIndex = 1;
  Map<String, bool> selected = {};
  void _onItemSelected(String nodeId) {
    setState(() {
      selected[nodeId] =
          selected[nodeId] == null || !selected[nodeId] ? true : false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    var nextPage = index == 0 ? BasicPage : CustomPage;
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (_, __, ___) =>
                index == 0 ? BasicPage() : CustomPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          leading: Icon(Icons.view_comfy), title: Text('Custom Example')),
      body: DirectGraph(
        list: list,
        cellWidth: 104.0,
        cellPadding: 14.0,
        contactEdgesDistance: 5.0,
        orientation: MatrixOrientation.Vertical,
        builder: (ctx, node) {
          return Card(
            child: Center(
              child: Text(
                node.id,
                style: selected[node.id] ?? false
                    ? TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)
                    : TextStyle(fontSize: 20.0),
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
        onNodeTapDown: (_, node) {
          _onItemSelected(node.id);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module),
            title: Text('Basic'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_comfy),
            title: Text('Custom'),
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
  '/home': (BuildContext context) => BasicPage(),
  '/complex': (BuildContext context) => CustomPage(),
};

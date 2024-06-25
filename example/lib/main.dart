import 'package:example/flowchart.dart';
import 'package:example/labels.dart';
import 'package:example/custom_edges.dart';
import 'package:example/digimon.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onChangePage(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
              pageBuilder: (_, __, ___) => [
                    FlowchartPage(bottomBar: _buildBottomBar),
                    LabelsPage(bottomBar: _buildBottomBar),
                    DigimonPage(bottomBar: _buildBottomBar),
                    CustomEdgesPage(bottomBar: _buildBottomBar)
                  ][index]));
    });
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon:
              Icon(Icons.account_tree, color: Theme.of(context).disabledColor),
          activeIcon:
              Icon(Icons.account_tree, color: Theme.of(context).primaryColor),
          label: 'Flowchart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.text_format_outlined,
              color: Theme.of(context).disabledColor),
          activeIcon: Icon(Icons.text_format_outlined,
              color: Theme.of(context).primaryColor),
          label: 'Labels',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.layers, color: Theme.of(context).disabledColor),
          activeIcon: Icon(Icons.layers, color: Theme.of(context).primaryColor),
          label: 'Overlays',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stacked_line_chart,
              color: Theme.of(context).disabledColor),
          activeIcon: Icon(Icons.stacked_line_chart,
              color: Theme.of(context).primaryColor),
          label: 'Edges',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal[800],
      onTap: (index) => _onChangePage(context, index),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Graphite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.teal, backgroundColor: Colors.white)
            .copyWith(surface: Colors.white),
      ),
      home: FlowchartPage(bottomBar: _buildBottomBar),
      routes: <String, WidgetBuilder>{
        '/flowchart': (BuildContext context) =>
            FlowchartPage(bottomBar: _buildBottomBar),
        '/labels': (BuildContext context) =>
            LabelsPage(bottomBar: _buildBottomBar),
        '/digimon': (BuildContext context) =>
            DigimonPage(bottomBar: _buildBottomBar),
        '/complex': (BuildContext context) =>
            CustomEdgesPage(bottomBar: _buildBottomBar),
      },
    );
  }
}

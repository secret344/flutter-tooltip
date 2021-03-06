import 'package:flutter/material.dart';
import 'package:metooltip/metooltip.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            MeTooltip(
              message: "This is a top tooltip",
              child: Text("Top tooltip"),
              preferOri: PreferOrientation.up,
            ),
            MeTooltip(
              message: "This is a right tooltip",
              child: Text("right tooltip"),
              allOffset: 50,
              preferOri: PreferOrientation.right,
            ),
            MeTooltip(
              message: "This is a bottom tooltip",
              child: Text("bottom tooltip"),
              preferOri: PreferOrientation.down,
            ),
            MeTooltip(
              message: "This is a left tooltip",
              child: Text("left tooltip"),
              allOffset: 50,
              preferOri: PreferOrientation.left,
            ),
            MeTooltip(
              message:
                  "This is a top tooltip,This is a top tooltip,This is a top tooltip,This is a top tooltip",
              child: Text("Top tooltip"),
              preferOri: PreferOrientation.up,
            ),
            MeTooltip(
              message:
                  "This is a right tooltip,This is a right tooltip,This is a right tooltip,This is a right tooltip",
              allOffset: 50,
              child: Text("right tooltip"),
              preferOri: PreferOrientation.right,
            ),
            MeTooltip(
              message:
                  "This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip",
              child: Text("bottom tooltip"),
              preferOri: PreferOrientation.down,
            ),
            MeTooltip(
              message:
                  "This is a left tooltip,This is a left tooltip,This is a left tooltip,This is a left tooltip",
              allOffset: 50,
              child: Text("left tooltip"),
              preferOri: PreferOrientation.left,
            ),
          ],
        ),
      ),
    );
  }
}

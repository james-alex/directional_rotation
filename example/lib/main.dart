import 'dart:math';
import 'package:flutter/material.dart';
import 'package:directional_rotation/directional_rotation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DirectionalRotation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'DirectionalRotation'),
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
  /// The angle applied to the child.
  int angle = 0;

  /// Sets [angle] randomly between `0.0` and `360.0`.
  void randomizeAngle() {
    angle = Random().nextInt(360);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: DirectionalRotation(
                angle: angle,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  color: Colors.blue,
                ),
              ),
            ),
            Text('Current Angle: $angle°'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: randomizeAngle,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

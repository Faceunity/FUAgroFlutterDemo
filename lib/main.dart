import 'package:flutter/material.dart';

import 'room.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage('Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('测试'),
      ),
      body: FURoomInfo(),
      // body: LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     _controller.updateSize(constraints.maxWidth, constraints.maxHeight);
      //     return Stack(
      //       children: [
      //         CameraWidget(_controller, 'perview'),
      //         SafeArea(child: FaceunityUI()),
      //
      //         // Align(
      //         //   child: BeautyControllerWidget(_controller),
      //         //   alignment: Alignment.bottomCenter,
      //         // )
      //       ],
      //     );
      //   },
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

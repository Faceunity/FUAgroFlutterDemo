import 'package:faceunity_ui/Faceunity_ui.dart';
import 'package:flutter/material.dart';

import 'camera_widget.dart';

class FUPushWidget extends StatelessWidget {
  final String roomId;
  final String streamId;
  FUPushWidget(this.roomId, this.streamId);

  @override
  Widget build(BuildContext context) {
    final CameraWidgetController _controller =
        CameraWidgetController(this.roomId, this.streamId);

    return Scaffold(
      appBar: AppBar(
        title: Text("开始推流"),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _controller.updateSize(constraints.maxWidth, constraints.maxHeight);
          return Stack(
            children: [
              CameraWidget(_controller),
              SafeArea(child: FaceunityUI()),
            ],
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

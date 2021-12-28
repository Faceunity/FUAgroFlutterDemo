import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class FUPullInfo extends StatelessWidget {
  final String roomId;
  final String streamId;
  FUPullInfo(this.roomId, this.streamId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开始拉流"),
      ),
      body: FUPullInfoContent(this.roomId, this.streamId),
    );
  }
}

class FUPullInfoContent extends StatefulWidget {
  final String roomId;
  final String streamId;
  FUPullInfoContent(this.roomId, this.streamId);

  @override
  _FUPullInfoContentState createState() => _FUPullInfoContentState();
}

class _FUPullInfoContentState extends State<FUPullInfoContent> {
  int _previewViewID = -1;
  Widget _previewViewWidget;
  int appID = 1848335148;
  String appSign =
      "80d00dec39ce0b9ea120e376e2ae53403beff4be8aefe459f2e615363eccb0ac";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    createEngine();
    loginRoom();
    startPlayingStream(widget.streamId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stopPlayingStream();
    ZegoExpressEngine.destroyEngine();
    super.dispose();
  }

  // 1. 创建引擎
  void createEngine() {
    ZegoExpressEngine.createEngine(appID, appSign, true, ZegoScenario.General);
  }

  // 2. 登录房间
  void loginRoom() {
    // 创建用户对象
    ZegoUser user = ZegoUser.id("user2");
    // 开始登录房间
    ZegoExpressEngine.instance.loginRoom(widget.roomId, user);
  }

  // 3. 开始拉流
  void startPlayingStream(String streamId) {
    int width = window.physicalSize.width.toInt();
    int height =
        window.physicalSize.height.toInt() - window.padding.top.toInt();
    ZegoExpressEngine.instance
        .createTextureRenderer(width, height)
        .then((value) {
      _previewViewID = value;
      setState(() {
        _previewViewWidget = Texture(textureId: value);
        ZegoCanvas canvas = ZegoCanvas.view(value);
        ZegoExpressEngine.instance
            .startPlayingStream(widget.streamId, canvas: canvas);
      });
    });
  }

  // 4.停止拉流
  void stopPlayingStream() {
    ZegoExpressEngine.instance.stopPlayingStream(widget.streamId);
    ZegoExpressEngine.instance.destroyTextureRenderer(_previewViewID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(child: _previewViewWidget),
    );
  }
}

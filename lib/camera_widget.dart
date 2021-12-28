import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class CameraWidgetController {
  final String roomId;
  final String streamId;
  CameraWidgetController(this.roomId, this.streamId);

  bool isFrontCamera = true;

  bool _cameraEnable;

  double _width = 0;
  double _height = 0;

  void updateSize(double width, double height) {
    _width = width;
    _height = height;
    _updateTextureSize(width, height);
  }

  Future<void> useFrontCamera(bool use) async {
    _useFrontCameraCallBack?.call(use);
    isFrontCamera = use;
  }

  Future<void> enableCamera(bool enable) async {
    _enableCameraCallBack?.call(enable);
  }

  Future<void> startPublic() async {
    _startPublic?.call();
  }

  Future<void> stopPublic() async {
    _stopPublic?.call();
  }

  Future<void> Function(bool use) _useFrontCameraCallBack;
  Future<void> Function(bool enable) _enableCameraCallBack;

  Future<void> Function() _startPublic;

  Future<void> Function() _stopPublic;

  /// 渲染id
  int _textureId;

  /// 渲染view
  Widget _previewViewWidget = Container();

  /// 初始化后回调方法
  VoidCallback onAfterInit;

  /// 销毁
  void destroy() async {
    await ZegoExpressEngine.instance.stopPublishingStream();
    await ZegoExpressEngine.instance.stopPreview();
    await ZegoExpressEngine.instance.logoutRoom(this.roomId);
    await ZegoExpressEngine.instance.enableCamera(false);

    if (null != _textureId) {
      await ZegoExpressEngine.instance.destroyTextureRenderer(_textureId);
    }

    await ZegoExpressEngine.destroyEngine();
  }

  //更新textureSize
  void _updateTextureSize(double width, double height) {
    if (null != _textureId) {
      ZegoExpressEngine.instance
          .updateTextureRendererSize(_textureId, width.toInt(), height.toInt());
    }
  }

  void _init(
    VoidCallback createCallback,
  ) async {
    if (null != _textureId) {
      /// 已创建过
      return;
    }

    // 创建用户对象
    ZegoUser user = ZegoUser.id("user1");
    // 开始登陆房间
    ZegoExpressEngine.instance.loginRoom(this.roomId, user);

    // 开始推流
    ZegoExpressEngine.instance.startPublishingStream(this.streamId);

    // 启用本地预览
    ZegoExpressEngine.instance
        .createTextureRenderer(_width.toInt(), _height.toInt())
        .then((value) async {
      _textureId = value;
      _previewViewWidget = Texture(textureId: _textureId);
      ZegoCanvas previewCanvas = ZegoCanvas.view(_textureId);
      await ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);

      createCallback?.call();
      onAfterInit?.call();
    });
  }

  Future<void> _initZego() async {
    await ZegoExpressEngine.createEngine(
        1848335148,
        '80d00dec39ce0b9ea120e376e2ae53403beff4be8aefe459f2e615363eccb0ac',
        true,
        ZegoScenario.General);

    ///设置消除回音
    await ZegoExpressEngine.instance.enableAEC(true);

    ///设置降回音模式
    await ZegoExpressEngine.instance.setAECMode(ZegoAECMode.Soft);

    /// On/off automatic gain control 自动增益
    await ZegoExpressEngine.instance.enableAGC(true);

    /// 降噪
    await ZegoExpressEngine.instance.enableANS(true);

    await ZegoExpressEngine.instance.enableHardwareDecoder(false);
    await ZegoExpressEngine.instance.enableHardwareEncoder(false);
    await ZegoExpressEngine.instance
        .setVideoMirrorMode(ZegoVideoMirrorMode.OnlyPreviewMirror);
    await ZegoExpressEngine.instance.setVideoConfig(
        ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset720P));

    await ZegoExpressEngine.instance.enableHeadphoneMonitor(true);

    await ZegoExpressEngine.instance.enableCustomVideoCapture(true,
        config:
            ZegoCustomVideoCaptureConfig(ZegoVideoBufferType.SurfaceTexture));
  }

  Future<void> fuItemSetParam(String name, double param) async {
    await ZegoExpressEngine.fuItemSetParam(name, param);
  }
}

class CameraWidget extends StatefulWidget {
  final CameraWidgetController controller;
  final BorderRadiusGeometry borderRadius;
  final Widget frontToggle;

  /// 是否预览模式
  final bool isPreView;

  CameraWidget(this.controller,
      {this.borderRadius, this.frontToggle, this.isPreView = false});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<CameraWidget>
    with AutomaticKeepAliveClientMixin {
  Widget _previewViewWidget = Container();
  //前置摄像头
  bool _isFront = true;
  @override
  void initState() {
    super.initState();
    _previewViewWidget = widget.controller._previewViewWidget;
    _init();
  }

  void _init() async {
    await widget.controller._initZego();

    widget.controller._init(() {
      setState(() {
        _previewViewWidget = widget.controller._previewViewWidget;
      });

      _openCamera(true);
    });
  }

  Future<bool> _openCamera(bool enable) async {
    await ZegoExpressEngine.instance.enableCamera(true);

    return true;
  }

  Future<bool> _useFrontCamera(bool enable) async {
    await ZegoExpressEngine.instance.useFrontCamera(enable);

    return true;
  }

  void setCameraEnable(bool enable) {
    if (enable != widget.controller._cameraEnable) {
      setState(() {
        widget.controller._cameraEnable = enable;
      });
    }
  }

  @override
  void dispose() {
    _onDestroy();
    super.dispose();
  }

  Future<void> _onDestroy() async {
    widget.controller.destroy();
  }

  @override
  void didUpdateWidget(CameraWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _previewViewWidget,
        Align(
          alignment: Alignment(0.9, -1.0),
          child: GestureDetector(
              onTap: () {
                _isFront = !_isFront;
                _useFrontCamera(_isFront);
              },
              child: Image(
                image: AssetImage("assets/images/demo_switch-camera.png"),
              )),
        )
      ],
    );
  }

  bool get wantKeepAlive => true;
}

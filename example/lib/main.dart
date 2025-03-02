import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_rawdata/agora_rtc_rawdata.dart';
import 'package:agora_rtc_rawdata_example/config/agora.config.dart' as config;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:faceunity_ui_flutter/faceunity_ui_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RtcEngine engine;
  bool startPreview = false, isJoined = false;
  List<int> remoteUid = [];

  @override
  void initState() {
    super.initState();
    this._initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    this._deinitEngine();
  }

  _initEngine() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
        appId: config.appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting));

    engine.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      log('onJoinChannelSuccess connection: ${connection.toJson()} elapsed: $elapsed');
      setState(() {
        isJoined = true;
      });
    }, onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
      log('onUserJoined connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
      setState(() {
        remoteUid.add(rUid);
      });
    }, onUserOffline:
            (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
      log('onUserOffline connection: ${connection.toJson()} remoteUid: $rUid reason: $reason');
      setState(() {
        remoteUid.remove(rUid);
      });
    }));
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();
    //TODO 静音
    await engine.muteLocalAudioStream(true);
    await engine.muteAllRemoteAudioStreams(true);
    setState(() {
      startPreview = true;
    });

    await engine.joinChannel(
        token: config.token,
        channelId: config.channelId,
        uid: config.uid,
        options: ChannelMediaOptions(clientRoleType: ClientRoleType.clientRoleBroadcaster));
    await engine.setRecordingAudioFrameParameters(
        sampleRate: 48000,
        channel: 2,
        mode: RawAudioFrameOpModeType.rawAudioFrameOpModeReadOnly,
        samplesPerCall: 1024);
    var handle = await engine.getNativeHandle();
    await AgoraRtcRawdata.registerAudioFrameObserver(handle);
    await AgoraRtcRawdata.registerVideoFrameObserver(handle);
  }

  _deinitEngine() async {
    await AgoraRtcRawdata.unregisterAudioFrameObserver();
    await AgoraRtcRawdata.unregisterVideoFrameObserver();
    await engine.leaveChannel();
    await engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(
          children: [
            if (startPreview)
              AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: engine,
                  canvas: VideoCanvas(uid: 0),
                ),
              ),
            Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.of(remoteUid.map(
                    (e) => Container(
                      width: 120,
                      height: 120,
                      child: AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: engine,
                          canvas: VideoCanvas(uid: e),
                          connection: RtcConnection(
                            channelId: config.channelId,
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            ),
            //传camera 回调显示 UI，不传不显示
            // FaceunityUI(
            //   cameraCallback: () => engine.switchCamera(),
            // )
            FaceunityUI()
          ],
        ),
      ),
    );
  }
}

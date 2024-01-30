// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:faceunity_plugin/faceunity_plugin.dart';
import 'package:faceunity_ui_flutter/common/common_switch.dart';
import 'package:faceunity_ui_flutter/common/segment_bar.dart';
import 'package:faceunity_ui_flutter/modules/body/body_view.dart';
import 'package:faceunity_ui_flutter/modules/filter/filter_view.dart';
import 'package:faceunity_ui_flutter/modules/makeup/makeup_view.dart';
import 'package:faceunity_ui_flutter/modules/shape/shape_view.dart';
import 'package:faceunity_ui_flutter/modules/skin/skin_view.dart';
import 'package:faceunity_ui_flutter/modules/sticker/sticker_view.dart';
import 'package:faceunity_ui_flutter/util/faceunity_defines.dart';
import 'package:flutter/material.dart';

class FaceunityUI extends StatelessWidget {
  const FaceunityUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FaceunityWidget();
  }
}

class FaceunityWidget extends StatefulWidget {
  const FaceunityWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FaceunityWidgetState();
  }

}

class FaceunityWidgetState extends State<FaceunityWidget> {
  // 当前选中的功能栏索引
  int selectedIndex = -1;

  @override
  void initState() {
    FaceunityPlugin.setupRenderKit();
    super.initState();
  }

  @override
  void dispose() {
    FaceunityPlugin.destoryRenderKit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // 美肤
        Positioned(
          left: 0,
          right: 0,
          bottom: 54,
          child: AnimatedContainer(
            height: selectedIndex == ModuleType.skin.number ? 148 : 0,
            duration: const Duration(milliseconds: 100),
            child: const SkinView(),
          )
        ),

        // 美型
        Positioned(
          left: 0,
          right: 0,
          bottom: 54,
          child: AnimatedContainer(
            height: selectedIndex == ModuleType.shape.number ? 148 : 0,
            duration: const Duration(milliseconds: 100),
            child: const ShapeView(),
          )
        ),

        // 滤镜
        Positioned(
          left: 0,
          right: 0,
          bottom: 54,
          child: AnimatedContainer(
            height: selectedIndex == ModuleType.filter.number ? 148 : 0,
            duration: const Duration(milliseconds: 100),
            child: const FilterView(),
          )
        ),
        
        // 贴纸
        Positioned(
          left: 0,
          right: 0,
          bottom: 54,
          child: AnimatedContainer(
            height: selectedIndex == ModuleType.sticker.number ? 118 : 0,
            duration: const Duration(milliseconds: 100),
            child: const StickerView(),
          )
        ),

        // 美妆
        Positioned(
          left: 0,
          right: 0,
          bottom: 54,
          child: AnimatedContainer(
            height: selectedIndex == ModuleType.makeup.number ? 148 : 0,
            duration: const Duration(milliseconds: 100),
            child: const MakeupView(),
          )
        ),

        // 美体
        Positioned(
          left: 0,
          right: 0,
          bottom: 54,
          child: AnimatedContainer(
            height: selectedIndex == ModuleType.body.number ? 148 : 0,
            duration: const Duration(milliseconds: 100),
            child: const BodyView(),
          )
        ),

        // 底部功能栏
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 54,
          child: Container(
            color: const Color.fromARGB(255, 5, 15, 20),
            child: SegmentBar(
              onChange: (index) {
                setState(() {
                  selectedIndex = index;

                  switch (ModuleType.values[index]) {
                    case ModuleType.skin:
                    case ModuleType.shape:
                    case ModuleType.filter:{
                      FaceunityPlugin.checkIsBeautyLoaded();
                      FaceunityPlugin.setMaximumFacesNumber(4);
                    }
                      break;
                    case ModuleType.body:{
                      FaceunityPlugin.checkIsBodyLoaded();
                      FaceunityPlugin.setMaximumFacesNumber(1);
                    }
                      break;
                    case ModuleType.sticker:
                      FaceunityPlugin.setMaximumFacesNumber(4);
                      break;
                    case ModuleType.makeup:
                      FaceunityPlugin.setMaximumFacesNumber(4);
                      break;
                    default:
                  }
                });
              }, 
              items: const ["美肤", "美型", "滤镜", "贴纸", "美妆", "美体"]
            ),
          )
        ),

        // 效果开关
        Positioned(
          left: 0,
          bottom: selectedIndex == ModuleType.sticker.number ? 172 : 202,
          child: Visibility(
            visible: selectedIndex >= 0,
            child: CommonSwitch(
              onChanged: (value) {
                value ? FaceunityPlugin.turnOnEffects() : FaceunityPlugin.turnOffEffects();
              },
            ) 
          )
        )
      ],
    );
    
  }
}
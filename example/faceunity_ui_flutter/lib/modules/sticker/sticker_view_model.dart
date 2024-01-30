import 'dart:convert';

import 'package:faceunity_plugin/sticker_plugin.dart';
import 'package:faceunity_ui_flutter/modules/sticker/sticker_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StickerViewModel extends ChangeNotifier {

  StickerViewModel() : super() {
    getStickers();
  }

  late List<StickerModel> stickers = [];
  
  // 当前选中贴纸索引
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    if (index < 0 || index >= stickers.length) {
      return;
    }
    selectedIndex = index;
    if (index == 0) {
      StickerPlugin.removeSticker();
    } else {
      StickerPlugin.selectSticker(stickers[index].bundleName);
    }
  }
  
  void getStickers() async {
    String jsonString = await rootBundle.loadString(CommonUtil.bundleFileNamed("sticker/stickers.json"));
    final jsonData = json.decode(jsonString);
    List<StickerModel> stickerModels = [];
    for (Map<String, dynamic> item in jsonData) {
      StickerModel sticker = StickerModel.fromJson(item);
      stickerModels.add(sticker);
    }
    stickers = stickerModels;
    notifyListeners();
  }
}
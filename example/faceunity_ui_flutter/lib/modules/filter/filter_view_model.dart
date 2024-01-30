import 'dart:convert';

import 'package:faceunity_plugin/filter_plugin.dart';
import 'package:faceunity_ui_flutter/modules/filter/filter_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterViewModel extends ChangeNotifier {

  FilterViewModel() : super() {
    getFilters();
  }

  late List<FilterModel> filters = [];

  // 选中滤镜索引
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    if (index < 0 || index >= filters.length) {
      return;
    }
    selectedIndex = index;
    FilterPlugin.selectFilter(filters[index].filterKey);
    setFilterLevel(filters[index].filterLevel);
  }

  void setFilterLevel(double level) {
    if (selectedIndex < 0 || selectedIndex >= filters.length) {
      return;
    }
    level = level < 0 ? 0 : (level > 1 ? 1 : level);
    filters[selectedIndex].filterLevel = level;
    FilterPlugin.setFilterLevel(level);
  }

  void getFilters() async {
    String jsonString = await rootBundle.loadString(CommonUtil.bundleFileNamed("filter/beauty_filter.json"));
    final jsonData = json.decode(jsonString);
    List<FilterModel> filterModels = [];
    for (Map<String, dynamic> item in jsonData) {
      FilterModel filter = FilterModel.fromJson(item);
      filterModels.add(filter);
    }
    filters = filterModels;
    setSelectedIndex(1);
    notifyListeners();
  }
}
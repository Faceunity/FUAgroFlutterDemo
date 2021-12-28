import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:faceunity_ui/Tools/ViewModelManager.dart';

class CompareBtn extends StatefulWidget {
  CompareBtn(this.manager);
  final ViewModelManager manager;

  @override
  _CompareBtnState createState() => _CompareBtnState();
}

class _CompareBtnState extends State<CompareBtn> {
  late bool _isOn;
  @override
  void initState() {
    super.initState();
    _isOn = widget.manager.curViewModel.dataModel.isOn;
  }

  @override
  Widget build(BuildContext context) {
    ViewModelManager manager = widget.manager;
    _isOn = manager.curViewModel.dataModel.isOn;
    Widget child = Platform.isIOS == true
        ? CupertinoSwitch(
            value: _isOn,
            onChanged: (value) {
              //native 设置是否渲染原图
              setState(() {
                _isOn = value;
              });
              manager.switchIsOn(value);
            })
        : Switch(
            value: _isOn,
            inactiveTrackColor: Colors.transparent,
            onChanged: (value) {
              //native 设置是否渲染原图
              setState(() {
                _isOn = value;
              });
              manager.switchIsOn(value);
            });
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
        child: Align(alignment: Alignment.topLeft, child: child));
  }
}

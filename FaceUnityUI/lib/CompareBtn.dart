import 'dart:io';

import 'package:faceunity_ui/Tools/ViewModelManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompareBtn extends StatefulWidget {
  final bool isOn;
  CompareBtn(this.isOn);
  @override
  _CompareBtnState createState() => _CompareBtnState();
}

class _CompareBtnState extends State<CompareBtn> {
  late bool _isOn;
  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModelManager>(builder: (context, manager, child) {
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
    });
  }
}

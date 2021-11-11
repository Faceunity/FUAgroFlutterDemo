import 'dart:io';
import 'package:faceunity_ui/Tools/DialogManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetDialog extends StatefulWidget {
  final Function? comfirmCallback;
  final Function? cancelCallback;
  ResetDialog(this.comfirmCallback, this.cancelCallback);
  _ResetDialogState createState() => _ResetDialogState();
}

class _ResetDialogState extends State<ResetDialog> {
  bool _isShow = false;
  //内部控制是否显示
  void isShow(bool show) {
    setState(() {
      _isShow = show;
    });
  }

  // void
  @override
  Widget build(BuildContext context) {
    return Consumer<DialogManager>(builder: (context, manager, child) {
      _isShow = manager.isShowDialog;
      return Visibility(
          visible: _isShow,
          child: Platform.isIOS == true
              ? CupertinoAlertDialog(
                  content: new SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          "是否将所有参数恢复到默认值",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text("取消"),
                      onPressed: () {
                        if (widget.cancelCallback != null) {
                          widget.cancelCallback!();
                          isShow(false);
                        }
                      },
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    CupertinoDialogAction(
                      child: Text("确定"),
                      onPressed: () {
                        if (widget.comfirmCallback != null) {
                          widget.comfirmCallback!();
                          isShow(false);
                        }
                      },
                      textStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              : AlertDialog(
                  content: new SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("是否将所有参数恢复到默认值"),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("确定"),
                      onPressed: () {
                        if (widget.comfirmCallback != null) {
                          widget.comfirmCallback!();
                          isShow(false);
                        }
                      },
                    ),
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        if (widget.cancelCallback != null) {
                          widget.cancelCallback!();
                          isShow(false);
                        }
                      },
                    )
                  ],
                ));
    });
  }
}

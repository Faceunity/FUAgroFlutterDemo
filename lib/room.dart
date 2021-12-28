import 'package:fluttedemo/pull.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'push.dart';

class FURoomInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FUBodyInfo();
  }
}


class FUBodyInfo extends StatefulWidget {

  @override
  _FUBodyInfoState createState() => _FUBodyInfoState();
}

class _FUBodyInfoState extends State<FUBodyInfo> {

  String roomId = "";
  String streamId = "";
  final FocusNode _roomFocusNode = FocusNode();
  final FocusNode _streamFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "roomId",
                hintText: "请输入一个房间号",
                border: InputBorder.none,
                filled: true,
              ),
              keyboardType: TextInputType.phone,
              focusNode: _roomFocusNode,
              onChanged: (value){
                print(value);
                roomId = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "streamId",
                hintText: "请输入一个流Id",
                border: InputBorder.none,
                filled: true,
              ),
              keyboardType: TextInputType.phone,
              focusNode: _streamFocusNode,
              onChanged: (value){
                print(value);
                streamId = value;
              },
            ),
          ),
          ElevatedButton(
            child: Text("开始推流"), 
            onPressed: (){
              _roomFocusNode.unfocus();
              _streamFocusNode.unfocus();
              if(roomId.length > 0 && streamId.length > 0){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context){
                      print("roomId = $roomId, streamId = $streamId");
                      return FUPushWidget(roomId, streamId);
                    })
                );
              }else{
                showDialog(
                  context: context,
                  builder: (ctx){
                    return AlertDialog(
                      title: Text("提示信息"),
                      content: Text("请先输入roomId和streamId"),
                    );
                  }
                );
              }
            },
          ),
          ElevatedButton(
            child: Text("开始拉流"),
            onPressed: (){
              _roomFocusNode.unfocus();
              _streamFocusNode.unfocus();

              if(roomId.length > 0 && streamId.length > 0){
                Navigator.of(context).push(MaterialPageRoute(builder: (navCtx){
                  return FUPullInfo(roomId, streamId);
                }));
              }else{
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text("提示信息"),
                        content: Text("请先输入roomId和streamId"),
                      );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

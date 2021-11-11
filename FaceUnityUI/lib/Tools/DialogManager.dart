import 'package:flutter/cupertino.dart';

//独立控制diglog刷新
class DialogManager with ChangeNotifier {
  //是否是默认值状态
  late bool _isShowDialog = false;

  set isShowDialog(bool isShow) {
    _isShowDialog = isShow;
    notifyListeners();
  }

  bool get isShowDialog => _isShowDialog;
}

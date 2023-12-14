import 'package:flutter/cupertino.dart';

class Settings with ChangeNotifier {
  bool _isShowingSums = false;

  bool get isShowingSums => _isShowingSums;

  void showSums(bool value) {
    _isShowingSums = value;
    notifyListeners();
  }
}

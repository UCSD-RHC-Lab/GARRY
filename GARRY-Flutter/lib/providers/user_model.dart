///
/// User provider. Part of the effort to refactor from global data to use the
/// provider pattern to store global app data. Includes participant ID and their
/// name.
///
import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  int _pid = 0;
  String _name = "";

  get pid => _pid;
  get name => _name;

  void setPid(int pid) {
    _pid = pid;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}
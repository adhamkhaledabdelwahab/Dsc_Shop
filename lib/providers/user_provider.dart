import 'package:dsc_shop/models/UserModel.dart';
import 'package:dsc_shop/services/database_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? user;

  UserProvider(String userId, [UserModel? userModel]) {
    if (userModel != null) {
      user = userModel;
      notifyListeners();
    } else {
      updateUser(userId);
    }
  }

  void updateUser(String userId) {
    DatabaseServices().getUser(userId).then((value) {
      user = value;
      notifyListeners();
    });
  }
}

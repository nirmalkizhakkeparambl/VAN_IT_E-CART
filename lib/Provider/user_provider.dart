import 'package:flutter/material.dart';
import 'package:ntfp_cart/Models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '1',
    name: 'NIRMAL',
    email: 'nks@gmail.com',
    password: 'Pass@123',
    address: 'wayanad',
    type: 'user',
    token: '1234567890',
    cart: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}

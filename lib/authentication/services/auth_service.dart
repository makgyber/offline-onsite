import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline/authentication/models/local/user.dart';
import 'package:offline/authentication/models/rest/api_user.dart';
import 'package:offline/authentication/services/api_service.dart';
import 'package:offline/db/database.dart';


class AuthService extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> _init() async {
    final db = await $FloorOfflineDatabase
        .databaseBuilder('tbs_offline.db')
        .build();
    final users = await db.userDao.findAllUsers();
    _isLoggedIn = users.isNotEmpty;
    notifyListeners();
  }

  Future<bool> logIn(String email, String password) async {
    final db = await $FloorOfflineDatabase
        .databaseBuilder('tbs_offline.db')
        .build();

    String? token = await apiService.getToken(email, password);

    if (token == null) {
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }

    ApiUser? user  = await apiService.getUser(token);
    if (user == null) {
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }

    await db.userDao.insertUser(User(id: user.id, name: user.name, email: user.email, token: token));

    db.close();
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    final db = await $FloorOfflineDatabase
        .databaseBuilder('tbs_offline.db')
        .build();

    var users = await db.userDao.findAllUsers();
    for(final user in users) {
      debugPrint(user.toString());
      await db.userDao.deleteUser(user);
    }

    db.close();
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline/authentication/models/local/user.dart';
import 'package:offline/authentication/models/rest/api_user.dart';
import 'package:offline/authentication/services/api_service.dart';
import 'package:offline/config/constants.dart';
import 'package:offline/db/database.dart';
import 'package:offline/db/database_helper.dart';


class AuthService extends ChangeNotifier {
  final ApiService apiService = ApiService();

  AuthService() {
    _init();
    notifyListeners();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<User> getAuthenticatedUser() async {
    final db = DatabaseHelper.instance.database;
    final users = await db.userDao.findAllUsers();
    debugPrint(users.first.token.toString());
    _isLoggedIn = (users.first.token.isNotEmpty);
    notifyListeners();
    return users.first;
  }

  Future<void> _init() async {
    User user = await getAuthenticatedUser();
    _isLoggedIn = (user.token.isNotEmpty);

  }

  Future<bool> logIn(String email, String password) async {
    final db = DatabaseHelper.instance.database;

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

    var userId = await db.userDao.insertUser(User(id: user.id, name: user.name, email: user.email, token: token));


    _isLoggedIn = userId > 0;

    notifyListeners();
    return _isLoggedIn;
  }

  Future<void> logOut() async {
    debugPrint('logging out');
    final db = DatabaseHelper.instance.database;

    var users = await db.userDao.findAllUsers();
    for(final user in users) {
      debugPrint(user.toString());
      await db.userDao.deleteUser(user);
    }

    _isLoggedIn = false;
    notifyListeners();
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authUserProvider = Provider<Future<User>>((ref) => ref.watch(authServiceProvider).getAuthenticatedUser());

/// An inherited notifier to host [UserAuth] for the subtree.
class UserAuthScope extends InheritedNotifier<AuthService> {
  /// Creates a [UserAuthScope].
  const UserAuthScope({
    required AuthService super.notifier,
    required super.child,
    super.key,
  });

  /// Gets the [UserAuth] above the context.
  static AuthService of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<UserAuthScope>()!
      .notifier!;
}
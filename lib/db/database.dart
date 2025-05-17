import 'dart:async';
import 'package:floor/floor.dart';
import 'package:offline/authentication/models/local/user.dart';
import 'package:offline/authentication/models/local/user_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'converters.dart';

part 'database.g.dart';

@Database(version: 1, entities: [User])
@TypeConverters([DateTimeConverter])
abstract class OfflineDatabase extends FloorDatabase {
  UserDao get userDao;
}
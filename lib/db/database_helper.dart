import 'package:floor/floor.dart';
import 'package:offline/config/constants.dart';
import 'database.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  late final OfflineDatabase database;

  Future<void> initializeDatabase() async {
    database = await $FloorOfflineDatabase.databaseBuilder(Constants.databaseName).build();
  }
}
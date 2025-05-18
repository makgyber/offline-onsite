import 'dart:async';
import 'package:floor/floor.dart';
import 'package:offline/authentication/models/local/user.dart';
import 'package:offline/authentication/models/local/user_dao.dart';
import 'package:offline/job_orders/models/local/arrival_dao.dart';
import 'package:offline/job_orders/models/local/job_order_dao.dart';
import 'package:offline/job_orders/models/rest/arrival.dart';
import 'package:offline/job_orders/models/rest/job_order.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'converters.dart';

part 'database.g.dart';

@Database(version: 1, entities: [User, JobOrder, Arrival])
@TypeConverters([DateTimeConverter])
abstract class OfflineDatabase extends FloorDatabase {
  UserDao get userDao;
  ArrivalDao get arrivalDao;
  JobOrderDao get jobOrderDao;
}
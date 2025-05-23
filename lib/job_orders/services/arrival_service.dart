import 'dart:isolate';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline/db/database_helper.dart';
import 'package:offline/job_orders/models/rest/arrival.dart';



final arrivalsProvider = FutureProvider.autoDispose
  .family<List<Arrival>, int>((ref, arguments) async {
  final db = DatabaseHelper.instance.database;
  var arrivals = db.arrivalDao.findAllArrivalsByJobOrderId(arguments);
  return arrivals;
});


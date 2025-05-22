import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:offline/config/constants.dart';
import 'dart:convert';
import 'package:offline/db/database.dart';
import 'package:offline/db/database_helper.dart';
import 'package:offline/job_orders/models/rest/arrival.dart';
import 'package:offline/job_orders/models/rest/job_order.dart';

class JobOrderApi {

  Stream<List<JobOrder>> getJobOrdersAsStream(String visitDate) async* {
    final db = DatabaseHelper.instance.database;

    final List<JobOrder>? jobOrders = await db.jobOrderDao.findAllJobOrdersByTargetDate('$visitDate%');

    debugPrint('trying local');
    // Returns the database result if it exists
    if (jobOrders != null && jobOrders.length > 0) {
      debugPrint('from local');
      debugPrint(jobOrders.length.toString());
      yield jobOrders;
    }

    debugPrint('exiting local');
    // Fetch the job orders from the API
    try {
      debugPrint('trying from remote');
      final jobOrders = await fetchJobOrders(db, visitDate);

      if (jobOrders != null) {
        debugPrint('from remote');
        debugPrint(jobOrders.length.toString());
        yield jobOrders;
      }

    } catch (e) {
      // Handle the error
    }

  }


  Future<List<JobOrder>?> fetchJobOrders(OfflineDatabase db, String visitDate) async {
    String url = Constants.jobOrderUrl;
    String token = await db.userDao.findAllUsers().then((_user)=>_user.first.token);
    url = '$url?visit_date=$visitDate';
    final Response response = await get(Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token"
        }
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 400) {
        final result = jsonDecode(response.body);
        List<JobOrder> jos = [];
        for(final jo in result) {
          final tmp = JobOrder.fromJson(jo);
          var jobId = await db.jobOrderDao.insertJobOrder(tmp);
          for (final arrival in jo['arrivals']) {
            var tArr = Arrival.fromJson(arrival);
            var aid = await db.arrivalDao.insertArrival(tArr);
          }
          jos.add(tmp);
        }
        return jos;
      }
    }catch(e) {
      debugPrint("Error");
      return null;
    }
    return null;
  }

  Future<JobOrder?> fetchJobOrderById(int id) async {
    final db = DatabaseHelper.instance.database;
    final jo = await db.jobOrderDao.findJobOrderById(id);
    return jo;
  }

}

final jobOrderApiProvider = Provider<JobOrderApi>((ref) => JobOrderApi());

final allJobOrdersProvider = StreamProvider.autoDispose.family<List<JobOrder>?, String>((ref, arguments) {
  final joProvider = ref.watch(jobOrderApiProvider);
  return joProvider.getJobOrdersAsStream(arguments);
});





final jobOrderDetailProvider = FutureProvider.autoDispose
    .family<JobOrder?, int>((ref, arguments) async {
  final joProvider = ref.watch(jobOrderApiProvider);
  var jo = await joProvider.fetchJobOrderById(arguments);
  return jo;
});


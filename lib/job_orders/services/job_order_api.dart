import 'package:floor/floor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:offline/config/constants.dart';
import 'dart:convert';
import 'package:offline/db/database.dart';
import 'package:offline/job_orders/models/rest/arrival.dart';
import 'package:offline/job_orders/models/rest/job_order.dart';

class JobOrderApi {

  Stream<List<JobOrder>> getJobOrdersAsStream(String visitDate) async* {
    final db = await $FloorOfflineDatabase
        .databaseBuilder(Constants.databaseName)
        .build();

    final List<JobOrder>? jobOrders = await db.jobOrderDao.findAllJobOrdersByTargetDate(visitDate);

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
    print(url);
    try {
      if (response.statusCode == 200 || response.statusCode == 400) {

        final result = jsonDecode(response.body);

        print(result);
        List<JobOrder> jos = [];
        for(final jo in result) {
          final tmp = JobOrder.fromJson(jo);
          print(tmp.toString());
          db.jobOrderDao.insertJobOrder(tmp);
          for (final arrival in jo['arrivals']) {
            debugPrint(arrival.toString());
            var tArr = Arrival.fromJson(arrival);
            var aid = db.arrivalDao.insertArrival(tArr);
            debugPrint(aid.toString());
          }
          jos.add(tmp);
        }

        return jos;
      }
    }catch(e) {
      debugPrint("Error");
      print(e.toString());
      return null;
    }
    return null;
  }


  Future<JobOrder?> fetchJobOrderById(int id) async {
    final db = await $FloorOfflineDatabase
        .databaseBuilder(Constants.databaseName)
        .build();

    final jo = await db.jobOrderDao.findJobOrderById(id);
    debugPrint("trying out the ");
    debugPrint(jo!.clientName);
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


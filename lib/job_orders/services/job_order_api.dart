import 'package:floor/floor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:offline/db/database.dart';
import 'package:offline/job_orders/models/rest/arrival.dart';
import 'package:offline/job_orders/models/rest/job_order.dart';

class JobOrderApi {


  Stream<List<JobOrder>> getJobOrdersAsStream() async* {
    final db = await $FloorOfflineDatabase
        .databaseBuilder('tbs_offline.db')
        .build();

    final List<JobOrder>? jobOrders = await db.jobOrderDao.findAllJobOrders();

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
      final jobOrders = await fetchJobOrders(db);

      if (jobOrders != null) {
        debugPrint('from remote');
        debugPrint(jobOrders.length.toString());
        yield jobOrders;
      }

    } catch (e) {
      // Handle the error
    }

  }


  Future<List<JobOrder>?> fetchJobOrders(OfflineDatabase db) async {
    String url = "https://topbestsystems.com/api/user-schedule";
    String token = await db.userDao.findAllUsers().then((_user)=>_user.first.token);

    final Response response = await get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token"
    }
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 400) {

        final result = jsonDecode(response.body);

        List<JobOrder> jos = [];
        for(final jo in result) {
          final tmp = JobOrder.fromJson(jo);
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
      return null;
    }
    return null;
  }


  Future<JobOrder?> fetchJobOrderById(int id) async {
    final db = await $FloorOfflineDatabase
        .databaseBuilder('tbs_offline.db')
        .build();

    final jo = await db.jobOrderDao.findJobOrderById(id);
    debugPrint("trying out the ");
    debugPrint(jo!.clientName);
    return jo;
  }

}

final jobOrderApiProvider = Provider<JobOrderApi>((ref) => JobOrderApi());

final allJobOrdersProvider = StreamProvider<List<JobOrder>?>((ref) {
  final joProvider = ref.read(jobOrderApiProvider);
  return joProvider.getJobOrdersAsStream();
});

final jobOrderDetailProvider = FutureProvider.autoDispose
// We use the ".family" modifier.
// The "String" generic type corresponds to the argument type.
// Our provider now receives an extra argument on top of "ref": the activity type.
    .family<JobOrder?, int>((ref, arguments) async {
  final joProvider = ref.watch(jobOrderApiProvider);
  var jo = await joProvider.fetchJobOrderById(arguments);
  return jo;
});


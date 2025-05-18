import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:offline/job_orders/services/job_order_api.dart';

class JobOrderDetailsScreen extends ConsumerStatefulWidget {
  String? id;
  JobOrderDetailsScreen({super.key, this.id});

  @override
  ConsumerState<JobOrderDetailsScreen> createState() => _JobOrderDetailsScreenState();
}

class _JobOrderDetailsScreenState extends ConsumerState<JobOrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {

    final jobOrder = ref.watch(jobOrderDetailProvider(int.parse(widget.id!)));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.backspace),
                onPressed: () { GoRouter.of(context).pop(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text("Detail page"),
          elevation: 2,
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          actions: <Widget>[
            // IconButton(icon: Icon(Icons.date_range_outlined),
            //     onPressed: _selectDate),
            // IconButton(icon: Icon(Icons.exit_to_app),
            //     onPressed: () {
            //       // UserAuthScope.of(context)
            //       //     .signOut();
            //     })
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child:
            jobOrder.when(
                data: (data) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data!.clientName),
                                  Text(data.shortAddress??""),
                                  Text(data.code),
                                  Text(data.jobOrderType),
                                  Text(data.status),
                                  Text(data.summary),
                                  Text(data.targetDate.toIso8601String()),
                                ],
                            );
                },
                loading: ()=> const CircularProgressIndicator(),
                error: (e, trace) {
                  return Text(e.toString());
                }
            )
        )
      ),
    );
  }
}



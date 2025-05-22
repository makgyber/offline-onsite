import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:offline/job_orders/services/arrival_service.dart';
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
    final arrivals = ref.watch(arrivalsProvider(int.parse(widget.id!)));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.backspace),
                onPressed: () { context.pop(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text("Detail page"),
          elevation: 2,
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          actions: <Widget>[
          ],
        ),
        body: Wrap(
              children: [
                jobOrder.when(
                    data: (data) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data!.clientName),
                              Text(data.shortAddress??""),
                              Text(data.site??""),
                              Text(data.code),
                              Text(data.jobOrderType),
                              Text(data.status),
                              Text(data.summary),
                              Text(data.targetDate),
                            ],
                        );
                    },
                    loading: ()=> const CircularProgressIndicator(),
                    error: (e, trace) {
                      return Text(e.toString());
                    }
                ),
                arrivals.when(
                  data: (arrData) {
                    return Table(
                      border: TableBorder.all(color: Colors.white30),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent
                                ),
                                  children: [
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Arrival"),
                                      )),
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Departure"),
                                        )
                                    ),
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Remarks"),
                                        )),
                                  ]
                              ),
                            ...List.generate(
                                arrData.length,
                                (index)=> TableRow(
                                    children: [
                                      TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(arrData[index].arrival!),
                                          )),
                                      TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(arrData[index].departure??"-"),
                                          )
                                      ),
                                      TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(arrData[index].remarks??"-"),
                                          )),
                                    ]
                                )
                            )

                          ]
                      );
                   }
                  ,
                  error: (e, trace) => Text(e.toString()),
                  loading: () => const CircularProgressIndicator()
                )
              ],
        )
      )
    );
  }
}






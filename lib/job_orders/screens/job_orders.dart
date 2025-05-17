import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobOrdersScreen extends ConsumerStatefulWidget {
  const JobOrdersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<JobOrdersScreen> createState() => _JobOrdersScreenState();
}

class _JobOrdersScreenState extends ConsumerState<JobOrdersScreen> {
  DateTime? visitDate = DateTime.now();

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now()
    );

    setState(() {
      visitDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final jobOrders = ref.watch(allJobOrdersProvider);
    // List<JobOrder> jos = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(visitDate != null
            ? 'Job orders from ${visitDate!.year}/${visitDate!.month}/${visitDate!.day}'
            : 'Job orders today',),
        elevation: 2,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.date_range_outlined),
              onPressed: _selectDate),
          IconButton(icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // UserAuthScope.of(context)
                //     .signOut();
              })
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(),
          //
          // jobOrders.when(
          //     data: (data) {
          //       return RefreshIndicator(
          //           child: ListView.builder(
          //               itemCount: data!.length,
          //               itemBuilder: (context, index) {
          //                 return Container(
          //                   padding: const EdgeInsets.all(10),
          //                   decoration: BoxDecoration(
          //                     color: Colors.green.shade50,
          //                     border: Border.all(color: Colors.green.shade700),
          //                     borderRadius: BorderRadius.circular(5),
          //                   ),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       // Text(data[index].client!.name.toString()),
          //                       // Text(data[index].address!.street.toString()),
          //                       Text(data[index].code),
          //                       Text(data[index].status),
          //                       // Text(data[index].job_order_type),
          //                     ],
          //                   ),
          //                 );
          //               }
          //           ),
          //           onRefresh: () async {
          //             ref.refresh(allJobOrdersProvider);
          //           }
          //       );
          //     },
          //     loading: ()=> const CircularProgressIndicator(),
          //     error: (e, trace) {
          //       return Text(e.toString());
          //     }
          //
          // )

      ),

    );
  }
}



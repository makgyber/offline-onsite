import 'package:floor/floor.dart';
import 'package:offline/job_orders/models/rest/job_order.dart';

@dao
abstract class JobOrderDao {
  @Query('SELECT * FROM job_orders WHERE id = :id')
  Future<JobOrder?> findJobOrderById(int id);

  @Query('SELECT * FROM job_orders')
  Future<List<JobOrder>> findAllJobOrders();

  @Query('SELECT * FROM job_orders')
  Stream<List<JobOrder>> findAllJobOrdersAsStream();

  @Query('SELECT DISTINCT COUNT(message) FROM job_orders')
  Stream<int?> findUniqueMessagesCountAsStream();

  @Query('SELECT * FROM job_orders WHERE status = :status')
  Stream<List<JobOrder>> findAllJobOrdersByStatusAsStream(String status);

  @Query('UPDATE OR ABORT job_orders SET type = :type WHERE id = :id')
  Future<int?> updateTypeById(String type, int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertJobOrder(JobOrder jobOrder);

  @insert
  Future<void> insertJobOrders(List<JobOrder> jobOrders);

  @update
  Future<void> updateJobOrder(JobOrder jobOrder);

  @update
  Future<void> updateJobOrders(List<JobOrder> jobOrder);

  @delete
  Future<void> deleteJobOrder(JobOrder jobOrder);

  @delete
  Future<void> deleteJobOrders(List<JobOrder> jobOrder);
}
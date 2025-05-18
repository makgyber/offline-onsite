import 'package:floor/floor.dart';
import 'package:offline/job_orders/models/rest/arrival.dart';

@dao
abstract class ArrivalDao {
  @Query('SELECT * FROM arrivals WHERE id = :id')
  Future<Arrival?> findArrivalById(int id);

  @Query('SELECT * FROM arrivals')
  Future<List<Arrival>> findAllArrivals();

  @Query('SELECT * FROM arrivals')
  Stream<List<Arrival>> findAllArrivalsAsStream();

  @Query('SELECT DISTINCT COUNT(message) FROM arrivals')
  Stream<int?> findUniqueMessagesCountAsStream();

  @Query('SELECT * FROM arrivals WHERE status = :status')
  Stream<List<Arrival>> findAllArrivalsByStatusAsStream(String status);

  @Query('SELECT * FROM arrivals WHERE jobOrderId = :jobOrderId')
  Stream<List<Arrival>> findAllArrivalsByJobOrderId(String jobOrderId);

  @Query('UPDATE OR ABORT arrivals SET type = :type WHERE id = :id')
  Future<int?> updateTypeById(String type, int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertArrival(Arrival arrival);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertArrivals(List<Arrival> arrival);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateArrival(Arrival arrival);

  @update
  Future<void> updateArrivals(List<Arrival> arrival);

  @delete
  Future<void> deleteArrival(Arrival arrival);

  @delete
  Future<void> deleteArrivals(List<Arrival> arrival);
}
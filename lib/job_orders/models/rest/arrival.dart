import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'job_order.dart';

part 'arrival.g.dart';

@JsonSerializable()
@Entity(tableName: 'arrivals', foreignKeys: [
  ForeignKey(
    childColumns: ['jobOrderId'],
    parentColumns: ['id'],
    entity: JobOrder,
  )
],)
class Arrival {
  @PrimaryKey()
  int? localId;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "job_order_id")
  int? jobOrderId;
  String? arrival;
  String? departure;
  String? remarks;
  @JsonKey(name: "user_id")
  int? userId;
  @JsonKey(name: "created_at")
  DateTime createdAt = DateTime.now();
  @JsonKey(name: "updated_at")
  DateTime updatedAt = DateTime.now();

  Arrival(
    this.localId,
    this.id,
    this.jobOrderId,
    this.arrival,
    this.departure,
    this.remarks,
    this.userId,
    this.createdAt,
    this.updatedAt,
  );

  factory Arrival.fromJson(Map<String, dynamic> json)=>_$ArrivalFromJson(json);
  Map<String, dynamic> toJson() => _$ArrivalToJson(this);
}
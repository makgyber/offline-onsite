import 'package:json_annotation/json_annotation.dart';

part 'api_user.g.dart';

@JsonSerializable()
class ApiUser {
  final int id;
  final String name;
  final String email;

  ApiUser({required this.id, required this.name, required this.email});

  factory ApiUser.fromJson(Map<String, dynamic> json) => _$ApiUserFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUserToJson(this);

}
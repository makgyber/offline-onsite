import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey()
  final int id;
  final String name;
  final String email;
  final String token;

  User({required this.id, required this.name, required this.email,  required this.token});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toInt(),
      name: map['name'].toString(),
      email: map['email'].toString(),
      token: map['token'].toString()
    );
  }

  String toString() {
    return "User{$id, $name, $email, $token}";
  }
}



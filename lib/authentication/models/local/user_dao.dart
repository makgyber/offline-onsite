import 'package:floor/floor.dart';
import 'package:offline/authentication/models/local/user.dart';

@dao
abstract class UserDao {

  @Query('SELECT * FROM users')
  Future<List<User>> findAllUsers();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertUser(User user);

  @delete
  Future<void> deleteUser(User user);

}
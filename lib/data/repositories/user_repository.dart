import 'package:hive/hive.dart';
import '../models/user.dart';

class UserRepository {
  final Box<User> _userBox = Hive.box<User>('users');

  Future<void> addUser(User user) async {
    await _userBox.put(user.id, user);
  }

  User? getCurrentUser() {
    return _userBox.getAt(0);
  }

  Future<void> updateUser(User user) async {
    await _userBox.put(user.id, user);
  }

  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }
}

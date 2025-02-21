import '../data/models/user.dart';
import '../data/repositories/user_repository.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<void> addUser(User user) async {
    await _userRepository.addUser(user);
  }

  User? getCurrentUser() {
    return _userRepository.getCurrentUser();
  }

  Future<void> updateUser(User user) async {
    await _userRepository.updateUser(user);
  }

  Future<void> deleteUser(String id) async {
    await _userRepository.deleteUser(id);
  }
}

import '../mock/delay.dart';
import '../mock/seed.dart';
import '../models/user.dart';

class UserRepository {
  UserRepository();

  final List<UserModel> _users = MockSeed.users();

  Future<UserModel?> byId(String id) async {
    await mockLatency(80);
    return _users.firstWhere((element) => element.id == id, orElse: () => _users.first);
  }

  UserModel get guest => const UserModel(id: 'guest', name: 'Guest', avatar: '', isGuest: true, prefs: {});
}

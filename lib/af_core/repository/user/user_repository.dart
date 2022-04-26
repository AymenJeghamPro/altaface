import 'dart:convert';

import 'package:altaface/_shared/local_storage/secure_shared_prefs.dart';
import 'package:altaface/af_core/entity/user/user.dart';

class UsersRepository {
  late SecureSharedPrefs _sharedPrefs;
  User? _currentUser;

  static UsersRepository? _singleton;

  static Future<void> initRepo() async {
    await getInstance()._readDataUser();
  }

  static UsersRepository getInstance() {
    _singleton ??= UsersRepository.withSharedPrefs(SecureSharedPrefs());
    return _singleton!;
  }

  UsersRepository.withSharedPrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  void saveUser(User user) {
    _sharedPrefs.save('user', user);
  }

  Future<void> _readDataUser() async {
    var user = await _sharedPrefs.getString('user');
    if (user != null) {
      _currentUser = User.fromJson(json.decode(user));
    }
  }
}

import 'dart:convert';

import 'package:flutter_projects/_shared/local_storage/secure_shared_prefs.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';

class UsersRepository {
  late SecureSharedPrefs _sharedPrefs;
  User? _currentUser;

  static UsersRepository? _singleton;

  factory UsersRepository() {
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

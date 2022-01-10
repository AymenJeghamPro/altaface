

import 'package:flutter_projects/_shared/local_storage/secure_shared_prefs.dart';

class UsersRepository {
  late SecureSharedPrefs _sharedPrefs;

  static UsersRepository? _singleton;

  factory UsersRepository() {
    _singleton ??= UsersRepository.withSharedPrefs(SecureSharedPrefs());
    return _singleton!;
  }

  UsersRepository.withSharedPrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
  }







}

import 'dart:io';

import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/service/user/user_login_provider..dart';
import 'package:flutter_projects/ui/usersList/contracts/users_list_view.dart';
import 'package:image_picker/image_picker.dart';

class UserLoginPresenter {
  final UsersListView _view;
  final UserLoginProvider _currentUserProvider;

  late String photo;
  File? _imagefile;
  final picker = ImagePicker();

  UserLoginPresenter(this._view) : _currentUserProvider = UserLoginProvider();

  UserLoginPresenter.initWith(this._view, this._currentUserProvider);

  Future<void> getImagecamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _imagefile = File(pickedFile.path);
      _view.showToast('Image a été capturé avec succès');
    } else {
      print('No image selected.');
    }
  }

  Future<void> login(String login, String password) async {
    _view.clearLoginErrors();
    if (!_isInputValid(password)) return;
    if (_currentUserProvider.isLoading) return;

    try {
      _view.showLoggingLoader();
      var user = await _currentUserProvider.login(login, password);
      _view.hideLoggingLoader();
      getImagecamera();
    } on AFException catch (e) {
      _view.hideLoggingLoader();
      _view.onLoginFailed("Login Failed", e.userReadableMessage);
    }
  }

  bool _isInputValid(String password) {
    var isValid = true;

    if (password.isEmpty || password.length < 4) {
      isValid = false;
      _view.notifyInvalidPassword("password must have at least 4 characters");
    }

    return isValid;
  }
}

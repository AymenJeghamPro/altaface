import 'package:flutter/foundation.dart';
import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/service/user/user_login_provider..dart';
import 'package:flutter_projects/common_widgets/alert/alert.dart';
import 'package:flutter_projects/common_widgets/screen_presenter/screen_presenter.dart';
import 'package:flutter_projects/ui/imageCapture/Views/image_capture_screen.dart';
import 'package:flutter_projects/ui/usersList/contracts/uses_list_view.dart';

class UserLoginPresenter {
  final UsersListView _view;
  final UserLoginProvider _currentUserProvider;

  UserLoginPresenter(this._view) : _currentUserProvider = UserLoginProvider();

  UserLoginPresenter.initWith(this._view, this._currentUserProvider);

  Future<void> login(String login, String password) async {
    if (!_isInputValid(password)) return;
    if (_currentUserProvider.isLoading) return;

    try {
      _view.showLoader();
      var user = await _currentUserProvider.login(login, password);
      _view.hideLoader();
      _view.goToImageCaptureScreen(user!);
    } on AFException catch (e) {
      _view.hideLoader();
      _view.onLoginFailed("Login Failed", e.userReadableMessage);
    }
  }

  bool _isInputValid(String key) {
    var isValid = true;

    if (key.isEmpty) {
      isValid = false;
      _view.notifyInvalidLogin('Login or Password invalid');
    }

    return isValid;
  }
}

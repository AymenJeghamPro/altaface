import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/service/user/user_login_provider..dart';
import 'package:flutter_projects/ui/usersList/contracts/users_list_view.dart';

class UserLoginPresenter {
  final UsersListView _view;
  final UserLoginProvider _currentUserProvider;

  UserLoginPresenter(this._view) : _currentUserProvider = UserLoginProvider();

  UserLoginPresenter.initWith(this._view, this._currentUserProvider);

  Future<void> login(String login, String password) async {
    _view.clearLoginErrors();
    if (!_isInputValid(password)) return;
    if (_currentUserProvider.isLoading) return;

    try {
      _view.showLoggingLoader();
      var user = await _currentUserProvider.login(login, password);
      _view.hideLoggingLoader();
      _view.goToImageCaptureScreen(user!);
    } on AFException catch (e) {
      _view.hideLoggingLoader();
      _view.onLoginFailed("Login Failed", e.userReadableMessage);
    }
  }

  bool _isInputValid(String password) {
    var isValid = true;

    if (password.isEmpty || password.length < 4 ) {
      isValid = false;
      _view.notifyInvalidPassword("password must have at least 4 characters");
    }

    return isValid;
  }
}

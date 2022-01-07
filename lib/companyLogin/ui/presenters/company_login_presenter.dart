

import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/company_management/services/current_company_provider.dart';
import 'package:flutter_projects/companyLogin/ui/contracts/company_login_view.dart';

class CompanyLoginPresenter {
  final CompanyLoginView _view;
  final CurrentCompanyProvider _currentCompanyProvider;

  CompanyLoginPresenter(this._view) : _currentCompanyProvider = CurrentCompanyProvider();

  CompanyLoginPresenter.initWith(this._view, this._currentCompanyProvider);

  Future<void> login(String key) async {
    _view.clearLoginErrors();
    if (!_isInputValid(key)) return;
    if (_currentCompanyProvider.isLoading) return;

    try {
      _view.showLoader();
      await _currentCompanyProvider.login(key);
      _view.hideLoader();
      _view.goToTechniciansListScreen();
    } on AFException catch (e) {
      _view.hideLoader();
      _view.onLoginFailed("Login Failed", e.userReadableMessage);
    }
  }

  bool _isInputValid(String key) {
    var isValid = true;

    if (key.isEmpty) {
      isValid = false;
      _view.notifyInvalidCompanyKey("Invalid key");
    }

    return isValid;
  }
}

import 'package:altaface/_shared/exceptions/af_exception.dart';
import 'package:altaface/af_core/service/company/current_company_provider.dart';
import 'package:altaface/ui/companyLogin/contracts/company_login_view.dart';

class CompanyLoginPresenter {
  final CompanyLoginView _view;
  final CurrentCompanyProvider _currentCompanyProvider;

  CompanyLoginPresenter(this._view)
      : _currentCompanyProvider = CurrentCompanyProvider();

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

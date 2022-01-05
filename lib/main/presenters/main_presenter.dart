import 'package:flutter_projects/af_core/company_management/services/current_company_provider.dart';
import 'package:flutter_projects/main/contracts/main_view.dart';

class MainPresenter {
  final MainView _view;
  final CurrentCompanyProvider _currentCompanyProvider;

  MainPresenter(this._view)
      : _currentCompanyProvider = CurrentCompanyProvider();

  MainPresenter.initWith(this._view, this._currentCompanyProvider);


  Future<void> showLandingScreen() async {
    var _ = await Future.delayed(const Duration(milliseconds: 1000));

    if (isLoggedIn() == false) {
      _view.showLoginScreen();
    } else {
      _showLandingScreenForLoggedInUser();
    }
  }

  void _showLandingScreenForLoggedInUser() {

  }

  bool isLoggedIn() {
    return _currentCompanyProvider.isLoggedIn();
  }
}

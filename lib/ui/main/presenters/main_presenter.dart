
import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';
import 'package:flutter_projects/ui/main/contracts/main_view.dart';

class MainPresenter {
  final MainView _view;
  final CurrentCompanyProvider _currentCompanyProvider;

  MainPresenter(this._view)
      : _currentCompanyProvider = CurrentCompanyProvider();

  MainPresenter.initWith(this._view, this._currentCompanyProvider);


  Future<void> showLandingScreen() async {
    var _ = await Future.delayed(const Duration(milliseconds: 5000));

    if (isLoggedIn() == false) {
      _view.showLoginScreen();
    } else {
      _view.goToUsersListScreen();
    }
  }

  bool isLoggedIn() {
    return _currentCompanyProvider.isLoggedIn();
  }
}

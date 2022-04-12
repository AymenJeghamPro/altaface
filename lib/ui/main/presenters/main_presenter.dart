import 'package:flutter_projects/af_core/repository/repository_initializer.dart';
import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';
import 'package:flutter_projects/af_core/service/user/user_login_provider.dart';
import 'package:flutter_projects/ui/main/contracts/main_view.dart';

class MainPresenter {
  final MainView _view;
  final RepositoryInitializer _repositoryInitializer;
  final CurrentCompanyProvider _currentCompanyProvider;
  final UserLoginProvider _userLoginProvider;

  MainPresenter(this._view)
      : _repositoryInitializer = RepositoryInitializer(),
        _currentCompanyProvider = CurrentCompanyProvider(),
        _userLoginProvider = UserLoginProvider();

  MainPresenter.initWith(this._view, this._currentCompanyProvider,
      this._repositoryInitializer, this._userLoginProvider);

  Future<void> initializeReposAndShowLandingScreen() async {
    await _repositoryInitializer.initializeRepos();
    var isLoggedIn = _currentCompanyProvider.isLoggedIn();
    var isAdminLoggedIn = _userLoginProvider.isLoggedIn();
    if ((isLoggedIn && isAdminLoggedIn) == false) {
      _view.showLoginScreen();
    } else {
      _view.goToUsersListScreen();
    }
  }
}

import 'package:flutter_projects/af_core/repository/repository_initializer.dart';
import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';
import 'package:flutter_projects/ui/main/contracts/main_view.dart';

class MainPresenter {
  final MainView _view;
  final RepositoryInitializer _repositoryInitializer;
  final CurrentCompanyProvider _currentCompanyProvider;

  MainPresenter(this._view)
      : _repositoryInitializer = RepositoryInitializer(),
        _currentCompanyProvider = CurrentCompanyProvider();

  MainPresenter.initWith(
    this._view,
    this._currentCompanyProvider,
    this._repositoryInitializer,
  );

  Future<void> initializeReposAndShowLandingScreen() async {
    await _repositoryInitializer.initializeRepos();
    var isLoggedIn = _currentCompanyProvider.isLoggedIn();
    if (isLoggedIn == false) {
      _view.showLoginScreen();
    } else {
      _view.goToUsersListScreen();
    }
  }

}

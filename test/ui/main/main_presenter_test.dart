import 'package:flutter_projects/af_core/repository/repository_initializer.dart';
import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';
import 'package:flutter_projects/ui/main/contracts/main_view.dart';
import 'package:flutter_projects/ui/main/presenters/main_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMainView extends Mock implements MainView {}

class MockCurrentCompanyProvider extends Mock
    implements CurrentCompanyProvider {}

class MockRepositoryInitializer extends Mock implements RepositoryInitializer {}

void main() {
  var view = MockMainView();
  var currentCompanyProvider = MockCurrentCompanyProvider();
  var repositoryInitializer = MockRepositoryInitializer();

  var presenter = MainPresenter.initWith(
      view, currentCompanyProvider, repositoryInitializer);

  setUpAll(() {
    when(() => repositoryInitializer.initializeRepos())
        .thenAnswer((invocation) => Future.value(null));
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(repositoryInitializer);
    verifyNoMoreInteractions(currentCompanyProvider);
  }

  test('navigates to login screen if a user is not logged in', () async {
    //given
    when(() => currentCompanyProvider.isLoggedIn()).thenReturn(false);

    //when
    await presenter.initializeReposAndShowLandingScreen();

    verifyInOrder([
      () => repositoryInitializer.initializeRepos(),
      () => currentCompanyProvider.isLoggedIn(),
      () => view.showLoginScreen()
    ]);

    _verifyNoMoreInteractionsOnAllMocks();
  });



  test('navigates to the company techicians list screen when a company is cached', () async {
    //given
    when(() => currentCompanyProvider.isLoggedIn()).thenReturn(true);

    //when
    await presenter.initializeReposAndShowLandingScreen();

    //then
    verifyInOrder([
          () => repositoryInitializer.initializeRepos(),
          () => currentCompanyProvider.isLoggedIn(),
          () => view.goToUsersListScreen()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

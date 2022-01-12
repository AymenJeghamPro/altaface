import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';
import 'package:flutter_projects/ui/main/contracts/main_view.dart';
import 'package:flutter_projects/ui/main/presenters/main_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';



class MockMainView extends Mock implements MainView {}

class MockCurrentCompanyProvider extends Mock implements CurrentCompanyProvider {}

void main() {
  var view = MockMainView();
  var currentCompanyProvider = MockCurrentCompanyProvider();
  var presenter = MainPresenter.initWith(
      view, currentCompanyProvider);

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(currentCompanyProvider);
  }

  test('navigates to login screen if a user is not logged in', () async {
    //given
    when(() => currentCompanyProvider.isLoggedIn()).thenReturn(false);

    //when
    await presenter.showLandingScreen();

    verifyInOrder(
        [() => currentCompanyProvider.isLoggedIn(), () => view.showLoginScreen()]);

    _verifyNoMoreInteractionsOnAllMocks();
  });
}

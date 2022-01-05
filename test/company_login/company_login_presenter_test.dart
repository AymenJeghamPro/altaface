import 'package:flutter_projects/_shared/exceptions/invalid_response_exception.dart';
import 'package:flutter_projects/af_core/company_management/entities/company.dart';
import 'package:flutter_projects/af_core/company_management/entities/credentials.dart';
import 'package:flutter_projects/af_core/company_management/services/current_company_provider.dart';
import 'package:flutter_projects/companyLogin/ui/contracts/company_login_view.dart';
import 'package:flutter_projects/companyLogin/ui/presenters/company_login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginView extends Mock implements CompanyLoginView {}

class MockCompanyProvider extends Mock implements CurrentCompanyProvider {}

class MockCredentials extends Mock implements Credentials {}

class MockCompany extends Mock implements Company {}


void main() {
  var view = MockLoginView();
  var provider = MockCompanyProvider();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(provider);
  }

  setUpAll(() {
    registerFallbackValue(MockCredentials());
  });

  test('logging in successfully', () async {
    //given
    when(  () => provider.isLoading).thenReturn(false);
    when(() => provider.login(any()))
        .thenAnswer((_) =>Future.value(MockCompany()));

    CompanyLoginPresenter presenter = CompanyLoginPresenter.initWith(view, provider);

    //when
    await presenter.login("key");

    //then
    verifyInOrder([
          () => view.clearLoginErrors(),
          () => provider.isLoading,
          () => view.showLoader(),
          () => provider.login(any()),
          () => view.hideLoader(),
          () => view.goToTechniciansListScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });


    test('logging in with invalid key notifies the view', () async {
    //given
    when(  () => provider.isLoading).thenReturn(false);
    CompanyLoginPresenter presenter = CompanyLoginPresenter.initWith(view, provider);

    //when
    await presenter.login("");

    //then
    verifyInOrder([
          () => view.clearLoginErrors(),
          () => view.notifyInvalidCompanyKey("Invalid key"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('logging in with valid credentials clears the errors', () async {
    //given
    when( () => provider.isLoading).thenReturn(false);
    when(() => provider.login(any()))
        .thenAnswer((_) =>Future.value(MockCompany()));

    CompanyLoginPresenter presenter = CompanyLoginPresenter.initWith(view, provider);
    await presenter.login("");

    //when
    await presenter.login("key");

    //then
    verifyInOrder([
          () => view.clearLoginErrors(),
          () =>  view.notifyInvalidCompanyKey("Invalid key"),
          () => view.clearLoginErrors(),
          () => provider.isLoading,
          () => view.showLoader(),
          () => provider.login(any()),
          () => view.hideLoader(),
          () => view.goToTechniciansListScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('logging in when the provider is loading does nothing', () async {
    //given
    when(() => provider.isLoading).thenReturn(true);
    CompanyLoginPresenter presenter = CompanyLoginPresenter.initWith(view, provider);

    //when
    await presenter.login("key");

    //then
    verifyInOrder([
          () => view.clearLoginErrors(),
          () => provider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to login successfully', () async {
    //given
    when(  () => provider.isLoading).thenReturn(false);
    when( () => provider.login(any())).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    CompanyLoginPresenter presenter = CompanyLoginPresenter.initWith(view, provider);

    //when
    await presenter.login("key");

    //then
    verifyInOrder([
          () => view.clearLoginErrors(),
          () => provider.isLoading,
          () => view.showLoader(),
          () => provider.login(any()),
          () => view.hideLoader(),
          () => view.onLoginFailed("Login Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

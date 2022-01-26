import 'package:flutter_projects/_shared/exceptions/invalid_response_exception.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/service/user/user_login_provider..dart';
import 'package:flutter_projects/af_core/service/user/users_list_provider.dart';
import 'package:flutter_projects/ui/usersList/contracts/users_list_view.dart';
import 'package:flutter_projects/ui/usersList/presenters/user_login_presenter.dart';
import 'package:flutter_projects/ui/usersList/presenters/users_list_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersListView extends Mock implements UsersListView {}

class MockUser extends Mock implements User {}

class MockUsersListProvider extends Mock implements UsersListProvider {}

class MockUserLoginProvider extends Mock implements UserLoginProvider {}

void main() {
  var view = MockUsersListView();
  var mockUsersListProvider = MockUsersListProvider();
  var mockUserLoginProvider = MockUserLoginProvider();

  late UsersListPresenter presenter;
  late UserLoginPresenter loginPresenter;

  var user1 = MockUser();
  var user2 = MockUser();
  List<User> _usersList = [user1, user2];

  setUpAll(() {
    when(() => user1.id).thenReturn("id1");
    when(() => user2.id).thenReturn("id2");
    when(() => user1.userName).thenReturn("user1");
    when(() => user2.userName).thenReturn("user2");
  });

  setUp(() {
    presenter = UsersListPresenter.initWith(view, mockUsersListProvider);
  });

  setUp(() {
    loginPresenter = UserLoginPresenter.initWith(view, mockUserLoginProvider);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockUsersListProvider);
  }

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockUsersListProvider);
  }

  test('select user from users list successfully', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers())
        .thenAnswer((_) => Future.value(_usersList));
    await presenter.getUsers();
    _resetAllMockInteractions();
    //when
    await presenter.selectUserAtIndex(0);

    //then
    verifyInOrder([
      () => view.onUserClicked(user1),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('user login succefuly', () async {
    //given
    when(() => mockUserLoginProvider.isLoading).thenReturn(false);
    when(() => mockUserLoginProvider.login(any(), any()))
        .thenAnswer((_) => Future.value(user1));

    //when
    await loginPresenter.login('login', 'password');

    //then
    verifyInOrder([
      () => view.clearLoginErrors(),
      () => view.showLoggingLoader(),
      () => mockUserLoginProvider.login(any(), any()),
      () => view.hideLoggingLoader(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('user login failed', () async {
    //given
    when(() => mockUserLoginProvider.isLoading).thenReturn(false);
    when(() => mockUserLoginProvider.login(any(), any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await loginPresenter.login('login', 'password');

    //then
    verifyInOrder([
      () => view.clearLoginErrors(),
      () => view.showLoggingLoader(),
      () => mockUserLoginProvider.login(any(), any()),
      () => view.hideLoggingLoader(),
      () => view.onLoginFailed(
          "Login Failed", InvalidResponseException().userReadableMessage)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('user login failed with invalid password ', () async {
    //given
    when(() => mockUserLoginProvider.isLoading).thenReturn(false);
    UserLoginPresenter loginPresenter =
        UserLoginPresenter.initWith(view, mockUserLoginProvider);

    //when
    await loginPresenter.login("user1", "");

    //then
    verifyInOrder([
      () => view.clearLoginErrors(),
      () => view
          .notifyInvalidPassword("password must have at least 4 characters"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

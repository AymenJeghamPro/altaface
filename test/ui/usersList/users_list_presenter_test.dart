import 'package:flutter_projects/_shared/exceptions/invalid_response_exception.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/service/user/users_list_provider.dart';
import 'package:flutter_projects/ui/usersList/contracts/uses_list_view.dart';
import 'package:flutter_projects/ui/usersList/presenters/users_list_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersListView extends Mock implements UsersListView {}

class MockUser extends Mock implements User {}

class MockUsersListProvider extends Mock implements UsersListProvider {}

void main() {
  var view = MockUsersListView();
  var mockUsersListProvider = MockUsersListProvider();
  late UsersListPresenter presenter;

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

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockUsersListProvider);
  }
  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockUsersListProvider);
  }

  test('retrieving users successfully', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers()).thenAnswer((_) => Future.value(_usersList));

    //when
    await presenter.getUsers();

    //then
    verifyInOrder([
          () => mockUsersListProvider.isLoading,
          () => view.showLoader(),
          () => mockUsersListProvider.getUsers(),
          () => view.showSearchBar(),
          () => view.showUsersList(_usersList),
          () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  
  test('retrieving users successfully with empty list', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers()).thenAnswer((_) => Future.value(List.empty()));

    //when
    await presenter.getUsers();

    //then
    verifyInOrder([
          () => mockUsersListProvider.isLoading,
          () => view.showLoader(),
          () => mockUsersListProvider.getUsers(),
          () => view.hideSearchBar(),
          () => view.showNoUsersMessage("There are no users.\n\nTap here to reload"),
          () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  
  test('retrieving users failed', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers()).thenAnswer(
          (realInvocation) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.getUsers();

    //then
    verifyInOrder([
          () => mockUsersListProvider.isLoading,
          () => view.showLoader(),
          () => mockUsersListProvider.getUsers(),
          () => view.hideSearchBar(),
          () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
          () => view.hideLoader(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('performing search successfully', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers()).thenAnswer((_) => Future.value(_usersList));
    await presenter.getUsers();
    _resetAllMockInteractions();

    //when
    presenter.performSearch("user2");

    //then
    verifyInOrder([
          () => view.showUsersList([user2]),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('performing search with no successful results', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers()).thenAnswer((_) => Future.value(_usersList));
    await presenter.getUsers();
    _resetAllMockInteractions();

    //when
    presenter.performSearch("non existant user");

    //then
    verifyInOrder([
          () => view.showNoSearchResultsMessage("There are no users for the  given search criteria."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });


  test('search text is reset when search bar is hidden', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers()).thenAnswer((_) => Future.value(_usersList));
    presenter.performSearch("c1");

    //when
    when(() => mockUsersListProvider.getUsers())
        .thenAnswer((realInvocation) => Future.error(InvalidResponseException()));
    await presenter.getUsers();

    //then
    expect(presenter.getSearchText(), "");
  });

  test('refresh the list of users', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers()).thenAnswer((_) => Future.value(_usersList));

    await presenter.getUsers();
    _resetAllMockInteractions();

    //when
    await presenter.refresh();

    //then
    verifyInOrder([
          () => mockUsersListProvider.reset(),
          () => mockUsersListProvider.isLoading,
          () => view.showLoader(),
          () => mockUsersListProvider.getUsers(),
          () => view.showSearchBar(),
          () => view.showUsersList(_usersList),
          () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('select user from users list successfully', () async {
    //given
    when(() => mockUsersListProvider.isLoading).thenReturn(false);
    when(() => mockUsersListProvider.getUsers()).thenAnswer((_) => Future.value(_usersList));
    await presenter.getUsers();
    _resetAllMockInteractions();

    //when
    await presenter.selectUserAtIndex(0);

    //then
    verifyInOrder([
          () => view.onUserClicked(user1)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

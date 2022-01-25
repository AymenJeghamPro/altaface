import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/service/user/user_login_provider..dart';
import 'package:flutter_projects/af_core/service/user/users_list_provider.dart';
import 'package:flutter_projects/ui/usersList/contracts/uses_list_view.dart';
import 'package:flutter_projects/ui/usersList/presenters/user_login_presenter.dart';

class UsersListPresenter {
  final UsersListView _view;
  final UsersListProvider _usersListProvider;

  final List<User> _users = [];
  final List<User> _filterList = [];
  var _searchText = "";

  UsersListPresenter(this._view) : _usersListProvider = UsersListProvider();

  UsersListPresenter.initWith(this._view, this._usersListProvider);

  Future<void> getUsers() async {
    if (_usersListProvider.isLoading) return;
    _users.clear();
    _view.showLoader();

    try {
      var users = await _usersListProvider.getUsers();
      _handleResponse(users);
      _view.hideLoader();
    } on AFException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  Future<void> userLogin(String password) async {
    _view.clearLoginErrors();
    if (!_isInputValid(password)) return;

    try {
      _view.showLoggingLoader();
      //service to auth
      await Future.delayed(const Duration(milliseconds: 500));
      _view.hideLoggingLoader();
      _view.takePicture();
    } on AFException catch (e) {
      _view.hideLoggingLoader();
      _view.onLoginFailed("Login Failed", e.userReadableMessage);
    }
  }

  selectUserAtIndex(int index) async {
    var _selectedUser = _filterList[index];
    selectUser(_selectedUser);
  }

  selectUser(User user) async {
    _view.onUserClicked(user);
  }

  void _handleResponse(List<User> users) {
    _users.addAll(users);
    if (_users.isNotEmpty) {
      _view.showSearchBar();
      _showFilteredUsers();
    } else {
      _clearSearchTextAndHideSearchBar();
      _view.showNoUsersMessage("There are no users.\n\nTap here to reload");
    }
  }

  void _showFilteredUsers() {
    _filterList.clear();
    for (int i = 0; i < _users.length; i++) {
      var item = _users[i];
      if (item.userName!.toLowerCase().contains(_searchText.toLowerCase())) {
        _filterList.add(item);
      }
    }

    if (_filterList.isEmpty) {
      _view.showNoSearchResultsMessage(
          "There are no users for the  given search criteria.");
    } else {
      _view.showUsersList(_filterList);
    }
  }

  void _clearSearchTextAndHideSearchBar() {
    _searchText = "";
    _view.hideSearchBar();
  }

  performSearch(String searchText) {
    _searchText = searchText;
    _showFilteredUsers();
  }

  refresh() {
    _usersListProvider.reset();
    getUsers();
  }

  String getSearchText() {
    return _searchText;
  }

  List<User> getCompanies() {
    return _users;
  }

  bool _isInputValid(String password) {
    var isValid = true;

    if (password.isEmpty) {
      isValid = false;
      _view.notifyInvalidPassword("Please insert password");
    }

    if (password.length < 4) {
      isValid = false;
      _view.notifyInvalidPassword("password must have at least 4 characters");
    }

    return isValid;
  }
}

import 'package:flutter_projects/af_core/service/user/user_login_provider.dart';

import '../../../_shared/exceptions/af_exception.dart';
import '../../../af_core/entity/user/user.dart';
import '../../../af_core/service/user/users_list_provider.dart';
import '../contracts/admins_list_view.dart';

class AdminListPresenter {
  final AdminListView _view;
  final UsersListProvider _usersListProvider;
  final UserLoginProvider _userLoginProvider;

  var _searchText = "";

  final List<User> _users = [];
  final List<User> _filterList = [];
  User? _selectedUser;

  AdminListPresenter(this._view)
      : _userLoginProvider = UserLoginProvider(),
        _usersListProvider = UsersListProvider();

  AdminListPresenter.initWith(
      this._view, this._userLoginProvider, this._usersListProvider);

  performSearch(String searchText) {
    _searchText = searchText;
    _showFilteredUsers();
  }

  Future<void> getAdmins() async {
    if (_usersListProvider.isLoading) return;
    _users.clear();
    _view.showLoader();

    try {
      var users = await _usersListProvider.getUsers(isAdmin: true);

      handleResponse(users);
      _view.hideLoader();
    } on AFException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  Future<void> refreshAdmins() async {
    if (_usersListProvider.isLoading) return;
    _users.clear();
    try {
      var users = await _usersListProvider.getUsers(isAdmin: true);
      handleResponse(users);
    } on AFException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  Future<void> adminLogin(String userName ,String password) async {
    _view.clearLoginErrors();
    if (!_isInputValid(password)) return;

    try {
      _view.showLoggingLoader();
      await _userLoginProvider.login(userName,password);
      _view.hideLoggingLoader();
      _view.onLoginSuccessful();
    } on AFException catch (e) {
      _view.hideLoggingLoader();
      _view.onLoginFailed("Login Failed", e.userReadableMessage);
    }
  }

  refresh() {
    _usersListProvider.reset();
    getAdmins();
  }

  void _clearSearchTextAndHideSearchBar() {
    _searchText = "";
    _view.hideSearchBar();
  }

  void handleResponse(List<User> users) {
    var admins = users.where((user) => user.type == "Admin").toList();
    _handleResponse(admins);
  }

  void _handleResponse(List<User> users) {
    _users.addAll(users);
    if (_users.isNotEmpty) {
      _view.showSearchBar();
      _showFilteredUsers();
    } else {
      _clearSearchTextAndHideSearchBar();
      _view.showNoAdminsMessage("There are no users.\n\nTap here to reload");
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
      _view.showAdminsList(_filterList);
    }
  }

  selectAdminAtIndex(int index) async {
    _selectedUser = _filterList[index];
    selectUser(_selectedUser!);
  }

  selectUser(User user) async {
    _view.onAdminClicked(user);
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

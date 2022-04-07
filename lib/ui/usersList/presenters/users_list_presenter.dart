import 'dart:io';

import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/service/user/user_login_provider.dart';
import 'package:flutter_projects/af_core/service/user/users_list_provider.dart';
import 'package:flutter_projects/ui/usersList/contracts/users_list_view.dart';

class UsersListPresenter {
  final UsersListView _view;
  final UsersListProvider _usersListProvider;
  final UserLoginProvider _userLoginProvider;

  final List<User> _users = [];
  final List<User> _filterList = [];
  User? _selectedUser;

  var _searchText = "";

  UsersListPresenter(this._view)
      : _usersListProvider = UsersListProvider(),
        _userLoginProvider = UserLoginProvider();

  UsersListPresenter.initWith(
      this._view, this._usersListProvider, this._userLoginProvider);

  Future<void> getUsers(int index) async {
    if (_usersListProvider.isLoading) return;
    _users.clear();
    _view.showLoader();

    try {
      var users = await _usersListProvider.getUsers();

      handleResponse(index, users);
      _view.hideLoader();
    } on AFException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  void handleResponse(int index, List<User> users) {
    switch (index) {
      case 0:
        {
          var usersNotStarted =
              users.where((user) => user.activitiesCount == 0).toList();
          _handleResponse(usersNotStarted);
        }
        break;

      case 1:
        {
          var usersStarted =
              users.where((user) => user.activitiesCount > 0).toList();
          _handleResponse(usersStarted);
        }
        break;
    }
  }

  Future<void> refreshUsers(int index) async {
    if (_usersListProvider.isLoading) return;
    _users.clear();
    try {
      var users = await _usersListProvider.getUsers();
      handleResponse(index, users);
    } on AFException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  Future<void> startWorkday(File imageFile, User selectedUser) async {
    try {
      _view.showLoader();
      await _userLoginProvider.startWorkDay(imageFile.path, selectedUser.id!);
      _view.hideLoader();
      _view.onUploadImageSuccessful();
    } on AFException catch (e) {
      _view.hideLoader();
      _view.onUploadImageFailed("Login Failed", e.userReadableMessage);
    }
  }

  selectUserAtIndex(int index) async {
    _selectedUser = _filterList[index];
    //selectUser(_selectedUser);
  }

  getSelectedUser() {
    if(_selectedUser != null){
      return _selectedUser;
    }
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

  refresh(int index) {
    _usersListProvider.reset();
    getUsers(index);
  }

  String getSearchText() {
    return _searchText;
  }

  List<User> getCompanies() {
    return _users;
  }
}

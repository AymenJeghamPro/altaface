
import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/service/user/users_list_provider.dart';
import 'package:flutter_projects/ui/usersList/contracts/uses_list_view.dart';

class UsersListPresenter {
  final UsersListView _view;
  final UsersListProvider _usersListProvider ;
  final List<User> _users = [];
  var _searchText = "";

  UsersListPresenter(this._view) : _usersListProvider = UsersListProvider();

  UsersListPresenter.initWith(this._view, this._usersListProvider);

  Future<void> getUsers() async {
    if (_usersListProvider.isLoading) return;
    _users.clear();
    _view.showLoader();

    try {
      var users  = await  _usersListProvider.getUsers("6690cbdb-b1d6-4bf3-af52-03ba3a5c7169");
      _handleResponse(users);

    } on AFException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }

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
    List<User> _filterList = [];
    for (int i = 0; i < _users.length; i++) {
      var item = _users[i];
      if (item.userName!.toLowerCase().contains(_searchText.toLowerCase())) {
        _filterList.add(item);
      }
    }

    if (_filterList.isEmpty) {
      _view.showNoSearchResultsMessage("There are no users for the  given search criteria.");
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
    _showFilteredCompanies();
  }

  refresh() {
    _usersListProvider.reset();
    getUsers();
  }

  void _showFilteredCompanies() {
    List<User> _filteredList = [];
    for (int i = 0; i < _users.length; i++) {
      var item = _users[i];
      if (item.userName!.toLowerCase().contains(_searchText.toLowerCase())) {
        _filteredList.add(item);
      }
    }

    if (_filteredList.isEmpty) {
      _view.showNoSearchResultsMessage("There are no user with the  given search criteria.");
    } else {
      _view.showUsersList(_filteredList);
    }
  }

}

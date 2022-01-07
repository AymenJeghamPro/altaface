
import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/users_management/services/users_list_provider.dart';
import 'package:flutter_projects/usersList/ui/contracts/uses_list_view.dart';

class UsersListPresenter {
  final UsersListView _view;
  final UsersListProvider _usersListProvider ;

  UsersListPresenter(this._view) : _usersListProvider = UsersListProvider();

  UsersListPresenter.initWith(this._view, this._usersListProvider);

  Future<void> getUsers() async {
    if (_usersListProvider.isLoading) return;

    try {
      _view.showLoader();
      var users = await _usersListProvider.getUsers("6690cbdb-b1d6-4bf3-af52-03ba3a5c7169");
      _view.hideLoader();
      _view.onUsersLoadedSuccessfully(users);
    } on AFException catch (e) {
      _view.hideLoader();
      _view.onUsersLoadedWithFailure("Failed To Load Users", e.userReadableMessage);
    }
  }

}

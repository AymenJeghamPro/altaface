import 'package:flutter/material.dart';
import 'package:flutter_projects/af_core/users_management/entities/users.dart';
import 'package:flutter_projects/common_widgets/notifiable/item_notifiable.dart';
import 'package:flutter_projects/usersList/ui/contracts/uses_list_view.dart';
import 'package:flutter_projects/usersList/ui/presenters/users_list_presenter.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen>
    implements UsersListView {
  late UsersListPresenter presenter;
  var _showLoaderNotifier = ItemNotifier<bool>();
  var _showErrorNotifier = ItemNotifier<bool>();
  var _usersListNotifier = ItemNotifier<List<User>?>();
  var _viewSelector = ItemNotifier<int>();
  var _scrollController = ScrollController();

  @override
  void initState() {
    presenter = UsersListPresenter(this);
    presenter.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [Expanded(child: _getUsers())]);
  }

  Widget _getUsers() {
    return ItemNotifiable<List<User>>(
      notifier: _usersListNotifier,
      builder: (context, value) => Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: value?.length,
          itemBuilder: (context, index) {
            if (value != null) {
              return Text(value[index].userName ?? "--");
            } else {
              return const Text("no users");
            }
          },
        ),
      ),
    );
  }

  @override
  void showLoader() {}

  @override
  void hideLoader() {}

  @override
  void onUsersLoadedSuccessfully(List<User> users) {
    _usersListNotifier.notify(users);
  }

  @override
  void onUsersLoadedWithFailure(String title, String message) {
    // TODO: implement onUsersLoadedWithFailure
  }
}

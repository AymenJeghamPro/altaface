
import 'package:flutter_projects/af_core/users_management/entities/users.dart';

abstract class UsersListView {

  void showLoader();

  void hideLoader();

  void onUsersLoadedSuccessfully(List<User> users);

  void onUsersLoadedWithFailure(String title, String message);

}

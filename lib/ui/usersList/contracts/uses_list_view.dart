
import 'package:flutter_projects/af_core/entity/user/user.dart';

abstract class UsersListView {

  void showLoader();

  void hideLoader();

  void showSearchBar();

  void hideSearchBar();

  void showUsersList(List<User> users);

  void showNoUsersMessage(String message);

  void showNoSearchResultsMessage(String message);

  void showErrorMessage(String message);

  void onUserClicked(User user);

}

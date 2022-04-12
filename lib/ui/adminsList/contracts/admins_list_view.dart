import '../../../af_core/entity/user/user.dart';

abstract class AdminListView {

  void showLoader();

  void hideLoader();

  void showSearchBar();

  void hideSearchBar();

  void notifyInvalidLogin(String message);

  void onLoginFailed(String title, String message);

  void onLoginSuccessful();

  void showAdminsList(List<User> users);

  void showNoAdminsMessage(String message);

  void showNoSearchResultsMessage(String message);

  void showErrorMessage(String message);

  void onAdminClicked(User user);

  void showLoggingLoader();

  void hideLoggingLoader();

  void clearLoginErrors();

  void notifyInvalidPassword(String message);

}
abstract class CompanyLoginView {
  void showLoader();

  void hideLoader();

  void notifyInvalidCompanyKey(String message);

  void clearLoginErrors();

  void goToTechniciansListScreen();

  void onLoginFailed(String title, String message);
}

import 'package:flutter/material.dart';
import 'package:altaface/common_widgets/screen_presenter/screen_presenter.dart';
import 'package:altaface/ui/companyLogin/views/company_login_screen.dart';
import 'package:altaface/ui/main/contracts/main_view.dart';
import 'package:altaface/ui/main/presenters/main_presenter.dart';
import 'package:altaface/ui/usersList/views/users_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> implements MainView {
  late MainPresenter presenter;

  @override
  void initState() {
    presenter = MainPresenter(this);
    presenter.initializeReposAndShowLandingScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
      ),
    );
  }

  @override
  void showLoginScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(
        const CompanyLoginScreen(), context);
  }

  @override
  void goToUsersListScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(
        const UsersListScreen(), context);
  }
}

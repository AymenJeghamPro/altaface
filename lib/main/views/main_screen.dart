import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';
import 'package:flutter_projects/common_widgets/screen_presenter/screen_presenter.dart';
import 'package:flutter_projects/companyLogin/ui/views/company_login_screen.dart';
import 'package:flutter_projects/main/contracts/main_view.dart';
import 'package:flutter_projects/main/presenters/main_presenter.dart';


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
    presenter.showLandingScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.defaultColor,
      ),
    );
  }

  @override
  void showLoginScreen() {
    ScreenPresenter.present(const CompanyLoginScreen(), context);
  }

  @override
  void goToUsersListScreen() {
    // TODO: implement goToUsersListScreen
  }




}

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';
import 'package:flutter_projects/common_widgets/alert/alert.dart';
import 'package:flutter_projects/common_widgets/buttons/rounded_action_button.dart';
import 'package:flutter_projects/common_widgets/form_widgets/login_text_field.dart';
import 'package:flutter_projects/common_widgets/notifiable/item_notifiable.dart';
import 'package:flutter_projects/common_widgets/screen_presenter/screen_presenter.dart';
import 'package:flutter_projects/ui/companyLogin/contracts/company_login_view.dart';
import 'package:flutter_projects/ui/companyLogin/presenters/company_login_presenter.dart';
import 'package:flutter_projects/ui/usersList/views/users_list_screen.dart';

class CompanyLoginScreen extends StatefulWidget {
  const CompanyLoginScreen({Key? key}) : super(key: key);

  @override
  State<CompanyLoginScreen> createState() => _CompanyLoginScreenState();
}

class _CompanyLoginScreenState extends State<CompanyLoginScreen>
    implements CompanyLoginView {
  late CompanyLoginPresenter presenter;
  final _keyErrorNotifier = ItemNotifier<String>();
  final _showLogoNotifier = ItemNotifier<bool>();
  final _showLoaderNotifier = ItemNotifier<bool>();
  final _keyTextController = TextEditingController();

  @override
  void initState() {
    presenter = CompanyLoginPresenter(this);
    KeyboardVisibilityController()
        .onChange
        .listen((visibility) => _showLogoNotifier.notify(!visibility));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              //top
              Container(
                height: 300,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/top1.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/top2.png'),
                                  fit: BoxFit.fill))),
                    ),
                    userIcon(),
                    Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/ic_altagem_logo.png'))),
                            ),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            margin: const EdgeInsets.only(top: 200, left: 40),
                            child: const Text(
                              "Altaface",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    loginIcon(),
                    const SizedBox(height: 40),
                    formUI(),
                    const SizedBox(height: 16),
                    _loginButton()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginIcon() {
    return ItemNotifiable<bool>(
      notifier: _showLogoNotifier,
      builder: (context, showLogo) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: (showLogo ?? true) ? 0 : 0),
        curve: Curves.easeInOut,
        width: double.infinity,
        child: Positioned(
          child: Container(
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/ic_altagem_logo.png'))),
            ),
          ),
        ),
      ),
    );
  }

  Widget userIcon() {
    return ItemNotifiable<bool>(
      notifier: _showLogoNotifier,
      builder: (context, showLogo) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Positioned(
          right: 50,
          top: 40,
          width: 80,
          height: 150,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/scan-du-visage-colors.png'))),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ItemNotifiable<String>(
          notifier: _keyErrorNotifier,
          builder: (context, value) => LoginTextField(
            controller: _keyTextController,
            hint: "Company key",
            errorText: value,
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(height: 16)
      ],
    );
  }

  Widget _loginButton() {
    return ItemNotifiable<bool>(
      notifier: _showLoaderNotifier,
      builder: (context, value) => RoundedRectangleActionButton(
        title: 'Login',
        borderColor: AppColors.successColor,
        color: AppColors.successColor,
        onPressed: () => _performLogin(),
        showLoader: value ?? false,
      ),
    );
  }

  void _performLogin() {
    presenter.login(
      _keyTextController.text,
    );
  }

  @override
  void showLoader() {
    _keyErrorNotifier.notify(null);
    _showLoaderNotifier.notify(true);
  }

  @override
  void hideLoader() {
    _showLoaderNotifier.notify(false);
  }

  @override
  void notifyInvalidCompanyKey(String message) {
    _keyErrorNotifier.notify(message);
  }

  @override
  void clearLoginErrors() {
    _keyErrorNotifier.notify(null);
  }

  @override
  void onLoginFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void goToTechniciansListScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(
        UsersListScreen(), context);
  }
}

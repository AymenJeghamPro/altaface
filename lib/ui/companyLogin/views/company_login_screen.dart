import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';
import 'package:flutter_projects/common_widgets/alert/alert.dart';
import 'package:flutter_projects/common_widgets/buttons/rounded_action_button.dart';
import 'package:flutter_projects/common_widgets/form_widgets/login_text_field.dart';
import 'package:flutter_projects/common_widgets/notifiable/item_notifiable.dart';
import 'package:flutter_projects/common_widgets/screen_presenter/screen_presenter.dart';
import 'package:flutter_projects/ui/adminsList/views/admin_list_screen.dart';
import 'package:flutter_projects/ui/companyLogin/contracts/company_login_view.dart';
import 'package:flutter_projects/ui/companyLogin/presenters/company_login_presenter.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icons/background1.png"),
                fit: BoxFit.cover),
          ),
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              userIcon(),
              loginIcon(),
              const SizedBox(height: 40),
              formUI(),
              const SizedBox(height: 16),
              _loginButton()
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
        margin: EdgeInsets.only(top: (showLogo ?? true) ? 40 : 0),
        curve: Curves.easeInOut,
        width: double.infinity,
        child: Center(
          child: SizedBox(
            height: (showLogo ?? true) ? 120 : 0,
            width: 120,
            child: Image.asset('assets/logo/ic_altagem_logo.png'),
          ),
        ),
      ),
    );
  }

  Widget userIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: Image.asset('assets/logo/ic_altagem_logo.png'),
        ),
      ],
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

  // login function
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
        const AdminsListScreen(), context);
  }
}

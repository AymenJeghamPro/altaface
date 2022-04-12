import 'dart:developer';
import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';
import 'package:flutter_projects/af_core/entity/company/company.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';
import 'package:flutter_projects/common_widgets/alert/alert.dart';
import 'package:flutter_projects/common_widgets/appBar/simple_app_bar.dart';
import 'package:flutter_projects/common_widgets/buttons/rounded_action_button.dart';
import 'package:flutter_projects/common_widgets/form_widgets/login_text_field.dart';
import 'package:flutter_projects/common_widgets/loader/loader.dart';
import 'package:flutter_projects/common_widgets/notifiable/item_notifiable.dart';
import 'package:flutter_projects/common_widgets/popUp/popup_alert.dart';
import 'package:flutter_projects/common_widgets/search_bar/search_bar_with_title.dart';
import 'package:flutter_projects/common_widgets/text/text_styles.dart';
import 'package:flutter_projects/common_widgets/toast/toast.dart';
import 'package:flutter_projects/ui/adminsList/contracts/admins_list_view.dart';
import 'package:flutter_projects/ui/adminsList/presenters/admin_list_presenter.dart';
import 'package:flutter_projects/ui/cameraScreens/camera_screen.dart';
import 'package:flutter_projects/ui/companyLogin/views/user_card.dart';
import 'package:flutter_projects/ui/usersList/contracts/users_list_view.dart';
import 'package:flutter_projects/ui/usersList/presenters/users_list_presenter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common_widgets/screen_presenter/screen_presenter.dart';
import '../../main.dart';
import '../../usersList/views/users_list_screen.dart';

const kMainColor = Color(0xFF573851);

class AdminsListScreen extends StatefulWidget {
  const AdminsListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AdminsListScreenState createState() => _AdminsListScreenState();
}

class _AdminsListScreenState extends State<AdminsListScreen>
    implements AdminListView {
  late AdminListPresenter presenter;
  final _searchBarVisibilityNotifier = ItemNotifier<bool>();
  final _showErrorNotifier = ItemNotifier<bool>();
  final _adminsListNotifier = ItemNotifier<List<User>?>();
  final _scrollController = ScrollController();
  final _viewSelectorNotifier = ItemNotifier<int>();
  final _passwordErrorNotifier = ItemNotifier<String>();
  final _showLoaderNotifier = ItemNotifier<bool>();
  final _passwordTextController = TextEditingController();
  final _selectedIndexNotifier = ItemNotifier<int>();

  String _noAdminsMessage = "";
  String _noSearchResultsMessage = "";
  String _errorMessage = "";
  static const ADMINS_VIEW = 1;
  static const NO_ADMINS_VIEW = 2;
  static const NO_SEARCH_RESULTS_VIEW = 3;
  static const ERROR_VIEW = 4;

  int selectedIndex = -1;

  late Loader loader;
  late FToast fToast;

  @override
  void initState() {
    presenter = AdminListPresenter(this);

    presenter.getAdmins();
    loader = Loader(context);
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: const SimpleAppBar(title: 'Admins'),
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
          child: Column(children: [
            Expanded(
              child: Container(
                height: size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/top1.png'),
                      fit: BoxFit.fill),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/top2.png'),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        width: size.width * 1 / 2,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(240, 240, 240, 0.75),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: DefaultTabController(
                          initialIndex: 0,
                          length: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: _getAdminsList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // _buildErrorAndRetryView()
          ]),
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Widget _getAdminsList() {
    return Column(children: [
      _searchBar(),
      ItemNotifiable<int>(
          notifier: _viewSelectorNotifier,
          builder: (context, value) {
            if (value == ADMINS_VIEW) {
              return Expanded(child: _getUsers());
            } else if (value == NO_ADMINS_VIEW) {
              return Expanded(child: _noUsersMessageView());
            } else if (value == NO_SEARCH_RESULTS_VIEW) {
              return Expanded(child: _noSearchResultsMessageView());
            }
            return Expanded(child: _buildErrorAndRetryView());
          })
      // _buildErrorAndRetryView()
    ]);
  }

  Widget _searchBar() {
    return ItemNotifiable<bool>(
      notifier: _searchBarVisibilityNotifier,
      builder: (context, shouldShowSearchBar) {
        if (shouldShowSearchBar == true) {
          return SearchBarWithTitle(
            title: 'Chercher ',
            onChanged: (searchText) => presenter.performSearch(searchText),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _getUsers() {
    return ItemNotifiable<List<User>>(
      notifier: _adminsListNotifier,
      builder: (context, value) => Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: RefreshIndicator(
          onRefresh: () => presenter.refreshAdmins(),
          child: ItemNotifiable<int>(
            notifier: _selectedIndexNotifier,
            builder: (context, selectedIndex) => ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              itemCount: value?.length,
              itemBuilder: (context, index) {
                if (value != null) {
                  return _getUserCard(
                      index, value, selectedIndex == index ? true : false,
                      (int i) {
                    _selectedIndexNotifier.notify(i);
                  });
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getUserCard(int index, List<User> usersList, bool selected,
      Function(int index) pressed) {
    return UserCard(
      user: usersList[index],
      company: CurrentCompanyProvider().getCurrentCompany() as Company,
      onPressed: () => {
        presenter.selectAdminAtIndex(index),
        pressed(index),
      },
      selected: selected,
    );
  }

  Widget _noUsersMessageView() {
    return GestureDetector(
        onTap: () => presenter.getAdmins(),
        child: Center(
            child: Text(
          _noAdminsMessage,
          textAlign: TextAlign.center,
          style: TextStyles.failureMessageTextStyle,
        )));
  }

  Widget _noSearchResultsMessageView() {
    return Center(
        child: Text(
      _noSearchResultsMessage,
      textAlign: TextAlign.center,
      style: TextStyles.failureMessageTextStyle,
    ));
  }

  Widget _buildErrorAndRetryView() {
    return ItemNotifiable<bool>(
        notifier: _showErrorNotifier,
        builder: (context, value) {
          if (value == true) {
            return SizedBox(
              height: 150,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyles.failureMessageTextStyle,
                      ),
                      onPressed: () => presenter.refresh(),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget adminLoginPopUp(User user, Function onLogin) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Center(
          child: AvatarView(
            radius: 60,
            avatarType: AvatarType.CIRCLE,
            imagePath: user.avatar ??
                "https://cdn-icons-png.flaticon.com/512/146/146031.png",
            placeHolder: const Icon(
              Icons.person,
              size: 50,
            ),
            errorWidget: const Icon(
              Icons.error,
              size: 50,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(child: Text("${user.firstName} ${user.lastName}")),
        const SizedBox(height: 21),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ItemNotifiable<String>(
              notifier: _passwordErrorNotifier,
              builder: (context, value) => LoginTextField(
                controller: _passwordTextController,
                hint: "Password",
                errorText: value,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 16)
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              child: RoundedRectangleActionButton(
                title: 'Cancel',
                borderColor: Colors.grey,
                color: Colors.grey,
                onPressed: () => {_pop(), _passwordTextController.clear()},
                showLoader: false,
              ),
            ),
            SizedBox(
                width: 150,
                child: ItemNotifiable<bool>(
                  notifier: _showLoaderNotifier,
                  builder: (context, value) => RoundedRectangleActionButton(
                    title: 'Login',
                    borderColor: AppColors.successColor,
                    color: AppColors.successColor,
                    onPressed: () =>
                        _performLogin(user, _passwordTextController.text),
                    showLoader: value ?? false,
                  ),
                ))
          ],
        )
      ],
    );
  }

  void _performLogin(User user, String passWord) {
    presenter.adminLogin(user.userName!, passWord);
  }

  void _pop() {
    Navigator.pop(context);
  }

  // overridden methods

  @override
  void showErrorMessage(String message) {
    _errorMessage = message;
    _showErrorNotifier.notify(true);
    _viewSelectorNotifier.notify(ERROR_VIEW);
  }

  @override
  void showLoader() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      loader.showLoadingIndicator("Loading");
    });
  }

  @override
  void hideLoader() {
    loader.hideOpenDialog();
  }

  @override
  void showSearchBar() {
    _searchBarVisibilityNotifier.notify(true);
  }

  @override
  void hideSearchBar() {
    _searchBarVisibilityNotifier.notify(false);
  }

  @override
  void showNoSearchResultsMessage(String message) {
    _noSearchResultsMessage = message;
    _viewSelectorNotifier.notify(NO_SEARCH_RESULTS_VIEW);
  }

  @override
  void showNoUsersMessage(String message) {
    _noAdminsMessage = message;
    _viewSelectorNotifier.notify(NO_ADMINS_VIEW);
  }

  @override
  void clearLoginErrors() {
    _passwordErrorNotifier.notify(null);
  }

  @override
  void notifyInvalidPassword(String message) {
    _passwordErrorNotifier.notify(message);
  }

  @override
  void onLoginFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showLoggingLoader() {
    _passwordErrorNotifier.notify(null);
    _showLoaderNotifier.notify(true);
  }

  @override
  void hideLoggingLoader() {
    _showLoaderNotifier.notify(false);
  }

  @override
  void notifyInvalidLogin(String message) {
    _passwordErrorNotifier.notify(message);
  }

  @override
  void onAdminClicked(User user) {
    popupAlert(context: context, widget: adminLoginPopUp(user, () {}));
  }

  @override
  void showAdminsList(List<User> users) {
    _adminsListNotifier.notify(users);
    _viewSelectorNotifier.notify(ADMINS_VIEW);
  }

  @override
  void showNoAdminsMessage(String message) {
    _noAdminsMessage = message;
    _viewSelectorNotifier.notify(NO_ADMINS_VIEW);
  }

  @override
  void onLoginSuccessful() {
    _pop();
    ScreenPresenter.presentAndRemoveAllPreviousScreens(
        const UsersListScreen(), context);
  }
}

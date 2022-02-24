import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:flutter_projects/ui/companyLogin/views/user_card.dart';
import 'package:flutter_projects/ui/usersList/contracts/users_list_view.dart';
import 'package:flutter_projects/ui/usersList/presenters/user_login_presenter.dart';
import 'package:flutter_projects/ui/usersList/presenters/users_list_presenter.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kMainColor = Color(0xFF573851);

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen>
    implements UsersListView {
  late UsersListPresenter presenter;
  late UserLoginPresenter loginPresenter;
  final _searchBarVisibilityNotifier = ItemNotifier<bool>();
  final _showErrorNotifier = ItemNotifier<bool>();
  final _usersListNotifier = ItemNotifier<List<User>?>();
  final _scrollController = ScrollController();
  final _viewSelectorNotifier = ItemNotifier<int>();
  final _passwordErrorNotifier = ItemNotifier<String>();
  final _showLoaderNotifier = ItemNotifier<bool>();
  final _passwordTextController = TextEditingController();

  String _noUsersMessage = "";
  String _noSearchResultsMessage = "";
  String _errorMessage = "";
  static const USERS_VIEW = 1;
  static const NO_USERS_VIEW = 2;
  static const NO_SEARCH_RESULTS_VIEW = 3;
  static const ERROR_VIEW = 4;
  late Loader loader;
  late FToast fToast;

  @override
  void initState() {
    presenter = UsersListPresenter(this);
    loginPresenter = UserLoginPresenter(this);
    presenter.getUsers();
    loader = Loader(context);
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(title: 'Acceuil'),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              // flexible
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                // width: MediaQuery.of(context).size.width * 1 / 3,
                decoration: BoxDecoration(
                  color: AppColors.primaryContrastColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 56,
                        child: TabBar(
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 5.0),
                          ),
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                'journées non commencés',
                                style: TextStyle(color: kMainColor),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'journées commencés',
                                style: TextStyle(color: kMainColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            _getTechniciansList(),
                            _getTechniciansList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // TODO implements camera and place holder
            // Expanded(
            //   child: Container(
            //     margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
            //     // width: MediaQuery.of(context).size.width * 2 / 3,
            //     color: Colors.amber,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _getTechniciansList() {
    return Center(
      child: Column(children: [
        _searchBar(),
        ItemNotifiable<int>(
            notifier: _viewSelectorNotifier,
            builder: (context, value) {
              if (value == USERS_VIEW) {
                return Expanded(child: _getUsers());
              } else if (value == NO_USERS_VIEW) {
                return Expanded(child: _noUsersMessageView());
              } else if (value == NO_SEARCH_RESULTS_VIEW) {
                return Expanded(child: _noSearchResultsMessageView());
              }
              return Expanded(child: _buildErrorAndRetryView());
            })
        // _buildErrorAndRetryView()
      ]),
    );
  }

  // users_list_screen widgets
  Widget _searchBar() {
    return ItemNotifiable<bool>(
      notifier: _searchBarVisibilityNotifier,
      builder: (context, shouldShowSearchBar) {
        if (shouldShowSearchBar == true) {
          return SearchBarWithTitle(
            title: 'Technicians',
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
      notifier: _usersListNotifier,
      builder: (context, value) => Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: RefreshIndicator(
          onRefresh: () => presenter.refreshUsers(),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            itemCount: value?.length,
            itemBuilder: (context, index) {
              if (value != null) {
                return _getUserCard(index, value);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _getUserCard(int index, List<User> usersList) {
    return UserCard(
      user: usersList[index],
      company: CurrentCompanyProvider().getCurrentCompany() as Company,
      onPressed: () => {presenter.selectUserAtIndex(index)},
    );
  }

  Widget _noUsersMessageView() {
    return GestureDetector(
        onTap: () => presenter.getUsers(),
        child: Center(
            child: Text(
          _noUsersMessage,
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

  Widget technicianLoginPopUp(User user, Function onLogin) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Center(
          child: AvatarView(
            radius: 60,
            avatarType: AvatarType.CIRCLE,
            imagePath: user.avatar!,
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
                    onPressed: () => _performLogin(
                        user.userName.toString(), _passwordTextController.text),
                    showLoader: value ?? false,
                  ),
                ))
          ],
        )
      ],
    );
  }

  void _performLogin(String login, String password) {
    loginPresenter.login(login, password);
  }

  void _pop() {
    Navigator.pop(context);
  }

  // overridden methods
  @override
  void showUsersList(List<User> users) {
    _usersListNotifier.notify(users);
    _viewSelectorNotifier.notify(USERS_VIEW);
  }

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
    _noUsersMessage = message;
    _viewSelectorNotifier.notify(NO_USERS_VIEW);
  }

  @override
  void onUserClicked(User user) {
    popupAlert(context: context, widget: technicianLoginPopUp(user, () {}));
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
  void onCameraFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onLoginSuccessful(User user) {
    loginPresenter.getImageCamera(user);
    _pop();
  }

  @override
  void onCameraSuccessful(File imageFile, User user) {
    loginPresenter.uploadImage(imageFile, user);
  }

  @override
  void onUploadImageSuccessful() {
    // TODO: implement onUploadImageSuccessful
  }

  @override
  void onUploadImageFailed(String title, String message) {
    // TODO: implement onUploadImageFailed
  }
}

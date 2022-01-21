import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/common_widgets/appBar/simple_app_bar.dart';
import 'package:flutter_projects/common_widgets/buttons/rounded_action_button.dart';
import 'package:flutter_projects/common_widgets/form_widgets/login_text_field.dart';
import 'package:flutter_projects/common_widgets/loader/loader.dart';
import 'package:flutter_projects/common_widgets/notifiable/item_notifiable.dart';
import 'package:flutter_projects/common_widgets/popUp/popup_alert.dart';
import 'package:flutter_projects/common_widgets/search_bar/search_bar_with_title.dart';
import 'package:flutter_projects/common_widgets/text/text_styles.dart';
import 'package:flutter_projects/ui/companyLogin/views/user_card.dart';
import 'package:flutter_projects/ui/usersList/contracts/uses_list_view.dart';
import 'package:flutter_projects/ui/usersList/presenters/users_list_presenter.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen>
    implements UsersListView {
  late UsersListPresenter presenter;

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

  @override
  void initState() {
    presenter = UsersListPresenter(this);
    presenter.getUsers();
    loader = Loader(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(title: 'Acceuil'),
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
          child: ListView(children: [
            Container(
              height: size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/top1.png'),
                      fit: BoxFit.fitHeight)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/top2.png'),
                                fit: BoxFit.fitHeight))),
                  ),
                  Positioned(
                    width: size.width,
                    height: size.height,
                    child: Column(
                      children: [
                        _searchBar(),
                        ItemNotifiable<int>(
                            notifier: _viewSelectorNotifier,
                            builder: (context, value) {
                              if (value == USERS_VIEW) {
                                return Expanded(child: _getUsers());
                              } else if (value == NO_USERS_VIEW) {
                                return Expanded(child: _noUsersMessageView());
                              } else if (value == NO_SEARCH_RESULTS_VIEW) {
                                return Expanded(
                                    child: _noSearchResultsMessageView());
                              }
                              return Expanded(child: _buildErrorAndRetryView());
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // _buildErrorAndRetryView()
          ]),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return ItemNotifiable<bool>(
      notifier: _searchBarVisibilityNotifier,
      builder: (context, shouldShowSearchBar) {
        if (shouldShowSearchBar == true) {
          return SearchBarWithTitle(
            title: 'Chercher un technicien',
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
          onRefresh: () => presenter.getUsers(),
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

  Widget technicianLoginPopUp(User user, Function onLogin) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 21),
        ClipOval(
          child: Center(
              child: SizedBox.fromSize(
            size: const Size.fromRadius(48), // Image radius
            child: Image.network(user.avatar!, fit: BoxFit.cover),
          )),
        ),
        const SizedBox(height: 21),
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
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 16)
          ],
        ),
        const SizedBox(height: 21),
        ItemNotifiable<bool>(
          notifier: _showLoaderNotifier,
          builder: (context, value) => RoundedRectangleActionButton(
            title: 'Login',
            borderColor: AppColors.successColor,
            color: AppColors.successColor,
            onPressed: () => {},
            showLoader: value ?? false,
          ),
        )
      ],
    );
  }
}

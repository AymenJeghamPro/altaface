import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:altaface/af_core/entity/company/company.dart';
import 'package:altaface/af_core/entity/user/user.dart';
import 'package:altaface/af_core/service/company/current_company_provider.dart';
import 'package:altaface/common_widgets/alert/alert.dart';
import 'package:altaface/common_widgets/appBar/simple_app_bar.dart';
import 'package:altaface/common_widgets/buttons/rounded_action_button.dart';
import 'package:altaface/common_widgets/count_down_timer/count_down_timer.dart';
import 'package:altaface/common_widgets/loader/loader.dart';
import 'package:altaface/common_widgets/notifiable/item_notifiable.dart';
import 'package:altaface/common_widgets/search_bar/search_bar_with_title.dart';
import 'package:altaface/common_widgets/text/text_styles.dart';
import 'package:altaface/common_widgets/toast/toast.dart';
import 'package:altaface/ui/companyLogin/views/user_card.dart';
import 'package:altaface/ui/usersList/contracts/users_list_view.dart';
import 'package:altaface/ui/usersList/presenters/users_list_presenter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../main.dart';

const kMainColor = Color(0xFF573851);

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver
    implements UsersListView {
  late UsersListPresenter presenter;
  final _searchBarVisibilityNotifier = ItemNotifier<bool>();
  final _showErrorNotifier = ItemNotifier<bool>();
  final _usersListNotifier = ItemNotifier<List<User>?>();
  final _scrollController = ScrollController();
  final _viewSelectorNotifier = ItemNotifier<int>();
  // final _passwordErrorNotifier = ItemNotifier<String>();
  // final _showLoaderNotifier = ItemNotifier<bool>();
  // final _passwordTextController = TextEditingController();
  final _imageFileNotifier = ItemNotifier<File?>();
  final _selectedIndexNotifier = ItemNotifier<int>();
  final _captureButtonNotifier = ItemNotifier<bool>();
  final _isCameraInitializedNotifier = ItemNotifier<bool>();
  final _isCameraPermissionGrantedNotifier = ItemNotifier<bool>();
  final _isRearCameraSelectedNotifier = ItemNotifier<bool>();
  final _currentResolutionPresetNotifier = ItemNotifier<ResolutionPreset>();

  late TabController _tabController;

  String _noUsersMessage = "";
  String _noSearchResultsMessage = "";
  String _errorMessage = "";
  static const usersView = 1;
  static const noUsersView = 2;
  static const noSearchResultsView = 3;
  static const errorView = 4;

  int selectedIndex = -1;

  // int? _activeTabIndex;

  late Loader loader;
  late FToast fToast;
  late XFile? pickedImage;
  final picker = ImagePicker();

  // final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isCountingDown = ValueNotifier<bool>(false);
  final ValueNotifier<int> _activeTabIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isTabSwitched = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isRetakingPicture = ValueNotifier<bool>(false);

  //Camera variables
  CameraController? controller;
  late AnimationController _flashModeControlRowAnimationController;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  //bool _isRearCameraSelected = true;
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      _isCameraPermissionGrantedNotifier.notify(true);
      // Set and initialize the new camera
      onNewCameraSelected(cameras[1]);
    } else {
      log('Camera Permission: DENIED');
    }
  }

  void _setActiveTabIndex() {
    _activeTabIndex.value = _tabController.index;
  }

  @override
  void initState() {
    presenter = UsersListPresenter(this);
    presenter.initializeRepos();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_setActiveTabIndex);

    presenter.getUsers(_tabController.index);
    loader = Loader(context);
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _isCameraInitializedNotifier.notify(false);
    _isCameraPermissionGrantedNotifier.notify(false);
    _isRearCameraSelectedNotifier.notify(true);
    _currentResolutionPresetNotifier.notify(ResolutionPreset.high);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    getPermissionStatus();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    _tabController.addListener(() {
      _activeTabIndex.value = _tabController.index;
      presenter.getUsers(_tabController.index);
      selectedIndex = -1;
      _selectedIndexNotifier.notify(-1);
      _captureButtonNotifier.notify(false);
      setIsTabSwitchedToTrue();
      setIsRetakingPictureFalse();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: const SimpleAppBar(title: 'Acceuil'),
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
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          width: size.width * 1 / 3,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(240, 240, 240, 0.75),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DefaultTabController(
                            initialIndex: 0,
                            length: 2,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 56,
                                  child: TabBar(
                                    controller: _tabController,
                                    indicator: const UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          width: 5.0),
                                    ),
                                    tabs: const <Widget>[
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
                                  child: _getTechniciansList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: _isTabSwitched,
                            builder: (BuildContext context,
                                    bool _isTabSwitchedValue, Widget? child) =>
                                ItemNotifiable<File?>(
                              notifier: _imageFileNotifier,
                              builder: (context, imageFile) => Column(
                                children: [
                                  imageFile != null &&
                                          _isTabSwitchedValue == false
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, right: 16),
                                            child: TextButton.icon(
                                              icon: const Icon(
                                                Icons.restart_alt,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                              label: const Text(
                                                'Prendre une autre photo',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              onPressed: () {
                                                setIsTabSwitchedToTrue();
                                                _captureButtonNotifier
                                                    .notify(false);
                                                setIsRetakingPictureTrue();
                                                Future.delayed(
                                                    const Duration(
                                                        microseconds: 1), () {
                                                  imageFile = null;
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    child: Container(
                                      height: size.height * 0.80,
                                      margin: const EdgeInsets.only(
                                          right: 12, top: 12, bottom: 12),
                                      child: imageFile != null &&
                                              _isTabSwitchedValue == false
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.file(
                                                imageFile!,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )
                                          : ValueListenableBuilder<bool>(
                                              valueListenable: _isCountingDown,
                                              builder: (BuildContext context,
                                                      bool _isCountingDownValue,
                                                      Widget? child) =>
                                                  _camera(),
                                            ),
                                    ),
                                  ),
                                  imageFile != null &&
                                          _isTabSwitchedValue == false
                                      ? ValueListenableBuilder<int>(
                                          valueListenable: _activeTabIndex,
                                          builder: (BuildContext context,
                                              int _activeTabIndex,
                                              Widget? child) {
                                            return Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Container(
                                                      child: _activeTabIndex ==
                                                              0
                                                          ? SizedBox(
                                                              width: 300,
                                                              child:
                                                                  RoundedRectangleActionButton(
                                                                title:
                                                                    "Commencer journée",
                                                                borderColor:
                                                                    Colors
                                                                        .green,
                                                                color: Colors
                                                                    .green[600],
                                                                onPressed: () =>
                                                                    {
                                                                  presenter
                                                                      .startFinishWorkday(
                                                                          imageFile!,
                                                                          true)
                                                                },
                                                                showLoader:
                                                                    false,
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              width: 300,
                                                              child:
                                                                  RoundedRectangleActionButton(
                                                                title:
                                                                    "Cloturer journée",
                                                                borderColor:
                                                                    Colors.red,
                                                                color: Colors
                                                                    .red[600],
                                                                onPressed: () =>
                                                                    {
                                                                  presenter
                                                                      .startFinishWorkday(
                                                                          imageFile!,
                                                                          false)
                                                                },
                                                                showLoader:
                                                                    false,
                                                              ),
                                                            )),
                                                ));
                                          })
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  setIsCountingDownToFalse() {
    _isCountingDown.value = false;
  }

  setIsCountingToTrue() {
    _isCountingDown.value = true;
  }

  setIsRetakingPictureTrue() {
    _isRetakingPicture.value = true;
  }

  setIsRetakingPictureFalse() {
    _isRetakingPicture.value = false;
  }

  setIsTabSwitchedToTrue() {
    _isTabSwitched.value = true;
  }

  Widget _camera() {
    Size size = MediaQuery.of(context).size;
    return ItemNotifiable<bool>(
      notifier: _isCameraPermissionGrantedNotifier,
      builder: (context, permissionGranted) => permissionGranted == true
          ? ItemNotifiable<bool>(
              notifier: _isCameraInitializedNotifier,
              builder: (context, _isInitialized) => _isInitialized == true
                  ? Stack(
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: _cameraPreviewWidget(),
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                          ),
                        ),
                        // capture circle widget
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: _captureCircleWidget()),
                        ),
                        // falsh control button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: IconButton(
                              icon: const Icon(Icons.flash_on),
                              color: Colors.white,
                              iconSize: 40,
                              onPressed: controller != null
                                  ? onFlashModeButtonPressed
                                  : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ItemNotifiable<bool>(
                              notifier: _isRearCameraSelectedNotifier,
                              builder: (context, _rearCameraSelected) =>
                                  InkWell(
                                onTap: () {
                                  _isCameraInitializedNotifier.notify(false);
                                  onNewCameraSelected(
                                    cameras[
                                        _rearCameraSelected == true ? 0 : 1],
                                  );
                                  _isRearCameraSelectedNotifier
                                      .notify(!_rearCameraSelected!);
                                },
                                child: Icon(
                                  _rearCameraSelected!
                                      ? Icons.camera_front
                                      : Icons.camera_rear,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // camera quality settings
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: ItemNotifiable<ResolutionPreset>(
                                  notifier: _currentResolutionPresetNotifier,
                                  builder: (context, resolutionPreset) =>
                                      DropdownButton<ResolutionPreset>(
                                    dropdownColor: Colors.black87,
                                    underline: Container(),
                                    value: resolutionPreset,
                                    items: [
                                      for (ResolutionPreset preset
                                          in resolutionPresets)
                                        DropdownMenuItem(
                                          child: Text(
                                            preset
                                                .toString()
                                                .split('.')[1]
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          value: preset,
                                        )
                                    ],
                                    onChanged: (value) {
                                      _currentResolutionPresetNotifier
                                          .notify(value);
                                      currentResolutionPreset = value!;
                                      _isCameraInitializedNotifier
                                          .notify(false);
                                      onNewCameraSelected(
                                          controller!.description);
                                    },
                                    hint: const Text("Select item"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        ValueListenableBuilder<bool>(
                          valueListenable: _isCountingDown,
                          builder: (BuildContext context,
                              bool _isCountingDownValue, Widget? child) {
                            return _isCountingDownValue == true
                                ? Center(
                                    child: SizedBox(
                                      width: size.width,
                                      height: size.height / 2,
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: CountDownTimer(),
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: SizedBox(
                                      width: 1,
                                      height: 1,
                                    ),
                                  );
                          },
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        'Chargement',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(),
                const Text(
                  'Permission refusée',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Appuyez sur une caméra',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  Widget _captureCircleWidget() {
    final CameraController? cameraController = controller;
    return ItemNotifiable<bool>(
      notifier: _captureButtonNotifier,
      builder: (context, show) =>
          show == true || _isRetakingPicture.value == true
              ? GestureDetector(
                  onTap: cameraController != null &&
                          cameraController.value.isInitialized
                      ? onTakePictureButtonPressed
                      : null,
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Icon(
                        Icons.circle,
                        color: Colors.white38,
                        size: 80,
                      ),
                      Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 65,
                      ),
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Merci de sélectionner votre nom",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    if (mounted) {
      controller = cameraController;
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) {}
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }
    }

    if (mounted) {
      _isCameraInitializedNotifier.notify(controller!.value.isInitialized);
    }
  }

  void onTakePictureButtonPressed() {
    _imageFileNotifier.notify(null);
    setIsCountingToTrue();
    _isTabSwitched.value = false;
    Future.delayed(
      const Duration(seconds: 3),
      () {
        takePicture().then(
          (XFile? file) {
            if (mounted) {
              if (file != null) {
                _imageFileNotifier.notify(File(file.path));
              }
            }
          },
        );
      },
    );
    Future.delayed(const Duration(seconds: 3), setIsCountingDownToFalse);
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
  }

  Widget _getTechniciansList() {
    return Column(children: [
      _searchBar(),
      ItemNotifiable<int>(
          notifier: _viewSelectorNotifier,
          builder: (context, value) {
            if (value == usersView) {
              return Expanded(child: _getUsers());
            } else if (value == noUsersView) {
              return Expanded(child: _noUsersMessageView());
            } else if (value == noSearchResultsView) {
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
      notifier: _usersListNotifier,
      builder: (context, value) => Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: RefreshIndicator(
          onRefresh: () => presenter.refreshUsers(_tabController.index),
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
                    _captureButtonNotifier.notify(true);
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
        presenter.selectUserAtIndex(index),
        pressed(index),
        _imageFileNotifier.notify(null)
      },
      selected: selected,
    );
  }

  Widget _noUsersMessageView() {
    return GestureDetector(
        onTap: () => presenter.getUsers(_tabController.index),
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
                      onPressed: () => presenter.refresh(_tabController.index),
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

  void logError(String code, String? message) {
    if (message != null) {
      if (kDebugMode) {
        print('Error: $code\nError Message: $message');
      }
    } else {
      if (kDebugMode) {
        print('Error: $code');
      }
    }
  }

  void onWorkDayStartedSuccessful(String toastMessage) {
    fToast.showToast(
      child: ToastClass(toastMessage),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  // overridden methods
  @override
  void showUsersList(List<User> users) {
    _usersListNotifier.notify(users);
    _viewSelectorNotifier.notify(usersView);
  }

  @override
  void showErrorMessage(String message) {
    _errorMessage = message;
    _showErrorNotifier.notify(true);
    _viewSelectorNotifier.notify(errorView);
  }

  @override
  void showLoader() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      loader.showLoadingIndicator("Patienter svp");
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
    _viewSelectorNotifier.notify(noSearchResultsView);
  }

  @override
  void showNoUsersMessage(String message) {
    _noUsersMessage = message;
    _viewSelectorNotifier.notify(noUsersView);
  }

  @override
  void onCameraFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onStartFinishSuccessful(bool start) {
    presenter.refreshUsers(_tabController.index);
    _imageFileNotifier.notify(null);
    _selectedIndexNotifier.notify(-1);
    _captureButtonNotifier.notify(false);
    onWorkDayStartedSuccessful(start == true
        ? "La journée de travail a démarré avec succès"
        : "Journée de travail terminée avec succès");
  }

  @override
  void onUploadImageFailed(String title, String message) {
    _imageFileNotifier.notify(null);
    _selectedIndexNotifier.notify(-1);
    _captureButtonNotifier.notify(false);
    onWorkDayStartedSuccessful("Workday failed to start");
  }
}

T? _ambiguate<T>(T? value) => value;

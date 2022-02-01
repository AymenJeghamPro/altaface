import 'dart:io';

import 'package:flutter_projects/_shared/exceptions/af_exception.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/service/document/document_provider.dart';
import 'package:flutter_projects/af_core/service/user/user_login_provider.dart';
import 'package:flutter_projects/ui/usersList/contracts/users_list_view.dart';
import 'package:image_picker/image_picker.dart';

class UserLoginPresenter {
  final UsersListView _view;
  final UserLoginProvider _userLoginProvider;
  final DocumentProvider _documentProvider;

  late String photo;
  late File _imageFile;
  final picker = ImagePicker();

  UserLoginPresenter(this._view)
      : _userLoginProvider = UserLoginProvider(),
        _documentProvider = DocumentProvider();

  UserLoginPresenter.initWith(
    this._view,
    this._userLoginProvider,
    this._documentProvider,
  );


  Future<void> login(String login, String password) async {
    _view.clearLoginErrors();
    if (!_isInputValid(password)) return;
    if (_userLoginProvider.isLoading) return;

    try {
      _view.showLoggingLoader();
      var user = await _userLoginProvider.login(login, password);
      _view.hideLoggingLoader();
      _view.onLoginSuccessful(user);
    } on AFException catch (e) {
      _view.hideLoggingLoader();
      _view.onLoginFailed("Login Failed", e.userReadableMessage);
    }
  }

  Future<void> getImageCamera(User user) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      _view.onCameraSuccessful(_imageFile, user);
    } else {
      _view.onCameraFailed("Error", "No file selected");
    }
  }

  Future<void> uploadImage(File imageFile, User user) async {
    try {
      _view.showLoader();
      await _documentProvider.uploadFile(imageFile.path, user);
      _view.hideLoader();
      _view.onUploadImageSuccessful();
    } on AFException catch (e) {
      _view.hideLoader();
      _view.onUploadImageFailed("Image upload Failed", e.userReadableMessage);
    }
  }

  bool _isInputValid(String password) {
    var isValid = true;

    if (password.isEmpty || password.length < 4) {
      isValid = false;
      _view.notifyInvalidPassword("password must have at least 4 characters");
    }

    return isValid;
  }
}

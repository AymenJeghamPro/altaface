import 'package:altaface/_shared/exceptions/invalid_response_exception.dart';
import 'package:altaface/af_core/af_api/entities/api_request.dart';
import 'package:altaface/af_core/af_api/entities/api_response.dart';
import 'package:altaface/af_core/af_api/exceptions/api_exception.dart';
import 'package:altaface/af_core/af_api/exceptions/http_exception.dart';
import 'package:altaface/af_core/af_api/exceptions/server_sent_exception.dart';
import 'package:altaface/af_core/af_api/services/af_api.dart';
import 'package:altaface/af_core/af_api/services/network_adapter.dart';
import 'package:altaface/af_core/service/company/current_company_provider.dart';
import 'package:altaface/af_core/constants/users_urls.dart';
import 'package:altaface/af_core/entity/user/user.dart';
import 'package:altaface/af_core/repository/user/user_repository.dart';
import 'package:altaface/af_core/repository/user/user_response_processor.dart';
import 'package:sift/sift.dart';

class UsersListProvider {
  final CurrentCompanyProvider _currentCompanyProvider;
  final UsersRepository _usersRepository;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;

  UsersListProvider.initWith(this._currentCompanyProvider,
      this._usersRepository, this._networkAdapter);

  UsersListProvider()
      : _currentCompanyProvider = CurrentCompanyProvider(),
        _usersRepository = UsersRepository.getInstance(),
        _networkAdapter = AltaFaceAPI();

  void reset() {
    isLoading = false;
  }

  Future<List<User>> getUsers({bool isAdmin = false}) async {
    var currentCompany = _currentCompanyProvider.getCurrentCompany();
    var url = UsersManagementUrls.getUsersUrl();

    switch (isAdmin) {
      case true:
        {
          url = UsersManagementUrls.getAdminsUrl();
          break;
        }
      case false:
        {
          url = UsersManagementUrls.getUsersUrl();
          break;
        }
    }

    Map<String, String> qParams = {'company_id': currentCompany!.id};
    Uri uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: qParams);
    var apiRequest = APIRequest(finalUri.toString());
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      var responseData = UserResponseProcessor().processResponse(apiResponse);
      var response =
          APIResponse(apiRequest, apiResponse.statusCode, responseData, {});
      isLoading = false;
      return _processResponse(response, isAdmin);
    } on APIException catch (exception) {
      isLoading = false;
      if (exception is HTTPException && exception.httpCode == 401) {
        throw ServerSentException('Invalid username or password', 401);
      } else {
        rethrow;
      }
    }
  }

  List<User> _processResponse(APIResponse apiResponse, bool isAdmin) {
    if (apiResponse.data == null) throw InvalidResponseException();

    var responseMapList = apiResponse.data;

    return isAdmin
        ? _readAdminItemsFromResponse(responseMapList)
        : _readItemsFromResponse(responseMapList);
  }

  List<User> _readItemsFromResponse(Map<String, dynamic> responseMapList) {
    try {
      var users = <User>[];
      var sift = Sift();
      var dataMap = sift.readMapFromMap(responseMapList, "data");
      var usersResponse = sift.readMapListFromMap(dataMap, "users");
      for (var responseMap in usersResponse) {
        var user = User.fromJson(responseMap);
        users.add(user);
      }
      return users;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  List<User> _readAdminItemsFromResponse(List responseList) {
    try {
      var users = <User>[];
      for (var responseMap in responseList) {
        var user = User.fromJson(responseMap);
        users.add(user);
      }
      return users;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}

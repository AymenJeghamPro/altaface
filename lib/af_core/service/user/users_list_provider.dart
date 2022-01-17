import 'package:flutter_projects/_shared/exceptions/invalid_response_exception.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/http_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/server_sent_exception.dart';
import 'package:flutter_projects/af_core/af_api/services/af_api.dart';
import 'package:flutter_projects/af_core/af_api/services/network_adapter.dart';
import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';
import 'package:flutter_projects/af_core/constants/users_urls.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/repository/user/user_repository.dart';
import 'package:flutter_projects/af_core/repository/user/user_response_processor.dart';

class UsersListProvider {
  final CurrentCompanyProvider _currentCompanyProvider;
  final UsersRepository _usersRepository;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;

  UsersListProvider.initWith(this._currentCompanyProvider,
      this._usersRepository, this._networkAdapter);

  UsersListProvider()
      : _currentCompanyProvider = CurrentCompanyProvider(),
        _usersRepository = UsersRepository(),
        _networkAdapter = AFAPI();

  void reset() {
    isLoading = false;
  }

  Future<List<User>> getUsers() async {
     var currentCompany = _currentCompanyProvider.getCurrentCompany();
    var url = UsersManagementUrls.getUsersUrl();

    Map<String, String> qParams = {'company_id': currentCompany!.id!};
    Uri uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: qParams);
    var apiRequest = APIRequest(finalUri.toString());
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      var responseData = UserResponseProcessor().processResponse(apiResponse);
      var response =  APIResponse(apiRequest, apiResponse.statusCode, responseData, {});
      isLoading = false;
      return _processResponse(response);
    } on APIException catch (exception) {
      isLoading = false;
      if (exception is HTTPException && exception.httpCode == 401) {
        throw ServerSentException('Invalid username or password', 401);
      } else {
        rethrow;
      }
    }
  }

  List<User> _processResponse(APIResponse apiResponse) {
    if (apiResponse.data == null) throw InvalidResponseException();

    var responseMapList = apiResponse.data;

    return _readItemsFromResponse(responseMapList);
  }

  List<User> _readItemsFromResponse(
      List<dynamic> responseMapList) {
    try {
      var users = <User>[];
      for (var responseMap in responseMapList) {
        var user = User.fromJson(responseMap);
        users.add(user);
      }
      return users;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}

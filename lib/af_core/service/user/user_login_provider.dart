import 'package:flutter_projects/_shared/exceptions/invalid_response_exception.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/http_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/server_sent_exception.dart';
import 'package:flutter_projects/af_core/af_api/services/af_api.dart';
import 'package:flutter_projects/af_core/af_api/services/network_adapter.dart';
import 'package:flutter_projects/af_core/constants/users_urls.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/repository/user/user_repository.dart';
import 'package:flutter_projects/af_core/repository/user/user_response_processor.dart';
import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';

import '../../repository/company/company_response_processor.dart';

class UserLoginProvider {
  final CurrentCompanyProvider _currentCompanyProvider;
  final UsersRepository _usersRepository;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;

  UserLoginProvider.initWith(this._currentCompanyProvider,
      this._usersRepository, this._networkAdapter);

  UserLoginProvider()
      : _currentCompanyProvider = CurrentCompanyProvider(),
        _usersRepository = UsersRepository(),
        _networkAdapter = AltaFaceAPI();

  void reset() {
    isLoading = false;
  }

  bool isLoggedIn() {
    return UsersRepository().getCurrentUser() != null;
  }

  User? getCurrentUser() {
    return _usersRepository.getCurrentUser();
  }

  Future<User> login(String login, String password) async {
    var url = UsersManagementUrls.postUsersUrl();
    var companyId = _currentCompanyProvider.getCurrentCompany();

    Map<String, dynamic> qParams = {
      'user': {
        'login': login,
        'password': password,
        'company_id': companyId!.id.toString()
      },
      'connection': {
        'imei': '',
        'mac_address': '8A:72:BF:CC:3C:2B',
        'ip_address': '192.168.1.31',
        'network_provider': '',
        'phone_number': '',
        'battery_level': '31.0'
      }
    };

    Uri uri = Uri.parse(url);
    var apiRequest = APIRequest(uri.toString());
    isLoading = true;
    apiRequest.addParameters(qParams);
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      var responseData = UserResponseProcessor().processResponse(apiResponse);
      var response =
          APIResponse(apiRequest, apiResponse.statusCode, responseData, {});
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

  User _processResponse(APIResponse apiResponse) {
    if (apiResponse.data == null) throw InvalidResponseException();

    var responseMapList = apiResponse.data;

    return _readItemsFromResponse(responseMapList);
  }

  User _readItemsFromResponse(Map<String, dynamic> responseMap) {
    try {
      var user = User.fromJson(responseMap);

      //_usersRepository.saveUser(user);

      return user;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}

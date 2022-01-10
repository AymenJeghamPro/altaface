import 'package:flutter_projects/_shared/exceptions/invalid_response_exception.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/http_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/server_sent_exception.dart';
import 'package:flutter_projects/af_core/af_api/services/af_api.dart';
import 'package:flutter_projects/af_core/af_api/services/network_adapter.dart';
import 'package:flutter_projects/af_core/company_management/services/current_company_provider.dart';
import 'package:flutter_projects/af_core/users_management/constants/users_management_urls.dart';
import 'package:flutter_projects/af_core/users_management/entities/users.dart';
import 'package:flutter_projects/af_core/users_management/repository/users_repository.dart';

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

  Future<List<User>> getUsers(String companyId) async {
    var url = UsersManagementUrls.getUsersUrl();

    Map<String, String> qParams = {'company_id': companyId};
    Uri uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: qParams);
    var apiRequest = APIRequest(finalUri.toString());
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
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

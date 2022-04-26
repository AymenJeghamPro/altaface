import 'dart:convert';
import 'dart:io';

import 'package:altaface/af_core/af_api/entities/api_request.dart';
import 'package:altaface/af_core/af_api/entities/api_response.dart';
import 'package:altaface/af_core/af_api/exceptions/api_exception.dart';
import 'package:altaface/af_core/af_api/exceptions/http_exception.dart';
import 'package:altaface/af_core/af_api/exceptions/server_sent_exception.dart';
import 'package:altaface/af_core/af_api/services/af_api.dart';
import 'package:altaface/af_core/af_api/services/network_adapter.dart';
import 'package:altaface/af_core/constants/users_urls.dart';
import 'package:altaface/af_core/entity/user/user.dart';
import 'package:altaface/af_core/repository/user/user_repository.dart';
import 'package:altaface/af_core/service/company/current_company_provider.dart';
import '../../../_shared/exceptions/invalid_response_exception.dart';
import '../../repository/user/user_response_processor.dart';

class UserLoginProvider {
  final CurrentCompanyProvider _currentCompanyProvider;
  final UsersRepository _usersRepository;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;

  UserLoginProvider.initWith(this._currentCompanyProvider,
      this._usersRepository, this._networkAdapter);

  UserLoginProvider()
      : _currentCompanyProvider = CurrentCompanyProvider(),
        _usersRepository = UsersRepository.getInstance(),
        _networkAdapter = AltaFaceAPI();

  void reset() {
    isLoading = false;
  }

  bool isLoggedIn() {
    return _usersRepository.getCurrentUser() != null;
  }

  User? getCurrentUser() {
    return _usersRepository.getCurrentUser();
  }

  Future<bool> login(String login, String password) async {
    var url = UsersManagementUrls.loginUrl();

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
        'phone_number': "xxxxxxx",
        'battery_level': "N.A"
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
      APIResponse(apiRequest, apiResponse.statusCode, responseData, {});
      isLoading = false;
      return _processResponse(response, isAdmin: true);
    } on APIException catch (exception) {
      isLoading = false;
      if (exception is HTTPException && exception.httpCode == 401) {
        throw ServerSentException('Invalid username or password', 401);
      } else {
        rethrow;
      }
    }
  }

  bool _processResponse(APIResponse apiResponse, {bool isAdmin = false}) {
    if (apiResponse.data == null) throw InvalidResponseException();

    var responseMapList = apiResponse.data;

    return isAdmin ? _readItemsFromResponse(responseMapList) : true;
  }

  bool _readItemsFromResponse(Map<String, dynamic> responseMap) {
    try {
      var user = User.fromJson(responseMap);

      _usersRepository.saveUser(user);

      return true;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  Future<bool> startFinishWorkDay(
      File imageFile, String workDayID, String technicianId, bool start) async {
    var url = UsersManagementUrls.startWorkday();

    final bytes = File(imageFile.path).readAsBytesSync();
    String base64Image = "data:image/png;base64," + base64Encode(bytes);

    Map<String, dynamic> startWorkDayParams = {
      "synchro": {
        "activities": [
          {
            "activity_type_id": "a121f5c4-d6aa-4ed8-b566-9935c1fd07d0",
            "started_at": DateTime.now().millisecondsSinceEpoch / 1000.toInt(),
            "technician_id": technicianId,
            "work_day_id": workDayID,
            "is_archived": false,
            "id": "1"
          }
        ],
        "work_day_histories": [
          {
            "settled_at": DateTime.now().millisecondsSinceEpoch / 1000.toInt(),
            "state": "notyet_notyet",
            "user_id": technicianId,
            "work_day_id": workDayID,
            "is_archived": false,
            "id": "1"
          }
        ],
        "dokuments": [
          {
            "created_at": DateTime.now().millisecondsSinceEpoch / 1000.toInt(),
            "dokument_order": 1,
            "download_count": 0,
            "file": base64Image,
            "label": "starting-workday",
            "owner_id": technicianId,
            "related_object_id": technicianId,
            "related_object_type": "User",
            "is_archived": false,
            "id": "7"
          }
        ],
      }
    };

    Map<String, dynamic> finishWorkDayParams = {
      "synchro": {
        "activities": [
          {
            "activity_type_id": "a121f5c4-d6aa-4ed8-b566-9935c1fd07d0",
            "started_at": DateTime.now().millisecondsSinceEpoch / 1000.toInt(),
            "finished_at": DateTime.now().millisecondsSinceEpoch / 1000.toInt(),
            "technician_id": technicianId,
            "work_day_id": workDayID,
            "is_archived": false,
            "id": "1"
          }
        ],
        "work_day_histories": [
          {
            "settled_at": DateTime.now().millisecondsSinceEpoch / 1000.toInt(),
            "state": "approved_notyet",
            "user_id": technicianId,
            "work_day_id": workDayID,
            "is_archived": false,
            "id": "2"
          }
        ],
        "dokuments": [
          {
            "created_at": DateTime.now().millisecondsSinceEpoch / 1000.toInt(),
            "dokument_order": 1,
            "download_count": 0,
            "file": base64Image,
            "file_content_type": "image/jpeg",
            "label": "finishing-workday",
            "owner_id": technicianId,
            "related_object_id": technicianId,
            "related_object_type": "User",
            "is_archived": false,
            "id": "7"
          }
        ],
      }
    };

    Uri uri = Uri.parse(url);

    var apiRequest = APIRequest(uri.toString());
    isLoading = true;
    apiRequest.addParameters(
        start == true ? startWorkDayParams : finishWorkDayParams);
    var authToken = getCurrentUser()?.authenticationToken;
    apiRequest.addHeader("Authorization", authToken.toString());
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
}

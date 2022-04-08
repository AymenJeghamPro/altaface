import 'dart:developer';
import 'package:dio/dio.dart';
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
import 'package:flutter_projects/af_core/service/company/current_company_provider.dart';

import '../../repository/connection/connection_response_processor.dart';

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

  Future<bool> startWorkDay(String imageFilePath, String technicianId) async {
    var url = UsersManagementUrls.startWorkday();

    var formData = FormData.fromMap({
      'technician_id': technicianId,
      'file':
          await MultipartFile.fromFile(imageFilePath, filename: 'today-login')
    });

    Uri uri = Uri.parse(url);
    var apiRequest = APIRequest(uri.toString());
    isLoading = true;

    try {
      var apiResponse =
          await _networkAdapter.postMultipart(apiRequest, formData);
      var responseData =
          ConnectionResponseProcessor().processResponse(apiResponse);
      var response = APIResponse(apiRequest, apiResponse.statusCode, responseData, {});
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

  bool _processResponse(APIResponse apiResponse) {
    return true;
  }

// Future<bool> startWorkDay(String workDayID, String technicianId ) async {
//   var url = UsersManagementUrls.startWorkday();
//
//
//   log(workDayID);
//
//   Map<String, dynamic> qParams = {
//       "synchro": {
//         "activities": [
//           {
//             "activity_type_id": "a121f5c4-d6aa-4ed8-b566-9935c1fd07d0",
//             "started_at": DateTime.now().millisecondsSinceEpoch/1000.toInt(),
//             "technician_id": technicianId,
//             "work_day_id": workDayID,
//             "is_archived": false,
//             "id":const Uuid().v1()
//           }
//         ],
//         "declaratives": [
//           {
//            "settled_on": DateTime.now().millisecondsSinceEpoch/1000.toInt(),
//             "declarant_id": technicianId,
//             "trace_id": "f415d37c-1e73-4908-aaaf-61b4f901621x",
//             "id": const Uuid().v1()
//           }
//         ],
//         "work_days": [
//           {
//             "current_activities_count": 1,
//             "settled_on": DateTime.now().millisecondsSinceEpoch/1000.toInt(),
//             "state": "notyet_notyet",
//             "technician_id": technicianId,
//             "is_archived": false,
//             "id":workDayID
//           }
//         ]
//       }
//   };
//
//   Uri uri = Uri.parse(url);
//
//   var apiRequest = APIRequest(uri.toString());
//   isLoading = true;
//   apiRequest.addParameters(qParams);
//   apiRequest.addHeader("Authorization", "qqArehPqM-pjueGPhJwk");
//   try {
//     var apiResponse = await _networkAdapter.post(apiRequest);
//     var responseData = UserResponseProcessor().processResponse(apiResponse);
//     var response =
//     APIResponse(apiRequest, apiResponse.statusCode, responseData, {});
//     isLoading = false;
//     return _processResponse(response);
//   } on APIException catch (exception) {
//     isLoading = false;
//     if (exception is HTTPException && exception.httpCode == 401) {
//       throw ServerSentException('Invalid username or password', 401);
//     } else {
//       rethrow;
//     }
//   }
// }
//
//  bool _processResponse(APIResponse apiResponse) {
//   if (apiResponse.data == null) throw InvalidResponseException();
//
//    return true ;
// }
}

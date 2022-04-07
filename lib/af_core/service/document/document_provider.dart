import 'package:dio/dio.dart';
import 'package:flutter_projects/_shared/exceptions/invalid_response_exception.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/http_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/server_sent_exception.dart';
import 'package:flutter_projects/af_core/af_api/services/af_api.dart';
import 'package:flutter_projects/af_core/af_api/services/network_adapter.dart';
import 'package:flutter_projects/af_core/constants/document_urls.dart';
import 'package:flutter_projects/af_core/entity/document/document.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/af_core/repository/user/user_response_processor.dart';

class DocumentProvider {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  Dio dio = Dio();

  DocumentProvider.initWith(this._networkAdapter);

  DocumentProvider() : _networkAdapter = AltaFaceAPI();

  void reset() {
    isLoading = false;
  }

  Future<Document> uploadFile(String imageFilePath, User user) async {
    var url = DocumentUrls.postFileUrl();

    var formData = FormData.fromMap({
      'owner_id': user.id,
      'related_object_id': user.id,
      'related_object_type': "User",
      'dokument_order': "0",
      'file': await MultipartFile.fromFile(imageFilePath, filename: 'today-login')
    });

    Map<String, String> authParam = {
      'authentication_token': user.authenticationToken!
    };

    Uri uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: authParam);
    var apiRequest = APIRequest(finalUri.toString());
    isLoading = true;

    try {
      var apiResponse =
          await _networkAdapter.postMultipart(apiRequest, formData);
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

  Document _processResponse(APIResponse apiResponse) {
    if (apiResponse.data == null) throw InvalidResponseException();

    var responseMapList = apiResponse.data;

    return _readItemsFromResponse(responseMapList);
  }

  Document _readItemsFromResponse(Map<String, dynamic> responseMap) {
    try {
      var document = Document.fromJson(responseMap);
      return document;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}

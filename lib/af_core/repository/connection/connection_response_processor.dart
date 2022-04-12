import '../../af_api/entities/api_response.dart';

class ConnectionResponseProcessor {
  dynamic processResponse(APIResponse response) {
    return _parseResponseData(response.data);
  }

  dynamic _parseResponseData(dynamic responseData) {
    return responseData;
  }
}

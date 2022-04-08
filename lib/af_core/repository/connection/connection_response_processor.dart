import '../../af_api/entities/api_response.dart';
import '../../af_api/exceptions/unexpected_response_format_exception.dart';

class ConnectionResponseProcessor {
  dynamic processResponse(APIResponse response) {
    return _parseResponseData(response.data);
  }

  dynamic _parseResponseData(dynamic responseData) {
    return responseData;
  }
}
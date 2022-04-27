import 'package:altaface/af_core/af_api/entities/api_response.dart';
import 'package:altaface/af_core/af_api/exceptions/unexpected_response_format_exception.dart';

class UserResponseProcessor {
  dynamic processResponse(APIResponse response) {
    return _parseResponseData(response.data);
  }

  dynamic _parseResponseData(dynamic responseData) {
    if (responseData is! List<dynamic> && responseData is! dynamic) {
      throw UnexpectedResponseFormatException();
    }

    return responseData;
  }
}



import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/unexpected_response_format_exception.dart';


class CompanyResponseProcessor {
  dynamic processResponse(APIResponse response) {
    return _parseResponseData(response.data);
  }

  dynamic _parseResponseData(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      throw UnexpectedResponseFormatException();
    }

    return _readAFResponseDataFromResponse(responseData);
  }

  dynamic _readAFResponseDataFromResponse(Map<String, dynamic> responseMap) {
    if ((responseMap['data'] is List<dynamic>)) {
      return _parseDataList(responseMap['data']);
    } else {
      return responseMap;
    }
  }

  List<Map<String, dynamic>> _parseDataList(List<dynamic> responseDataList) {
    List<Map<String, dynamic>> items = [];

    for (dynamic element in responseDataList) {
      if (element is Map<String, dynamic>) {
        items.add(element);
      } else {
        items.clear();
        break;
      }
    }
    return items;
  }
}



import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/server_sent_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/unexpected_response_format_exception.dart';

import '../exceptions/malformed_response_exception.dart';

class WPAPIResponseProcessor {
  dynamic processResponse(APIResponse response) {
    return _parseResponseData(response.data);
  }

  dynamic _parseResponseData(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      throw UnexpectedResponseFormatException();
    }

    if (_isResponseProperlyFormed(responseData) == false) {
      throw MalformedResponseException();
    }

    return _readWPResponseDataFromResponse(responseData);
  }

  bool _isResponseProperlyFormed(Map<String, dynamic> responseMap) {
    if (responseMap.containsKey('status')) {
      if (responseMap['status'] == 'success') {
        return responseMap.containsKey('data');
      } else {
        return true;
      }
    }
    return false;
  }

  dynamic _readWPResponseDataFromResponse(Map<String, dynamic> responseMap) {
    if (responseMap['status'] != 'success') {
      throw ServerSentException(responseMap['message'], responseMap['errorCode'] ?? 0);
    }

    if ((responseMap['data'] is List<dynamic>)) {
      return _parseDataList(responseMap['data']);
    } else {
      return responseMap['data'];
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

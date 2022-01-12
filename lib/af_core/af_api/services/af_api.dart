
import 'dart:convert';

import 'package:flutter_projects/_shared/constants/app_id.dart';
import 'package:flutter_projects/_shared/constants/device_info.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';

import 'afapi_response_processor.dart';
import '../exceptions/http_exception.dart';
import 'network_adapter.dart';
import 'network_request_executor.dart';

class AFAPI implements NetworkAdapter {
  late DeviceInfoProvider _deviceInfo;
  late NetworkAdapter _networkAdapter;

  AFAPI() {
    _deviceInfo = DeviceInfoProvider();
    _networkAdapter = NetworkRequestExecutor();
  }

  AFAPI.initWith(this._deviceInfo, this._networkAdapter);

  @override
  Future<APIResponse> get(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildAFHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return get(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildAFHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.put(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return put(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildAFHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return post(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildAFHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.delete(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return delete(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  Future<Map<String, String>> _buildAFHeaders({bool forceRefresh = false}) async {
    var headers = <String, String>{};
    headers['Content-Type'] = 'application/json';
    headers['X-Device-ID'] = await _deviceInfo.getDeviceId();
    headers['X-App-ID'] = AppId.appId;

   // var authToken = await _accessTokenProvider.getToken(forceRefresh: forceRefresh);
   //  if (authToken != null) {
   //    headers['Authorization'] = authToken;
   //  }
    return headers;
  }

  APIResponse _processResponse(APIResponse response, APIRequest apiRequest) {
    // var responseData = AFAPIResponseProcessor().processResponse(response);
    // return APIResponse(apiRequest, response.statusCode, responseData, {});
    return response;
  }

  bool _shouldRefreshTokenOnException(APIException apiException) {
    if (apiException is HTTPException) {
      try {
        var responseData = json.decode(apiException.responseData);
        var responseMap = responseData as Map<String, dynamic>;
        var errorCode = responseMap['code'];
        if (errorCode == 1022) return true;
      } catch (e) {
        //ignore exception
      }
    }
    return false;
  }
}

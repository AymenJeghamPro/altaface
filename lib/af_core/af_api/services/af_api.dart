import 'dart:convert';

import 'package:dio/src/form_data.dart';
import 'package:flutter_projects/_shared/constants/app_id.dart';
import 'package:flutter_projects/_shared/constants/device_info.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';

import 'afapi_response_processor.dart';
import '../exceptions/http_exception.dart';
import 'network_adapter.dart';
import 'network_request_executor.dart';

class AltaFaceAPI implements NetworkAdapter {
  late DeviceInfoProvider _deviceInfo;
  late NetworkAdapter _networkAdapter;

  AltaFaceAPI() {
    _deviceInfo = DeviceInfoProvider();
    _networkAdapter = NetworkRequestExecutor();
  }

  AltaFaceAPI.initWith(this._deviceInfo, this._networkAdapter);

  @override
  Future<APIResponse> get(APIRequest apiRequest,
      {bool forceRefresh = false}) async {
    apiRequest
        .addHeaders(await _buildAltaFaceHeaders(forceRefresh: forceRefresh));
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
  Future<APIResponse> put(APIRequest apiRequest,
      {bool forceRefresh = false}) async {
    apiRequest
        .addHeaders(await _buildAltaFaceHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.put(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return put(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest,
      {bool forceRefresh = false}) async {
    apiRequest
        .addHeaders(await _buildAltaFaceHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return post(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> postMultipart(APIRequest apiRequest, FormData formData,
      {bool forceRefresh = false}) async {
    try {
      var apiResponse =
          await _networkAdapter.postMultipart(apiRequest, formData);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return postMultipart(apiRequest, formData, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest,
      {bool forceRefresh = false}) async {
    apiRequest
        .addHeaders(await _buildAltaFaceHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.delete(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return delete(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  Future<Map<String, String>> _buildAltaFaceHeaders(
      {bool forceRefresh = false,
      String contentType = 'application/json'}) async {
    var headers = <String, String>{};
    headers['Content-Type'] = contentType;
    headers['X-Device-ID'] = await _deviceInfo.getDeviceId();
    headers['X-App-ID'] = AppId.appId;

    return headers;
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

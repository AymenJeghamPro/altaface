import 'dart:convert';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/http_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/network_failure_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/request_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/unexpected_response_format_exception.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'network_adapter.dart';

class NetworkRequestExecutor implements NetworkAdapter {
  Dio dio = new Dio();

  NetworkRequestExecutor() {
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  @override
  Future<APIResponse> get(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'GET');
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'POST');
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'PUT');
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'DELETE');
  }

  Future<APIResponse> executeRequest(APIRequest apiRequest, String method) async {
    if (await _isConnected() == false) throw NetworkFailureException();

    try {
      Response<String> response = await dio.request(
        apiRequest.url,
        data: jsonEncode(apiRequest.parameters),
        options: Options(
          method: method,
          headers: apiRequest.headers,
          validateStatus: (status) => status == 200,
        ),
      );
      return _processResponse(response, apiRequest);
    } on DioError catch (error) {
      throw _processError(error);
    }
  }

  Future<bool> _isConnected() {
    return DataConnectionChecker().hasConnection;
  }

  APIResponse _processResponse(Response response, APIRequest apiRequest) {
    try {
      var responseData = json.decode(response.data);
      return APIResponse(apiRequest, response.statusCode!, responseData, {});
    } catch (e) {
      throw UnexpectedResponseFormatException();
    }
  }

  APIException _processError(DioError error) {
    if (error.response == null || error.response!.statusCode == null) {
      //Something happened in setting up or sending the request that triggered an Error
      return RequestException(error.message);
    } else {
      // The request was made and the server responded with a statusCode != 200
      return HTTPException(error.response!.statusCode!, error.response!.data);
    }
  }
}

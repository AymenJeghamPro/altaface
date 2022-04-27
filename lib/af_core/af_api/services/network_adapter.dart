import 'package:dio/dio.dart';
import 'package:altaface/af_core/af_api/entities/api_request.dart';
import 'package:altaface/af_core/af_api/entities/api_response.dart';

abstract class NetworkAdapter {
  Future<APIResponse> get(APIRequest apiRequest);

  Future<APIResponse> post(APIRequest apiRequest);

  Future<APIResponse> postMultipart(APIRequest apiRequest, FormData formData);

  Future<APIResponse> put(APIRequest apiRequest);

  Future<APIResponse> delete(APIRequest apiRequest);
}

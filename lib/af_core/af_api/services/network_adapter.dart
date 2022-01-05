

import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';

abstract class NetworkAdapter {
  Future<APIResponse> get(APIRequest apiRequest);

  Future<APIResponse> post(APIRequest apiRequest);

  Future<APIResponse> put(APIRequest apiRequest);

  Future<APIResponse> delete(APIRequest apiRequest);
}

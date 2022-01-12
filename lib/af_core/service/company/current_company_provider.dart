import 'package:flutter_projects/_shared/exceptions/invalid_response_exception.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_request.dart';
import 'package:flutter_projects/af_core/af_api/entities/api_response.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/http_exception.dart';
import 'package:flutter_projects/af_core/af_api/exceptions/server_sent_exception.dart';
import 'package:flutter_projects/af_core/af_api/services/af_api.dart';
import 'package:flutter_projects/af_core/af_api/services/network_adapter.dart';
import 'package:flutter_projects/af_core/entity/company/company.dart';
import 'package:flutter_projects/af_core/repository/company/company_repository.dart';
import 'package:flutter_projects/af_core/constants/company_urls.dart';

import '../../repository/company/company_response_processor.dart';

class CurrentCompanyProvider {
  final CompanyRepository _companyRepository;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;

  CurrentCompanyProvider.initWith(
      this._companyRepository, this._networkAdapter);

  CurrentCompanyProvider()
      : _companyRepository = CompanyRepository(),
        _networkAdapter = AFAPI();

  void reset() {
    isLoading = false;
  }

  bool isLoggedIn() {
    return _companyRepository.getCurrentCompany() != null;
  }

  Future<Company?> login(String key) async {
    var url = CompanyManagementUrls.getCompany();
    Map<String, String> qParams = {'key': key};
    Uri uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: qParams);
    var apiRequest = APIRequest(finalUri.toString());
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      var responseData = CompanyResponseProcessor().processResponse(apiResponse);
      var response =  APIResponse(apiRequest, apiResponse.statusCode, responseData, {});
      isLoading = false;
      return _processResponse(response);
    } on APIException catch (exception) {
      isLoading = false;
      if (exception is HTTPException && exception.httpCode == 401) {
        throw ServerSentException('Invalid username or password', 401);
      } else {
        rethrow;
      }
    }
  }

  Company _processResponse(APIResponse apiResponse) {
    if (apiResponse.data == null) throw InvalidResponseException();

    var responseMapList = apiResponse.data;

    return _readItemsFromResponse(responseMapList);
  }

  Company _readItemsFromResponse(Map<String, dynamic> responseMap) {
    try {
      var company = Company.fromJson(responseMap);

      _companyRepository.saveCompany(company);

      return company;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}

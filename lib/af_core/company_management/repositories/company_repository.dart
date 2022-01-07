import 'dart:convert';
import 'dart:developer';

import 'package:flutter_projects/_shared/local_storage/secure_shared_prefs.dart';
import 'package:flutter_projects/af_core/company_management/entities/company.dart';

class CompanyRepository {
  late SecureSharedPrefs _sharedPrefs;
  Company? _currentCompany;

  static CompanyRepository? _singleton;

  factory CompanyRepository() {
    _singleton ??= CompanyRepository.withSharedPrefs(SecureSharedPrefs());
    return _singleton!;
  }

  CompanyRepository.withSharedPrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    _readData();
  }

  Company? getCurrentCompany() {
    return _currentCompany;
  }

  void saveCompany(Company company) {
    _sharedPrefs.save('company', company);
  }

  void _readData() async {
    var company = await _sharedPrefs.getString('company');
    if (company != null) {
      _currentCompany = Company.fromJson(json.decode(company));
    }
  }


}

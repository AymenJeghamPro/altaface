import 'dart:convert';

import 'package:altaface/_shared/local_storage/secure_shared_prefs.dart';
import 'package:altaface/af_core/entity/company/company.dart';

class CompanyRepository {
  late SecureSharedPrefs _sharedPrefs;
  Company? _currentCompany;

  static CompanyRepository? _singleton;

  static Future<void> initRepo() async {
    await getInstance()._readData();
  }

  static CompanyRepository getInstance() {
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
    _currentCompany = company;
  }

  Future<void> _readData() async {
    var company = await _sharedPrefs.getString('company');
    if (company != null) {
      _currentCompany = Company.fromJson(json.decode(company));
    }
  }
}

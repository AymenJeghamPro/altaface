
import 'package:flutter_projects/_shared/local_storage/secure_shared_prefs.dart';
import 'package:flutter_projects/af_core/company_management/entities/company.dart';

class CompanyRepository {
  SecureSharedPrefs? _sharedPrefs;

  static CompanyRepository? _singleton;

  factory CompanyRepository() {
    _singleton ??= CompanyRepository.withSharedPrefs(SecureSharedPrefs());
    return _singleton!;
  }

  CompanyRepository.withSharedPrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
  }

  Company? getCurrentCompany() {
    return null;
  }



}

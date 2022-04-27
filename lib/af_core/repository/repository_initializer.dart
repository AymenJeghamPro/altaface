import 'package:altaface/af_core/repository/user/user_repository.dart';

import 'company/company_repository.dart';

class RepositoryInitializer {
  Future<void> initializeRepos() async {
    await CompanyRepository.initRepo();
    await UsersRepository.initRepo();
  }
}

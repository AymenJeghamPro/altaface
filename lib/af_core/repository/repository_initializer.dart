
import 'company/company_repository.dart';

class RepositoryInitializer  {
  Future<void>  initializeRepos() async {
   await CompanyRepository.initRepo();
  }
}

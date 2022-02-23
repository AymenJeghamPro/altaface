import 'package:flutter_projects/_shared/constants/base_urls.dart';

class UsersManagementUrls {
  static String getUsersUrl() {
    return '${BaseUrls.baseUrlV2()}connection_altaface';
  }

  static String postUsersUrl() {
    return '${BaseUrls.baseUrlV2()}sessions';
  }
}

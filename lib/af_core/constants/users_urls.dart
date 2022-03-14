import 'package:flutter_projects/_shared/constants/base_urls.dart';

class UsersManagementUrls {
  static String getUsersUrl() {
    return '${BaseUrls.baseUrlV2()}connection_altaface';
  }

  static String loginUrl() {
    return '${BaseUrls.baseUrlV2()}sessions';
  }

  static String startWorkday() {
    return '${BaseUrls.baseUrlV2()}upload';
  }
}

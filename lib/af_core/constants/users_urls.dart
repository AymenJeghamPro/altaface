import 'package:altaface/_shared/constants/base_urls.dart';

class UsersManagementUrls {
  static String getUsersUrl() {
    return '${BaseUrls.baseUrlV2()}connection_altaface';
  }

  static String getAdminsUrl() {
    return '${BaseUrls.baseUrlV2()}connection';
  }

  static String loginUrl() {
    return '${BaseUrls.baseUrlV2()}sessions';
  }

  static String startWorkday() {
    return '${BaseUrls.baseUrlV2()}upload';
  }
}

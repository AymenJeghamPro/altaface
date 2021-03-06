import 'package:altaface/_shared/exceptions/mapping_exception.dart';
import 'package:altaface/_shared/json_serialisation_base/json_convertible.dart';
import 'package:altaface/_shared/json_serialisation_base/json_initializable.dart';
import 'package:sift/sift.dart';

class User extends JSONInitializable implements JSONConvertible {
  String? _id;
  String? _type;
  String? _teamId;
  String? _weeklyScheduleId;
  String? _firstName;
  String? _lastName;
  String? _userName;
  bool? _isLocalized;
  String? _storeId;
  String? _avatar;
  String? _authenticationToken;
  bool? _isArchived;
  String? _workDayId;
  num _activitiesCount = 0;

  User.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = sift.readStringFromMap(jsonMap, 'id');
      _type = sift.readStringFromMap(jsonMap, 'type');
      _teamId =
          sift.readStringFromMapWithDefaultValue(jsonMap, 'team_id', null);
      _weeklyScheduleId = sift.readStringFromMapWithDefaultValue(
          jsonMap, 'weekly_schedule_id', null);
      _firstName = sift.readStringFromMap(jsonMap, 'first_name');
      _lastName = sift.readStringFromMap(jsonMap, 'last_name');
      _userName = sift.readStringFromMap(jsonMap, 'username');
      _isLocalized = sift.readBooleanFromMap(jsonMap, 'is_localized');
      _storeId =
          sift.readStringFromMapWithDefaultValue(jsonMap, 'store_id', null);
      _avatar = sift.readStringFromMapWithDefaultValue(jsonMap, 'avatar', null);
      _isArchived = sift.readBooleanFromMap(jsonMap, 'is_archived');
      _authenticationToken = sift.readStringFromMapWithDefaultValue(
          jsonMap, 'authentication_token', null);
      _workDayId =
          sift.readStringFromMapWithDefaultValue(jsonMap, 'workday_id', null);
      _activitiesCount = sift.readNumberFromMapWithDefaultValue(
          jsonMap, 'current_activities_count', 0)!;
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast Company response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'id': _id,
      'type': _type,
      'team_id': _teamId,
      'weekly_schedule_id': _weeklyScheduleId,
      'first_name': _firstName,
      'last_name': _lastName,
      'username': _userName,
      'is_localized': _isLocalized,
      'store_id': _storeId,
      'avatar': _avatar,
      'is_archived': _isArchived,
      'authentication_token': _authenticationToken
    };
    return jsonMap;
  }

  String? get id => _id;

  String? get type => _type;

  String? get teamId => _teamId;

  String? get weeklyScheduleId => _weeklyScheduleId;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get userName => _userName;

  bool? get isLocalized => _isLocalized;

  String? get storeId => _storeId;

  String? get avatar => _avatar;

  bool? get isArchived => _isArchived;

  String? get authenticationToken => _authenticationToken;

  String? get workDayId => _workDayId;

  num get activitiesCount => _activitiesCount;
}

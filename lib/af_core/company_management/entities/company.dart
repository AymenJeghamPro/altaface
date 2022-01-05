
import 'package:flutter_projects/_shared/exceptions/mapping_exception.dart';
import 'package:flutter_projects/_shared/json_serialisation_base/json_convertible.dart';
import 'package:flutter_projects/_shared/json_serialisation_base/json_initializable.dart';
import 'package:sift/sift.dart';

class Company extends JSONInitializable implements JSONConvertible {

  String? _id;
  String? _name;
  String? _language;
  String? _timeZone;
  String? _logoUrl;
  num? _siteDefaultRadius;
  String? _addressId;
  bool? _isArchived;

  Company.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = '${sift.readNumberFromMap(jsonMap, 'id')}';
      _name = sift.readStringFromMap(jsonMap, 'name');
      _language = sift.readStringFromMap(jsonMap, 'language');
      _timeZone = sift.readStringFromMap(jsonMap, 'timezone');
      _logoUrl = sift.readStringFromMap(jsonMap, 'logo');
      _siteDefaultRadius = sift.readNumberFromMap(jsonMap, 'site_default_radius') ;
      _addressId = sift.readStringFromMap(jsonMap, 'address_id');
      _isArchived = sift.readBooleanFromMap(jsonMap, 'is_archived');
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast Company response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {


    Map<String, dynamic> jsonMap = {
      'company_id': int.parse(_id!),
      'company_name': _name,
      'language': _language,
      'timezone': _timeZone,
      'company_logo': _logoUrl,
      'radius': _siteDefaultRadius,
      'address_id': _addressId,
      'is_archived' : _isArchived
    };
    return jsonMap;
  }

  String? get id => _id;

  String? get name => _name;

  String? get language => _language;

  String? get timeZone => _timeZone;

  String?  get logoUrl =>_logoUrl;

  num? get siteDefaultRadius => _siteDefaultRadius;

  String? get addressId => _addressId;

  bool? get isArchived => _isArchived;
}


import 'package:flutter_projects/_shared/json_serialisation_base/json_convertible.dart';

class Credentials implements JSONConvertible {
  final String key;

  Credentials(this.key);

  @override
  Map<String, dynamic> toJson() {
    return {
      'key': key
    };
  }
}

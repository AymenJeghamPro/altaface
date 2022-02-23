// ignore_for_file: constant_identifier_names

import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';

class MalformedResponseException extends APIException {
  static const _USER_READABLE_MESSAGE =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _INTERNAL_MESSAGE = "Altagem API response is malformed."
      " status and data fields may be missing or may have wrong values.";

  MalformedResponseException()
      : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}

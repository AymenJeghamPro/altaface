

import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';

class UnexpectedResponseFormatException extends APIException {
  static const _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";
  static const _INTERNAL_MESSAGE = "The response is in an unexpected format.";

  UnexpectedResponseFormatException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}

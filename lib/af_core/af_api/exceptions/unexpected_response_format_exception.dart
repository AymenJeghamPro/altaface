import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';

class UnexpectedResponseFormatException extends APIException {
  static const _userReadableMessage =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _internalMessage = "The response is in an unexpected format.";

  UnexpectedResponseFormatException()
      : super(_userReadableMessage, _internalMessage);
}

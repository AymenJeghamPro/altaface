import 'package:altaface/af_core/af_api/exceptions/api_exception.dart';

class MalformedResponseException extends APIException {
  static const _userReadableMessage =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _internalMessage = "Altagem API response is malformed."
      " status and data fields may be missing or may have wrong values.";

  MalformedResponseException() : super(_userReadableMessage, _internalMessage);
}

import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';

class RequestException extends APIException {
  static const String _userReadableMessage =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const String _internalMessage = "";

  RequestException(String? errorMessage)
      : super(errorMessage ?? _userReadableMessage, _internalMessage);
}

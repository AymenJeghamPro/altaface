import 'package:flutter_projects/af_core/af_api/exceptions/api_exception.dart';

class HTTPException extends APIException {
  static const String _userReadableMessage =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const String _internalMessage =
      "Request failed with HTTP error code: ";
  final int httpCode;

  HTTPException(
    this.httpCode,
    dynamic responseData,
  ) : super(_userReadableMessage, '$_internalMessage $httpCode',
            responseData: responseData);
}

import 'package:altaface/af_core/af_api/exceptions/api_exception.dart';

class ServerSentException extends APIException {
  static const String _userReadableMessage =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const String _internalMessage = "";
  late int errorCode;

  ServerSentException(
    String? errorMessage,
    int errorCode,
  ) : super(errorMessage ?? _userReadableMessage, _internalMessage) {
    this.errorCode = errorCode;
  }
}

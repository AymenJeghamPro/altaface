import 'api_exception.dart';

class NetworkFailureException extends APIException {
  static const _userReadableMessage =
      "Please check your network connection and try again.";
  static const _internalMessage =
      "There is an issue with the network connection";

  NetworkFailureException() : super(_userReadableMessage, _internalMessage);
}

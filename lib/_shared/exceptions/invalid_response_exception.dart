import 'af_exception.dart';

class InvalidResponseException extends AFException {
  static const _userReadableMessage =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _internalMessage = "The response is invalid";

  InvalidResponseException() : super(_userReadableMessage, _internalMessage);
}

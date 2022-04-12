import 'af_exception.dart';

class WrongResponseFormatException extends AFException {
  static const _userReadableMessage =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _internalMessage = "The response is of the wrong format.";

  WrongResponseFormatException()
      : super(_userReadableMessage, _internalMessage);
}

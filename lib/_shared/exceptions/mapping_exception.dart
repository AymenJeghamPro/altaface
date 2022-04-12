import 'af_exception.dart';

class MappingException extends AFException {
  static const String _userReadableMessage =
      "Oops! Looks like something has gone wrong. Please try again.";

  MappingException(String errorMessage)
      : super(_userReadableMessage, errorMessage);
}

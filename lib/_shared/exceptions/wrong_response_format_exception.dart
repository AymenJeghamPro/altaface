// ignore_for_file: constant_identifier_names

import 'af_exception.dart';

class WrongResponseFormatException extends AFException {
  static const _USER_READABLE_MESSAGE =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _INTERNAL_MESSAGE = "The response is of the wrong format.";

  WrongResponseFormatException()
      : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}

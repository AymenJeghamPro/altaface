// ignore_for_file: constant_identifier_names

import 'af_exception.dart';

class MappingException extends AFException {
  static const String _USER_READABLE_MESSAGE =
      "Oops! Looks like something has gone wrong. Please try again.";

  MappingException(String errorMessage)
      : super(_USER_READABLE_MESSAGE, errorMessage);
}

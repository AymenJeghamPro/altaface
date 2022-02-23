// ignore_for_file: constant_identifier_names

import 'af_exception.dart';

class InvalidResponseException extends AFException {
  static const _user_readable_message =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _internal_message = "The response is invalid";

  InvalidResponseException() : super(_user_readable_message, _internal_message);
}

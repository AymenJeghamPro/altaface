import 'package:altaface/_shared/exceptions/af_exception.dart';

class APIException extends AFException {
  final dynamic responseData;

  APIException(
    String userReadableMessage,
    String internalErrorMessage, {
    this.responseData,
  }) : super(userReadableMessage, internalErrorMessage);
}

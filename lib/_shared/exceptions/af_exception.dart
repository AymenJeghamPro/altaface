abstract class AFException implements Exception {
  final String userReadableMessage;
  final String internalErrorMessage;

  AFException(this.userReadableMessage, this.internalErrorMessage);
}

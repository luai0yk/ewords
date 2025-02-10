class ErrorHandler {
  static errorHandler(
      {required String message, required Function(String) onError}) {
    onError(message);
  }
}

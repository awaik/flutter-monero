class ErrorInfo {
  ErrorInfo({required this.code, required this.message});

  String getErrorMessage() {
    return "$code: $message";
  }

  final int code;
  final String? message;
}
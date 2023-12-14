class RestoreWalletFromSeedException implements Exception {
  RestoreWalletFromSeedException({required this.message});

  final String message;
}
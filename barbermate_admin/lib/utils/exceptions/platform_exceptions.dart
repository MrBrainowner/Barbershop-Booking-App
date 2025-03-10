class BPlatformException implements Exception {
  // The error code associated with the exception
  final String code;

  // Constructor that takes an error code
  BPlatformException(this.code);

  // Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'not-implemented':
        return 'This feature is not implemented on the current platform.';
      case 'unavailable':
        return 'The feature is not available on the current platform.';
      case 'method-not-found':
        return 'The requested method was not found. Please check the method name.';
      case 'unknown':
        return 'An unknown platform error occurred. Please try again.';
      case 'invalid-arguments':
        return 'The arguments provided are invalid. Please check and try again.';
      case 'missing-permissions':
        return 'Missing required permissions. Please grant the necessary permissions and try again.';
      default:
        return 'A platform-specific error occurred. Please try again.';
    }
  }

  @override
  String toString() => 'BPlatformException: $message';
}

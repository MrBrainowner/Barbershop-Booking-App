class BFirebaseException implements Exception {
  // The error code associated with the exception
  final String code;

  // Constructor that takes an error code
  BFirebaseException(this.code);

  // Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'permission-denied':
        return 'You do not have permission to perform this operation.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      case 'deadline-exceeded':
        return 'The operation took too long to complete. Please try again later.';
      case 'cancelled':
        return 'The operation was cancelled.';
      case 'already-exists':
        return 'The document you are trying to create already exists.';
      case 'not-found':
        return 'The document was not found.';
      case 'failed-precondition':
        return 'The operation was rejected due to a failed precondition.';
      case 'aborted':
        return 'The operation was aborted. Please try again.';
      case 'out-of-range':
        return 'The operation was attempted past the valid range.';
      case 'data-loss':
        return 'Data loss occurred. Please try again.';
      case 'unauthenticated':
        return 'You are not authenticated. Please sign in and try again.';
      default:
        return 'An unknown Firebase error occurred. Please try again.';
    }
  }

  @override
  String toString() => 'BFirebaseException: $message';
}

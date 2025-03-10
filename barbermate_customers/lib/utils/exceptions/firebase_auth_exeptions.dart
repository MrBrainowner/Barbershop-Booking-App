class BFirebaseAuthException implements Exception {
  // The error code associated with the exception
  final String code;

  // Constructor that takes an error code
  BFirebaseAuthException(this.code);

  // Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'The email address is already registered. Please use a different email.';
      case 'invalid-email':
        return 'The email address is not valid. Please check and try again.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'user-disabled':
        return 'This user account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No user found with this email. Please check and try again.';
      case 'wrong-password':
        return 'Incorrect password. Please check and try again.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials. Please use another sign-in method.';
      case 'invalid-credential':
        return 'The provided credentials are not valid. Please check and try again.';
      case 'invalid-verification-code':
        return 'The verification code is invalid. Please check and try again.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid. Please check and try again.';
      case 'session-expired':
        return 'Your session has expired. Please sign in again.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please log in again and try.';
      case 'network-request-failed':
        return 'A network error occurred. Please check your connection and try again.';
      case 'invalid-action-code':
        return 'The action code is invalid. This could be due to an expired code or a code that has already been used.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }

  @override
  String toString() => 'BFirebaseAuthException: $message';
}

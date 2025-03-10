class BFormatException implements Exception {
  // The error code associated with the exception
  final String code;

  // Constructor that takes an error code
  BFormatException(this.code);

  // Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'invalid-data':
        return 'The data provided is in an invalid format. Please check and try again.';
      case 'invalid-length':
        return 'The data length is not correct. Please check and try again.';
      case 'unexpected-character':
        return 'Unexpected character encountered. Please check the input and try again.';
      case 'unexpected-end':
        return 'Unexpected end of input. Please complete the input and try again.';
      default:
        return 'A format error occurred. Please check the input and try again.';
    }
  }

  @override
  String toString() => 'BFormatException: $message';
}

import 'package:get/get.dart';

class ValidatorController extends GetxController {
  static ValidatorController get instance => Get.find();

  // empty
  String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field required';
    }
    return null;
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Phone number validation
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // File upload validation
  String? validateFileUpload(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please upload the required document';
    }
    return null;
  }

  // Postal code validation
  String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your postal code';
    }
    // Assuming a typical postal code is 4 to 6 digits
    final postalCodePattern = RegExp(r'^\d{4,6}$');
    if (!postalCodePattern.hasMatch(value)) {
      return 'Please enter a valid postal code';
    }
    return null;
  }
}

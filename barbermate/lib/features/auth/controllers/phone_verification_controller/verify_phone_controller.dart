// import 'package:barbermate/common/widgets/toast.dart';
// import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
// import 'package:barbermate/data/repository/customer_repo/customer_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class VerifyPhoneController extends GetxController {
//   static VerifyPhoneController get instance => Get.find();
//   final CustomerRepository customerRepo = Get.find();

//   final number = TextEditingController();
//   RxInt resendToken = RxInt(0);

//   /// Sends OTP after validating phone number
//   Future<void> sendOTP(String number) async {
//     if (number.isEmpty || !number.startsWith('+')) {
//       ToastNotif(
//         message: 'Please enter a valid phone number including country code.',
//         title: 'Invalid Number',
//       ).showErrorNotif(Get.context!);
//       return;
//     }

//     try {
//       await AuthenticationRepository.instance.phoneAuthenticate(number);
//       ToastNotif(
//         message: 'Please check your messages for the OTP.',
//         title: 'Code Sent!',
//       ).showSuccessNotif(Get.context!);
//     } catch (e) {
//       ToastNotif(
//         message: 'Failed to send OTP: ${e.toString()}',
//         title: 'Error',
//       ).showErrorNotif(Get.context!);
//     }
//   }

//   /// Verifies the OTP entered by the user
//   Future<void> verifyOTP(String otp) async {
//     try {
//       // Step 1: Verify the OTP to check if the new phone number is correct
//       bool isVerified = await AuthenticationRepository.instance.verifyOTP(otp);

//       if (isVerified) {
//         // Step 2: Unlink the old phone number after verification is successful
//         await _unlinkOldPhoneNumber();

//         // Step 3: Update the phone number in the user's profile
//         await customerRepo.updateCustomerSingleField({'phone_no': number.text});

//         // Step 4: Notify the user that the phone number has been verified and linked
//         ToastNotif(
//           message: 'Phone number verified successfully.',
//           title: 'Success',
//         ).showSuccessNotif(Get.context!);
//       } else {
//         ToastNotif(
//           message: 'Invalid OTP. Please try again.',
//           title: 'Verification Failed',
//         ).showErrorNotif(Get.context!);
//       }
//     } catch (e) {
//       // Step 5: Handle any errors that may occur during verification
//       ToastNotif(
//         message: 'Failed to verify OTP: ${e.toString()}',
//         title: 'Error',
//       ).showErrorNotif(Get.context!);
//     }
//   }

//   // Unlinks the old phone number from the user's account
//   Future<void> _unlinkOldPhoneNumber() async {
//     try {
//       await AuthenticationRepository.instance.unlinkOldPhoneNumber();
//     } catch (e) {
//       // Handle the error in case unlinking fails
//       ToastNotif(
//         message: 'Failed to unlink old phone number.',
//         title: 'Error',
//       ).showErrorNotif(Get.context!);
//     }
//   }

//   /// Resends OTP to the provided phone number
//   Future<void> resendOTP(String phoneNumber) async {
//     if (phoneNumber.isEmpty || !phoneNumber.startsWith('+')) {
//       ToastNotif(
//         message: 'Please enter a valid phone number including country code.',
//         title: 'Invalid Number',
//       ).showErrorNotif(Get.context!);
//       return;
//     }

//     try {
//       // Ensure resendToken is valid before trying to resend
//       if (resendToken.value > 0) {
//         await AuthenticationRepository.instance.resendCode(phoneNumber);
//         ToastNotif(
//           message: 'Verification code resent.',
//           title: 'Code Resent!',
//         ).showSuccessNotif(Get.context!);
//       } else {
//         ToastNotif(
//           message: 'No previous request found. Please start again.',
//           title: 'Error',
//         ).showErrorNotif(Get.context!);
//       }
//     } catch (e) {
//       ToastNotif(
//         message: 'Failed to resend OTP: ${e.toString()}',
//         title: 'Error',
//       ).showErrorNotif(Get.context!);
//     }
//   }
// }

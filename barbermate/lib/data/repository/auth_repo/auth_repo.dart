import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/utils/popups/full_screen_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import '../../../features/auth/views/email_verification/email_verification.dart';
import '../../../features/auth/views/onboarding/onboarding.dart';
import '../../../features/auth/views/sign_in/sign_in_page.dart';
import '../../../utils/exceptions/firebase_auth_exeptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final Logger logger = Logger();

  //======================================= Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance; // Firestore instance

  var verificationId = ''.obs;
  RxInt resendToken = RxInt(0);

  User? get authUser => _auth.currentUser;

  //======================================= On App Launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    pageRedirect();
  }

  //============================================================================== Email and Password

  //======================================= Function Redirect Page
  void pageRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      if (user.emailVerified) {
        try {
          // Get the user's role from Firestore
          DocumentSnapshot userDoc =
              await _firestore.collection('Barbershops').doc(user.uid).get();

          if (userDoc.exists) {
            // Safely access document fields
            bool existing = userDoc['existing'];
            String role = userDoc['role'];

            if (role == 'barbershop') {
              if (existing) {
                Get.offAllNamed('/barbershop/dashboard');
              } else {
                Get.offAllNamed('/barbershop/setup_profile');
              }
            } else if (role == 'customer') {
              await logOut();
              ToastNotif(message: 'Access Denied', title: 'Error')
                  .showErrorNotif(Get.context!);
            } else if (role == 'admin') {
              await logOut();
              ToastNotif(message: 'Access Denied', title: 'Error')
                ..showErrorNotif(Get.context!);
            } else {
              await logOut();
              ToastNotif(message: 'Access Denied', title: 'Error')
                  .showErrorNotif(Get.context!);
            }
          } else {
            await logOut();
            ToastNotif(message: 'User is not found.', title: 'Error')
                .showErrorNotif(Get.context!);
          }
        } catch (e) {
          ToastNotif(message: 'Error: $e', title: 'Error')
              .showErrorNotif(Get.context!);
        }
      } else {
        Get.offAll(() => EmailVerification(email: user.email));
      }
    } else {
      // Local Storage
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const SignInPage())
          : Get.offAll(() => const Onboarding());
    }
  }

  //======================================= Sign In
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      logger
          .e('Firebase Auth Exception during login: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e('Firebase Exception during login: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during login');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e('Platform Exception during login: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during login: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Sign Up
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      logger.e(
          'Firebase Auth Exception during registration: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e(
          'Firebase Exception during registration: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during registration');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during registration: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during registration: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Email Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      logger.e(
          'Firebase Auth Exception during email verification: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e(
          'Firebase Exception during email verification: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during email verification');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during email verification: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during email verification: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      logger.e(
          'Firebase Auth Exception during password reset: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e(
          'Firebase Exception during password reset: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during password reset');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during password reset: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during password reset: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Re Authenticate User
  Future<bool> reAuthenticateUser(String currentPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      logger.e(
          'Firebase Auth Exception reauthentication: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e(
          'Firebase Exception during reauthentication: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during reauthentication');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during reauthentication: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during reauthentication: $e');
      return false;
    }
  }

  Future<void> changeUserEmail(String newEmail) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.verifyBeforeUpdateEmail(newEmail);
      await user.sendEmailVerification();
      logger.e('Email change and verification sent');
    } on FirebaseAuthException catch (e) {
      logger.e(
          'Firebase Auth Exception during change email: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e(
          'Firebase Exception during change email: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during change email');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during change email: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error change email: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Change Password
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw FirebaseAuthException(
            code: 'no-user', message: 'No user is currently signed in.');
      }

      // Step 1: Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
          email: AuthenticationRepository.instance.authUser!.email.toString(),
          password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      logger.e(currentPassword);
      logger.e(newPassword);

      // Step 2: Update the password
      await user.updatePassword(newPassword);

      ToastNotif(
        message: 'Password updated successfully.',
        title: 'Success',
      ).showSuccessNotif(Get.context!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ToastNotif(
          message: 'Please re-authenticate to update your password.',
          title: 'Authentication Required',
        ).showErrorNotif(Get.context!);
      } else if (e.code == 'wrong-password') {
        ToastNotif(
          message: 'Incorrect current password. Please try again.',
          title: 'Error',
        ).showErrorNotif(Get.context!);
      } else {
        ToastNotif(
          message: 'Failed to update password: ${e.message}',
          title: 'Error',
        ).showErrorNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(
        message: 'Unexpected error: $e',
        title: 'Error',
      ).showErrorNotif(Get.context!);
    }
  }

  //======================================= Phone
  // Future<void> phoneAuthenticate(String phoneNumber) async {
  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await _linkPhoneCredential(credential);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         String errorMessage = e.code == 'invalid-phone-number'
  //             ? 'Invalid phone number. Please enter a valid one.'
  //             : 'Something went wrong. Try again.';
  //         ToastNotif(message: errorMessage, title: 'Oh Snap!')
  //             .showErrorNotif(Get.context!);
  //       },
  //       codeSent: (String verificationId, int? token) async {
  //         this.verificationId.value = verificationId;
  //         resendToken.value = token ?? 0; // Assign token or 0 if null
  //         ToastNotif(message: 'Verification code sent.', title: 'Success')
  //             .showSuccessNotif(Get.context!);
  //         Get.to(() => const PhoneNumberOTP());
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         this.verificationId.value = verificationId;
  //       },
  //     );
  //   } catch (e) {
  //     logger.e('Unexpected Error during phone verification: $e');
  //     ToastNotif(
  //             message: 'Something went wrong. Please try again.',
  //             title: 'Error')
  //         .showErrorNotif(Get.context!);
  //   }
  // }

  // Future<bool> verifyOTP(String otp) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId.value,
  //       smsCode: otp,
  //     );

  //     // Instead of signing in, link the credential
  //     await _linkPhoneCredential(credential);
  //     ToastNotif(
  //       message: 'Phone number verified and linked successfully.',
  //       title: 'Success',
  //     ).showSuccessNotif(Get.context!);
  //     return true;
  //   } catch (e) {
  //     logger.e('Error verifying OTP: $e');
  //     ToastNotif(message: 'Invalid OTP. Please try again.', title: 'Error')
  //         .showErrorNotif(Get.context!);
  //     return false;
  //   }
  // }

  // Future<void> _linkPhoneCredential(PhoneAuthCredential credential) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       await user.linkWithCredential(credential);
  //       logger.i('Phone number linked successfully.');
  //     } else {
  //       throw Exception('No authenticated user found.');
  //     }
  //   } catch (e) {
  //     if (e is FirebaseAuthException && e.code == 'credential-already-in-use') {
  //       ToastNotif(
  //         message: 'This phone number is already linked to another account.',
  //         title: 'Error',
  //       ).showErrorNotif(Get.context!);
  //     } else {
  //       logger.e('Failed to link phone number: $e');
  //       throw 'Failed to link phone number. Please try again.';
  //     }
  //   }
  // }

  // Future<void> resendCode(String phoneNumber) async {
  //   try {
  //     // Check if resendToken is greater than 0 (which means it's valid)
  //     if (resendToken.value > 0) {
  //       await FirebaseAuth.instance.verifyPhoneNumber(
  //         phoneNumber: phoneNumber,
  //         forceResendingToken: resendToken.value, // Use resend token
  //         verificationCompleted: (PhoneAuthCredential credential) async {
  //           await _linkPhoneCredential(credential);
  //         },
  //         verificationFailed: (FirebaseAuthException e) {
  //           ToastNotif(
  //                   message: 'Failed to resend code. Try again.',
  //                   title: 'Error')
  //               .showErrorNotif(Get.context!);
  //         },
  //         codeSent: (String verificationId, int? token) {
  //           this.verificationId.value = verificationId;
  //           resendToken.value = token ?? 0; // Update resend token
  //           ToastNotif(message: 'Verification code resent.', title: 'Success')
  //               .showSuccessNotif(Get.context!);
  //         },
  //         codeAutoRetrievalTimeout: (String verificationId) {
  //           this.verificationId.value = verificationId;
  //         },
  //       );
  //     } else {
  //       ToastNotif(
  //               message: 'No previous request found. Please start again.',
  //               title: 'Error')
  //           .showErrorNotif(Get.context!);
  //     }
  //   } catch (e) {
  //     logger.e('Error resending verification code: $e');
  //     ToastNotif(
  //             message: 'Something went wrong. Please try again.',
  //             title: 'Error')
  //         .showErrorNotif(Get.context!);
  //   }
  // }

  // Future<void> unlinkOldPhoneNumber() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       await user.unlink('phone');
  //       ToastNotif(
  //         message: 'Old phone number unlinked successfully.',
  //         title: 'Success',
  //       ).showSuccessNotif(Get.context!);
  //     }
  //   } catch (e) {
  //     logger.e('Error unlinking old phone number: $e');
  //     ToastNotif(
  //       message: 'Failed to unlink old phone number.',
  //       title: 'Error',
  //     ).showErrorNotif(Get.context!);
  //   }
  // }

  //============================================================================== Social Sign In

  //======================================= Goolgle

  //======================================= Facebook

  //============================================================================== Other

  //======================================= Log Out
  Future<void> logOut() async {
    try {
      // Get the current user
      final user = _auth.currentUser;
      if (user != null) {
        await FirebaseAuth.instance.signOut();
        Get.offAll(() => const SignInPage());
      }
    } on FirebaseAuthException catch (e) {
      logger
          .e('Firebase Auth Exception during logout: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e('Firebase Exception during logout: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during logout');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e('Platform Exception during logout: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during logout: $e');
      throw 'Something went wrong. Please try again';
    }
  }
}

import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChangeEmailControllerBarbershop extends GetxController {
  static ChangeEmailControllerBarbershop get intace => Get.find();
  final AuthenticationRepository authrepo = Get.find();
  final BarbershopRepository barbershopRepository = Get.find();
  final BarbershopController barbershopController = Get.find();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  // Change Email barbershop
  void changeEmailProcess(String currentPassword, String newEmail) async {
    bool reauthenticated = await authrepo.reAuthenticateUser(currentPassword);

    if (reauthenticated) {
      try {
        // Step 1: Change email in Firebase Authentication
        await authrepo.changeUserEmail(newEmail);

        // Step 2: Send verification email
        await authrepo.sendEmailVerification();

        // Step 3: Update email in Firestore
        await barbershopRepository
            .updateBarbershopSingleField({'email': newEmail});
      } catch (e) {
        ToastNotif(
          message: e.toString(),
          title: 'Error',
        ).showErrorNotif(Get.context!);
      }
    } else {
      ToastNotif(
        message: 'Re-authentication failed. Please try again.',
        title: 'Error',
      ).showErrorNotif(Get.context!);
    }
  }

  // If the email in Firestore does not match the authenticated email, revert it
  Future<void> handleEmailMismatch() async {
    // Check if the email in Firestore is different from the authenticated email
    String authenticatedEmail = authrepo.authUser?.email ?? '';

    if (barbershopController.barbershop.value.email != authenticatedEmail) {
      // Email mismatch, revert to the old authenticated email in Firestore and Firebase
      await _revertEmailChange(
          authenticatedEmail, barbershopController.barbershop.value.email);
    } else {
      // Successfully updated the email
      ToastNotif(
        message: 'Email successfully updated.',
        title: 'Success',
      ).showSuccessNotif(Get.context!);
      Get.back();
    }
  }

  // Revert the email change in Firestore and Firebase Authentication
  Future<void> _revertEmailChange(
      String authenticatedEmail, String firestoreEmail) async {
    // Revert email in Firestore
    await barbershopRepository
        .updateBarbershopSingleField({'email': authenticatedEmail});

    // Revert email in Firebase Authentication
    await authrepo.changeUserEmail(authenticatedEmail);

    ToastNotif(
      message:
          'Email verification not completed. Email reverted to the original authenticated email.',
      title: 'Error',
    ).showErrorNotif(Get.context!);
  }
}

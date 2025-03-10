import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../views/email_verification/email_success.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instace => Get.find();

  //======================================= Send Email Whenever page appears & Set timer for auto redirect
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  //======================================= Send Email Verification Link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      ToastNotif(message: 'Please check your email.', title: 'Email Sent!')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: e.toString(), title: 'Oh Snap!')
          .showErrorNotif(Get.context!);
    }
  }

  //======================================= Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => const EmailSuccess());
      }
    });
  }

  //======================================= Manually check if Email Verified
  checkEmailVerificationStatus() async {
    final currenUser = FirebaseAuth.instance.currentUser;
    if (currenUser != null && currenUser.emailVerified) {
      Get.off(() => const EmailSuccess());
    }
  }
}

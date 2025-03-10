import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../views/forgot_pass/password_reset.dart';
import '../signup_controller/network_manager.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  //======================================= Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  //======================================= Send reset password Email
  sendPasswordResetEmail() async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog(
          'Processing your request...', 'assets/images/animation.json');

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Toast Succes
      ToastNotif(
              message: 'Email Sent, Email link sent to reset your password',
              title: 'Email Sent!')
          .showSuccessNotif(Get.context!);

      // Redirect
      Get.to(() => PasswordReset(
            email: email.text.trim(),
          ));
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();
      ToastNotif(message: e.toString(), title: 'Oh Snap!')
          .showErrorNotif(Get.context!);
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog(
          'Processing your request...', 'assets/images/animation.json');

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Toast Succes
      ToastNotif(
              message: 'Email Sent, Email link sent to reset your password',
              title: 'Email Sent!')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();
      ToastNotif(message: e.toString(), title: 'Oh Snap!')
          .showErrorNotif(Get.context!);
    }
  }
}

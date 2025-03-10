import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../signup_controller/network_manager.dart';

class SigninController extends GetxController {
  //======================================= Variables
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final rememberMe = true.obs;

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  //======================================= Email and Password Sign In
  Future<void> emailAndPasswordSignIn() async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog(
          'Signing you in...', 'assets/images/animation.json');

      //Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      //Form Validation
      if (!signInFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      //Save Data if Remember Me is tapped
      if (!rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      //Sign In using Email and Password Authentication
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Redirect Page
      AuthenticationRepository.instance.pageRedirect();
    } catch (e) {
      FullScreenLoader.stopLoading();
      ToastNotif(message: e.toString(), title: 'Oh Snap!')
          .showErrorNotif(Get.context!);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../../../data/repository/customer_repo/customer_repo.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../data/models/user_authenthication_model/customer_model.dart';
import '../../views/email_verification/email_verification.dart';
import 'network_manager.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //======================================= Variables
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  //======================================= SignUp

  void signUp() async {
    try {
      //======================================= Start Loading
      FullScreenLoader.openLoadingDialog(
          'We are processing your information...',
          'assets/images/animation.json');

      //======================================= Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      //======================================= Form Validation
      if (!signUpFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      //======================================= Privacy Policy

      //======================================= Register User and save data to Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      //======================================= Save Authenticated user data to Firebase Firestore
      final newCustomer = CustomerModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        profileImage: '',
        phoneNo: phone.text.trim(),
        role: 'customer',
        createdAt: DateTime.now(),
        existing: false,
      );

      final userRepository = Get.put(CustomerRepository());
      await userRepository.saveCustomerData(newCustomer);

      //======================================= remove loader
      FullScreenLoader.stopLoading();

      //======================================= Show Toast Success
      ToastNotif(
              message:
                  'Your account has been created! Verify email to continue',
              title: 'Verify your Email!')
          .showSuccessNotif(Get.context!);

      //======================================= Move to Verify Email Page
      Get.to(() => EmailVerification(email: email.text.trim()));
    } catch (e) {
      //======================================= remove loader
      FullScreenLoader.stopLoading();

      //======================================= Show Error to User
      ToastNotif(message: e.toString(), title: 'Oh Snap!')
          .showErrorNotif(Get.context!);
    }
  }
}

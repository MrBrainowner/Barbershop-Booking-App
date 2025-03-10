import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/validators/validators.dart';
import '../../controllers/forget_password_controller/forget_password_controller.dart';
import '../sign_in/sign_in_widgets/textformfield.dart';

class ForgotPass extends StatelessWidget {
  const ForgotPass({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    final validator = Get.put(ValidatorController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Forgot Password',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 15),
            Text(
              'Enter your email and we will send you a password reset link',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 15),
            Form(
              key: controller.forgetPasswordFormKey,
              child: MyTextField(
                controller: controller.email,
                validator: validator.validateEmail,
                keyboardtype: TextInputType.emailAddress,
                labelText: 'Email',
                obscureText: false,
                icon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => controller.sendPasswordResetEmail(),
                      child: const Text('Submit')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

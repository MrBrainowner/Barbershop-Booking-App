import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

import '../../controllers/forget_password_controller/forget_password_controller.dart';
import '../sign_in/sign_in_page.dart';

class PasswordReset extends StatelessWidget {
  const PasswordReset({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const SignInPage()),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const iconoir.SendMail(
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Password Reset Email Sent',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'We have sent you a reset link to your email.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () =>
                                Get.offAll(() => const SignInPage()),
                            child: const Text('Done')),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            onPressed: () => ForgetPasswordController.instance
                                .resendPasswordResetEmail(email),
                            child: const Text('Resend Email')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

import '../../../../utils/validators/validators.dart';
import '../../controllers/signin_controller/signin_controller.dart';
import '../forgot_pass/forgot_pass.dart';
import '../sign_up/sign_up_page.dart';
import 'sign_in_widgets/textformfield.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final controller = Get.put(SigninController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  iconoir.UserSquare(
                    color: Theme.of(context).primaryColor,
                    height: 60,
                  ),
                  const SizedBox(height: 20),
                  Text('Sign In To Your Account',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 20),
                  Form(
                      key: controller.signInFormKey,
                      child: Column(
                        children: [
                          MyTextField(
                            controller: controller.email,
                            keyboardtype: TextInputType.emailAddress,
                            validator: (value) =>
                                validator.validateEmail(value),
                            labelText: 'Email',
                            obscureText: false,
                            icon: const Icon(Icons.email_outlined),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => MyTextField(
                              suffixIcon: IconButton(
                                  onPressed: () => controller.hidePassword
                                      .value = !controller.hidePassword.value,
                                  icon: Icon(controller.hidePassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.remove_red_eye_outlined)),
                              controller: controller.password,
                              keyboardtype: TextInputType.visiblePassword,
                              validator: (value) =>
                                  validator.validateEmpty(value),
                              labelText: 'Password',
                              obscureText: controller.hidePassword.value,
                              icon: const Icon(Icons.lock_outline),
                            ),
                          ),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  GestureDetector(
                                    onTap: () => controller.rememberMe.value =
                                        !controller.rememberMe.value,
                                    child: Icon(controller.rememberMe.value
                                        ? Icons.check_box_outline_blank_outlined
                                        : Icons.check_box),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text('Remember Me?')
                                ]),
                                TextButton(
                                    style: const ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                            EdgeInsets.all(0))),
                                    onPressed: () =>
                                        Get.to(() => const ForgotPass()),
                                    child: Text(
                                      'Forgot Password?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () =>
                                        controller.emailAndPasswordSignIn(),
                                    child: const Text('Sign In')),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                    onPressed: () =>
                                        Get.to(() => const SignUpPage()),
                                    child: const Text('Create An Account')),
                              ),
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       child: Divider(
                  //         thickness: 0.5,
                  //         color: Theme.of(context).primaryColor,
                  //         endIndent: 10,
                  //       ),
                  //     ),
                  //     const Text('Or continue with'),
                  //     Flexible(
                  //       child: Divider(
                  //         thickness: 0.5,
                  //         indent: 10,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       child: OutlinedButton(
                  //           onPressed: () =>
                  //               Get.off(() => const BottomNavBarbershop()),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               iconoir.Facebook(
                  //                   color: Theme.of(context).primaryColor),
                  //               const SizedBox(width: 10),
                  //               const Text('Facebook')
                  //             ],
                  //           )),
                  //     ),
                  //     const SizedBox(width: 15),
                  //     Flexible(
                  //       flex: 1,
                  //       child: OutlinedButton(
                  //           onPressed: () {},
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               iconoir.GoogleCircle(
                  //                   color: Theme.of(context).primaryColor),
                  //               const SizedBox(width: 10),
                  //               const Text('Google')
                  //             ],
                  //           )),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

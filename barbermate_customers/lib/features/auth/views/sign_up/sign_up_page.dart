import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/validators/validators.dart';
import '../../controllers/signup_controller/sign_up_controller.dart';
import '../sign_in/sign_in_widgets/textformfield.dart';
// import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final controller = Get.put(SignUpController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create An Account',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                Form(
                  key: controller.signUpFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              validator: (value) =>
                                  validator.validateEmpty(value),
                              controller: controller.firstName,
                              labelText: 'First Name',
                              obscureText: false,
                              icon: const Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: MyTextField(
                              validator: (value) =>
                                  validator.validateEmpty(value),
                              controller: controller.lastName,
                              labelText: 'Last Name',
                              obscureText: false,
                              icon: const Icon(Icons.person_outline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: controller.phone,
                        validator: (value) =>
                            validator.validatePhoneNumber(value),
                        keyboardtype: TextInputType.number,
                        labelText: 'Phone',
                        obscureText: false,
                        icon: const Icon(Icons.phone),
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: controller.email,
                        validator: (value) => validator.validateEmail(value),
                        keyboardtype: TextInputType.emailAddress,
                        labelText: 'Email',
                        obscureText: false,
                        icon: const Icon(Icons.email_outlined),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => MyTextField(
                          suffixIcon: IconButton(
                              onPressed: () => controller.hidePassword.value =
                                  !controller.hidePassword.value,
                              icon: Icon(controller.hidePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.remove_red_eye_outlined)),
                          controller: controller.password,
                          validator: (value) =>
                              validator.validatePassword(value),
                          labelText: 'Password',
                          obscureText: controller.hidePassword.value,
                          icon: const Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => MyTextField(
                          suffixIcon: IconButton(
                              onPressed: () => controller.hidePassword.value =
                                  !controller.hidePassword.value,
                              icon: Icon(controller.hidePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.remove_red_eye_outlined)),
                          validator: (value) =>
                              validator.validateConfirmPassword(
                                  value, controller.password.text),
                          labelText: 'Confirm Password',
                          obscureText: controller.hidePassword.value,
                          icon: const Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () => controller.signUp(),
                                child: const Text('Create Account')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                //     const Text('Or Create with'),
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
                //           onPressed: () {},
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
                // ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

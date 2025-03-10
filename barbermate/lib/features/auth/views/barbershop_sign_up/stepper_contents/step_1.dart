import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/signup_controller/barbershop_sign_up_controller.dart';
import '../../sign_in/sign_in_widgets/textformfield.dart';

class Step1 extends StatelessWidget {
  const Step1({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final controller = Get.put(BarbershopSignUpController());
    return Column(
      children: [
        Form(
          key: controller.signUpFormKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      validator: (value) => validator.validateEmpty(value),
                      controller: controller.firstName,
                      labelText: 'First Name',
                      obscureText: false,
                      icon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: MyTextField(
                      validator: (value) => validator.validateEmpty(value),
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
                controller: controller.email,
                validator: (value) => validator.validateEmail(value),
                keyboardtype: TextInputType.emailAddress,
                labelText: 'Email',
                obscureText: false,
                icon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: controller.phone,
                validator: (value) => validator.validatePhoneNumber(value),
                keyboardtype: TextInputType.number,
                labelText: 'Phone',
                obscureText: false,
                icon: const Icon(Icons.phone),
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
                  validator: (value) => validator.validatePassword(value),
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
                  validator: (value) => validator.validateConfirmPassword(
                      value, controller.password.text),
                  labelText: 'Confirm Password',
                  obscureText: controller.hidePassword.value,
                  icon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

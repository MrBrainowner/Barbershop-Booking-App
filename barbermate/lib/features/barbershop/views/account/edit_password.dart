import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbershopEditPassword extends StatelessWidget {
  const BarbershopEditPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final BarbershopController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: controller.key,
              child: Column(
                children: [
                  const Text('Update Password'),
                  const SizedBox(height: 20),
                  Obx(
                    () => MyTextField(
                      suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value =
                              !controller.hidePassword.value,
                          icon: Icon(controller.hidePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye_outlined)),
                      controller: controller.currentPasswordController,
                      validator: (value) => validator.validatePassword(value),
                      labelText: 'Old Password',
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
                      controller: controller.newPasswordController,
                      validator: (value) => validator.validatePassword(value),
                      labelText: 'New Password',
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
                          value, controller.newPasswordController.text),
                      labelText: 'Confirm Password',
                      obscureText: controller.hidePassword.value,
                      icon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (!controller.key.currentState!.validate()) {
                            ToastNotif(
                                    message:
                                        'Make sure password is correct and matching',
                                    title: 'Opss!')
                                .showWarningNotif(context);
                          } else {
                            ConfirmCancelPopUp.showDialog(
                                context: context,
                                title: 'Update Password?',
                                description:
                                    'Are you sure you want to update your password?',
                                textConfirm: 'Confirm',
                                textCancel: 'Cancel',
                                onConfirm: () async {
                                  await controller.changePassword();
                                  Get.back();
                                });
                          }
                        },
                        child: const Text('Update')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

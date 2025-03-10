import 'package:barbermate_customers/common/widgets/toast.dart';
import 'package:barbermate_customers/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate_customers/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate_customers/utils/popups/confirm_cancel_pop_up.dart';
import 'package:barbermate_customers/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerEditPassword extends StatelessWidget {
  const CustomerEditPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final CustomerController controller = Get.find();

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
              key: controller.updateKey,
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
                          if (!controller.updateKey.currentState!.validate()) {
                            ToastNotif(
                                    message:
                                        'Please make sure the password is not empty and matching',
                                    title: 'Opss!')
                                .showWarningNotif(context);
                          } else {
                            ConfirmCancelPopUp.showDialog(
                                context: context,
                                title: 'Updte Password?',
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

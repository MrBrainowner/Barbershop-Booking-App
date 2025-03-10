import 'package:barbermate_customers/common/widgets/toast.dart';
import 'package:barbermate_customers/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate_customers/features/customer/controllers/change_email_controller/change_email_controller.dart';
import 'package:barbermate_customers/utils/popups/confirm_cancel_pop_up.dart';
import 'package:barbermate_customers/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerEditEmail extends StatelessWidget {
  const CustomerEditEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final ChangeEmailController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.updateKey,
            child: Column(
              children: [
                const Text('Update Email'),
                const SizedBox(height: 20),
                MyTextField(
                  controller: controller.email,
                  keyboardtype: TextInputType.name,
                  validator: (value) => validator.validateEmpty(value),
                  labelText: 'New Email',
                  obscureText: false,
                  icon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: controller.password,
                  keyboardtype: TextInputType.name,
                  validator: (value) => validator.validateEmpty(value),
                  labelText: 'Enter current password',
                  obscureText: false,
                  icon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (!controller.updateKey.currentState!.validate()) {
                          ToastNotif(
                                  message:
                                      'Please make sure field is not empty',
                                  title: 'Opss!')
                              .showWarningNotif(context);
                        } else {
                          ConfirmCancelPopUp.showDialog(
                              context: context,
                              title: 'Updte Email?',
                              description:
                                  'Are you sure you want to update your email?',
                              textConfirm: 'Confirm',
                              textCancel: 'Cancel',
                              onConfirm: () async {
                                controller.changeEmailProcess(
                                    controller.password.text.trim(),
                                    controller.email.text.trim());
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
    );
  }
}

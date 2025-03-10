import 'package:barbermate_customers/common/widgets/toast.dart';
import 'package:barbermate_customers/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate_customers/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate_customers/utils/popups/confirm_cancel_pop_up.dart';
import 'package:barbermate_customers/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerEditNumber extends StatelessWidget {
  const CustomerEditNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final CustomerController controller = Get.find();

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
                const Text('Update Phone Number'),
                const SizedBox(height: 20),
                MyTextField(
                  controller: controller.number,
                  keyboardtype: TextInputType.name,
                  validator: (value) => validator.validateEmpty(value),
                  labelText: 'Phone',
                  obscureText: false,
                  icon: const Icon(Icons.phone),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (!controller.updateKey.currentState!.validate()) {
                          ToastNotif(
                                  message:
                                      'Please make sure the field is not empty',
                                  title: 'Opss!')
                              .showWarningNotif(context);
                        } else {
                          ConfirmCancelPopUp.showDialog(
                              context: context,
                              title: 'Updte Phone Number?',
                              description:
                                  'Are you sure you want to update your phone number?',
                              textConfirm: 'Confirm',
                              textCancel: 'Cancel',
                              onConfirm: () async {
                                controller.updateSingleField({
                                  'phone_no': controller.number.text.trim()
                                });
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

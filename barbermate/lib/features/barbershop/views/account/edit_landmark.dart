import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbershopEditLandMark extends StatelessWidget {
  const BarbershopEditLandMark({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final BarbershopController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.key,
            child: Column(
              children: [
                const Text('Update Nearby Landmark'),
                const SizedBox(height: 20),
                MyTextField(
                  controller: controller.landmark,
                  keyboardtype: TextInputType.name,
                  validator: (value) => validator.validateEmpty(value),
                  labelText: 'Nearby Landmark',
                  obscureText: false,
                  icon: const Icon(Icons.house),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (!controller.key.currentState!.validate()) {
                          ToastNotif(
                                  message: 'Field is required', title: 'Opss!')
                              .showWarningNotif(context);
                        } else {
                          ConfirmCancelPopUp.showDialog(
                              context: context,
                              title: 'Update Nearby Landmark?',
                              description:
                                  'Are you sure you want to update nearby landmark?',
                              textConfirm: 'Confirm',
                              textCancel: 'Cancel',
                              onConfirm: () async {
                                await controller.updateSingleFieldBarbershop({
                                  'landMark': controller.landmark.text.trim()
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

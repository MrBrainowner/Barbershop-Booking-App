import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbershopEditBarbershopName extends StatelessWidget {
  const BarbershopEditBarbershopName({super.key});

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
                const Text('Update Barbershop Name'),
                const SizedBox(height: 20),
                MyTextField(
                  controller: controller.barbershopName,
                  keyboardtype: TextInputType.name,
                  validator: (value) => validator.validateEmpty(value),
                  labelText: 'barbershop name',
                  obscureText: false,
                  icon: const Icon(Icons.store),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (!controller.key.currentState!.validate()) {
                          ToastNotif(message: 'Field Required', title: 'Opss!')
                              .showWarningNotif(context);
                        } else {
                          ConfirmCancelPopUp.showDialog(
                              context: context,
                              title: 'Update Barbershop Name?',
                              description:
                                  'Are you sure you want to update your barbershop name?',
                              textConfirm: 'Confirm',
                              textCancel: 'Cancel',
                              onConfirm: () async {
                                await controller.updateSingleFieldBarbershop({
                                  'barbershop_name':
                                      controller.barbershopName.text.trim()
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

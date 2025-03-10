import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/utils/popups/full_screen_loader.dart';
import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BarbershopAccountSetUpBarbershopName extends StatelessWidget {
  const BarbershopAccountSetUpBarbershopName({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final BarbershopController barbershopController = Get.find();
    final deviceStorage = GetStorage();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Text('Set Up Your Barbershop Name',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 30),
                Form(
                  key: barbershopController.key,
                  child: MyTextField(
                    controller: barbershopController.barbershopName,
                    keyboardtype: TextInputType.name,
                    labelText: 'barbershop name',
                    validator: (value) => validator.validateEmpty(value),
                    obscureText: false,
                    icon: const Icon(Icons.store),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Your barbershop name is needed.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (!barbershopController.key.currentState!
                              .validate()) {
                            ToastNotif(
                                    message: 'Please fill up the field',
                                    title: 'Error')
                                .showErrorNotif(context);
                          } else {
                            FullScreenLoader.openLoadingDialog('Setting up...',
                                'assets/images/animation.json');

                            barbershopController.makeBarbershopExist();
                            await barbershopController
                                .updateSingleFieldBarbershop({
                              'barbershop_name': barbershopController
                                  .barbershopName.text
                                  .trim()
                            });
                            Get.offAllNamed('/barbershop/dashboard');
                          }
                        },
                        child: const Text('Continue'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

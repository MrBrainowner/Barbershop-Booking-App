import 'package:barbermate/features/auth/views/account_set_up/barbershop/barbeshop_name.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopAccountSetUpPageLogo extends StatelessWidget {
  const BarbershopAccountSetUpPageLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final BarbershopController barbershopController = Get.find();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text('Set Up Your Barbershop Logo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 30),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Obx(
                  () => ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: barbershopController
                            .barbershop.value.barbershopProfileImage.isEmpty
                        ? const Center(child: Text('Upload Logo'))
                        : Image.network(
                            barbershopController
                                .barbershop.value.barbershopProfileImage,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => barbershopController.uploadImage('Logo'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconoir.MediaImagePlus(),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Upload Logo'),
                    ],
                  )),
              const SizedBox(height: 20),
              Text(
                  'You can skip this step and complete it later in your profile settings.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              Obx(
                () => SizedBox(
                    width: double.infinity,
                    child: barbershopController
                            .barbershop.value.barbershopProfileImage.isEmpty
                        ? ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.grey.shade300)),
                            onPressed: () {},
                            child: const Text('Continue'))
                        : ElevatedButton(
                            onPressed: () async {
                              barbershopController.makeBarbershopExist();
                              Get.to(() =>
                                  const BarbershopAccountSetUpBarbershopName());
                            },
                            child: const Text('Continue'))),
              ),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () {
                        barbershopController.makeBarbershopExist();
                        Get.to(
                            () => const BarbershopAccountSetUpBarbershopName());
                      },
                      child: const Text('Skip for Now')))
            ],
          ),
        ),
      ),
    );
  }
}

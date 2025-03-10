import 'package:barbermate/features/barbershop/views/management/haircut/add.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/haircuts_controller/haircuts_controller.dart';
import '../../widgets/management/haircut_card.dart';

class HaircutManagementPage extends StatelessWidget {
  const HaircutManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HaircutController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manage Haicuts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const HaircutAddPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final haircut = controller.haircuts;
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.haircuts.isEmpty) {
            return const Center(child: Text('No Haircut available.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  mainAxisSpacing: 2, // Spacing between rows
                  crossAxisSpacing: 15, // Spacing between columns
                  childAspectRatio: 0.7,
                  mainAxisExtent: 215 // Aspect ratio for vertical cards
                  ),
              itemCount: controller
                  .haircuts.length, // Replace with dynamic count of barbers
              itemBuilder: (context, index) {
                final haircuts = haircut[index];
                return HaircutCard2(
                  haircut: haircuts,
                );
              },
            );
          }
        }),
      ),
    );
  }
}

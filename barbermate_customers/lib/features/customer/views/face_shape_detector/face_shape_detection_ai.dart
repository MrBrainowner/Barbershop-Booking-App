import 'package:barbermate_customers/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershop_data_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershops_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/detect_face_shape/detect_face_shape_controller.dart';
import 'package:barbermate_customers/features/customer/views/booking/choose_schedule.dart';
import 'package:barbermate_customers/features/customer/views/widgets/suggest_hairstyle/suggest_hairstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:percent_indicator/linear_percent_indicator.dart';

class SuggestHaircutAiPage extends StatelessWidget {
  const SuggestHaircutAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DetectFaceShape controller = Get.find();
    final GetBarbershopsController barbershops = Get.find();
    final BookingController bookingController = Get.find();
    final GetBarbershopDataController barbershoData = Get.find();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Recommend a Hairstyle'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Obx(() => controller.selectedImage.value != null
                          ? Image.file(controller.selectedImage.value!,
                              fit: BoxFit.cover)
                          : const Center(child: Text("No image selected.")))),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await controller.selectImage();
                                },
                                icon: const iconoir.MediaImagePlus(height: 30)),
                            const Text('Gallery'),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await controller.openCamera();
                                },
                                icon: const iconoir.Camera(height: 30)),
                            const Text('Camera'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // Display confidence results for all shapes
                const SizedBox(height: 20),
                Obx(() =>
                    Text("Face Shape: ${controller.faceShapeResult.value}")),
                const SizedBox(height: 10),
                Column(
                  children: [
                    // Oval confidence indicator
                    Obx(() {
                      double ovalConfidence =
                          controller.predictions['Oval'] ?? 0.0;
                      return LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1000,
                        curve: Curves.linear,
                        center: Text("${ovalConfidence.toStringAsFixed(2)}%"),
                        leading: const Text('Oval:'),
                        lineHeight: 20,
                        percent: ovalConfidence / 100,
                        barRadius: const Radius.circular(10),
                        backgroundColor: Colors.grey.shade300,
                        progressColor: Colors.orange.shade200,
                      );
                    }),
                    const SizedBox(height: 5),
                    // Rectangle confidence indicator
                    Obx(() {
                      double rectangleConfidence =
                          controller.predictions['Rectangle'] ?? 0.0;
                      return LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1000,
                        curve: Curves.linear,
                        leading: const Text('Rectangle:'),
                        lineHeight: 20,
                        percent: rectangleConfidence / 100,
                        barRadius: const Radius.circular(10),
                        backgroundColor: Colors.grey.shade300,
                        center:
                            Text("${rectangleConfidence.toStringAsFixed(2)}%"),
                        progressColor: Colors.orange.shade200,
                      );
                    }),
                    const SizedBox(height: 5),
                    // Round confidence indicator
                    Obx(() {
                      double roundConfidence =
                          controller.predictions['Round'] ?? 0.0;
                      return LinearPercentIndicator(
                        percent: roundConfidence / 100,
                        animation: true,
                        animationDuration: 1000,
                        curve: Curves.linear,
                        leading: const Text('Round:'),
                        lineHeight: 20,
                        barRadius: const Radius.circular(10),
                        backgroundColor: Colors.grey.shade300,
                        center: Text("${roundConfidence.toStringAsFixed(2)}%"),
                        progressColor: Colors.orange.shade200,
                      );
                    }),
                    const SizedBox(height: 5),
                    // Square confidence indicator
                    Obx(() {
                      double squareConfidence =
                          controller.predictions['Square'] ?? 0.0;
                      return LinearPercentIndicator(
                        percent: squareConfidence / 100,
                        animation: true,
                        animationDuration: 1000,
                        curve: Curves.linear,
                        leading: const Text('Square:'),
                        lineHeight: 20,
                        barRadius: const Radius.circular(10),
                        backgroundColor: Colors.grey.shade300,
                        center: Text("${squareConfidence.toStringAsFixed(2)}%"),
                        progressColor: Colors.orange.shade200,
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "Recommended Hairstyles:",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // Display face shape description
                    Obx(() => controller.faceShapeDescription.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              controller.faceShapeDescription.value,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.justify,
                            ),
                          )
                        : const SizedBox.shrink()),
                    SizedBox(
                        width: double.infinity,
                        height: 400,
                        child: Obx(() {
                          if (barbershops.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (controller
                              .barbershopCombinedModel.isEmpty) {
                            return const Center(
                                child: Text('No Barbershops available.'));
                          } else {
                            // Create a single list of matching haircuts from all barbershops
                            final allMatchingHaircuts = <HaircutModel>[];

                            for (var barbershopCombined
                                in controller.barbershopCombinedModel) {
                              // Filter haircuts that match the recommended categories for this barbershop
                              final matchingHaircuts =
                                  barbershopCombined.haircuts.where((haircut) {
                                return haircut.category.any((cat) => controller
                                    .recommendedHairstyles
                                    .contains(cat));
                              }).toList();

                              // Add the matching haircuts to the combined list
                              for (var haircut in matchingHaircuts) {
                                allMatchingHaircuts.add(haircut);
                              }
                            }

                            if (allMatchingHaircuts.isEmpty) {
                              return const Center(
                                  child: Text('No matching haircuts found.'));
                            } else {
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 columns
                                  mainAxisSpacing: 15, // Spacing between rows
                                  crossAxisSpacing:
                                      15, // Spacing between columns
                                  childAspectRatio: 0.7,
                                  mainAxisExtent:
                                      230, // Aspect ratio for vertical cards
                                ),
                                itemCount: allMatchingHaircuts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final haircut = allMatchingHaircuts[index];

                                  // Find the barbershop that owns this haircut
                                  final barbershopCombined = controller
                                      .barbershopCombinedModel
                                      .firstWhere((barbershopCombined) {
                                    return barbershopCombined.haircuts
                                        .contains(haircut);
                                  }).obs;

                                  // Pass the haircut and the barbershop to the SuggestHairstyle widget
                                  return GestureDetector(
                                    onTap: () async {
                                      bookingController.selectedHaircut.value =
                                          haircut;
                                      bookingController.chosenBarbershop.value =
                                          barbershopCombined.value.barbershop;
                                      barbershoData.fetchTimeSlots(
                                          barbershopCombined
                                              .value.barbershop.id);

                                      await Get.to(() => ChooseSchedule());
                                    },
                                    child: SuggestHairstyle(
                                      haircut: haircut,
                                      barbershop: barbershopCombined.value,
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        })),
                  ],
                )
              ],
            )),
          ),
        ));
  }
}

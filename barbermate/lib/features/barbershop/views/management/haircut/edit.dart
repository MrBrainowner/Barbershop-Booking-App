import 'dart:io';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate/features/barbershop/views/management/haircut/category_selection_modal.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/validators/validators.dart';
import '../../../../auth/views/sign_in/sign_in_widgets/textformfield.dart';
import '../../../controllers/haircuts_controller/haircuts_controller.dart';

class HaircutEditPage extends StatelessWidget {
  const HaircutEditPage({super.key, required this.haircut});

  final HaircutModel haircut;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HaircutController());
    final validator = Get.put(ValidatorController());
    controller.nameController.text = haircut.name;
    controller.priceController.text = haircut.price.toString();
    controller.selectedCategories.value = haircut.category;
    final categoryController = Get.put(CategorySelectionController());
    categoryController.selectedOptionsList.value = haircut.category;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => controller.resetForm(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Haircut'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.addHaircutFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final XFile? pickedFile =
                          await controller.picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        // Save the image file
                        controller.selectedImage.value = File(pickedFile.path);
                      }
                    },
                    child: Obx(() => Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[
                                300], // Background color when no image is selected
                          ),
                          child: controller.selectedImage.value != null
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image.file(
                                    controller.selectedImage.value!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : haircut.imageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.network(
                                        haircut.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        'No Image Selected',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                        )),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    validator: validator.validateEmpty,
                    controller: controller.nameController,
                    labelText: 'Name',
                    obscureText: false,
                    icon: null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          validator: validator.validateEmpty,
                          controller: controller.priceController,
                          labelText: 'Price',
                          obscureText: false,
                          icon: null,
                          keyboardtype: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selected Categories:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: categoryController.selectedOptionsList
                            .map((category) => Chip(
                                  label: Text(category),
                                  deleteIcon: const Icon(Icons.close),
                                  onDeleted: () {
                                    categoryController.selectedOptionsList
                                        .remove(category);
                                  },
                                ))
                            .toList());
                  }),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            categoryController.showCategorySelectionSheet();
                          },
                          child: const Text('Select Category')),
                    )
                  ]),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              ConfirmCancelPopUp.showDialog(
                                  context: context,
                                  title: 'Delete Hairut?',
                                  description:
                                      'Are you sure you want to delete this haircut?',
                                  textConfirm: 'Confirm',
                                  textCancel: 'Cancel',
                                  onConfirm: () async {
                                    await controller
                                        .deleteHaircut(haircut.id.toString());
                                    Get.back();
                                  });
                            },
                            child: const Text('Delete this Haircut')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                            controller.resetForm();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (categoryController
                                .selectedOptionsList.isEmpty) {
                              controller.selectedCategories.value =
                                  haircut.category;
                              await controller.updateHaircut(haircut);
                            } else {
                              controller.selectedCategories.value =
                                  categoryController.selectedOptionsList;
                              await controller.updateHaircut(haircut);
                            }
                          },
                          child: const Text('Update Haircut'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

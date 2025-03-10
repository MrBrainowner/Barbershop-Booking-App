import 'package:barbermate/common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySelectionController extends GetxController {
  static CategorySelectionController get intance => Get.find();

  var selectedOptionsList = <String>[].obs;
  var selectedOption = ''.obs;

  var options = [
    // Short Haircuts
    'Buzz Cut', // Includes all short, close-shaven cuts
    'Crew Cut', // Classic, military-inspired cut
    'Ivy League', // Similar to crew cut but slightly longer on top

    // Medium-Length Styles
    'Pompadour', // High-volume styles, including modern variations
    'Quiff', // Front-focused, styled up or back
    'Undercut', // Longer on top with shaved or short sides
    'Textured Crop', // Messy or layered crop styles
    'Fringe', // Includes cuts with bangs or fringe
    'Side Part', // Classic side-parted styles, including comb-over and slicked styles
    'Tapered Cuts', // Gradual shortening on the sides, less drastic than fades

    // Curly, Wavy, and Afro Styles
    'Wavy Styles', // Natural wavy or curly haircuts
    'Afro', // Afro-centric styles for natural hair
    'Curly Haircuts', // Curls styled short, medium, or long

    // Edgy and Trendy Styles
    'Mohawk', // Tall strip in the center with shaved sides
    'Faux Hawk', // Shorter, modern version of the mohawk
    'Comb Over', // Side-parted style, often with a fade or undercut

    // Slicked and Swept Styles
    'Swept-Back', // Slicked back or combed-back styles, includes gelled looks
  ].obs;

  void showCategorySelectionSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return Obx(() => CheckboxListTile(
                            title: Text(option),
                            value: selectedOptionsList.contains(option),
                            onChanged: (bool? value) {
                              if (value == true) {
                                // Enforce max of 3 selections
                                if (selectedOptionsList.length < 3) {
                                  selectedOptionsList.add(option);
                                } else {
                                  // Display a toast or snackbar if limit is reached

                                  ToastNotif(
                                          message:
                                              'You can only select up to 3 categories',
                                          title: 'Opss!')
                                      .showWarningNotif(context);
                                }
                              } else {
                                selectedOptionsList.remove(option);
                              }
                            },
                          ));
                    },
                  )),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

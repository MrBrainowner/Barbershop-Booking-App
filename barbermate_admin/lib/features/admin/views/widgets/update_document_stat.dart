import 'package:barbermate_admin/common/widgets/toast.dart';
import 'package:barbermate_admin/data/models/barbershops_verfication_model/document_model.dart';
import 'package:barbermate_admin/features/admin/controllers/barbershop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateBarbershopDocumentStatusToHoldWidget {
  // Static method to show the customized bottom sheet with checkboxes and text field
  static void showBottomSheet({
    required BuildContext context, // Add context as a required parameter
    required String title,
    required String description,
    required String textConfirm,
    void Function()? onConfirm,
    required String textCancel,
    required String barbershopId,
    required String barbershopFCM,
    required String stat,
    required BarbershopDocumentModel matchingDocument,
  }) {
    // Controllers for TextField and Checkbox states
    TextEditingController textController = TextEditingController();
    final BarbershopController controller = Get.find();

    // Define a list of reasons with checkbox status
    List<Map<String, dynamic>> reasons = [
      {'label': 'Invalid Document', 'selected': false.obs},
      {'label': 'Expired Document', 'selected': false.obs},
    ];

    // Show a scrollable bottom sheet
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), // Curved edges
          topRight: Radius.circular(20), // Curved edges
        ),
        child: Container(
          color: Colors
              .white, // Set the background color to white or any color of your choice
          padding: const EdgeInsets.all(15.0),
          constraints: BoxConstraints(maxHeight: 500), // Set max height
          child: Column(
            children: [
              // Main content (Title, Description, Checkboxes, and TextField)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge, // Use context here
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium, // Use context here
                      ),
                      const SizedBox(height: 25),

                      // Generate checkboxes from the list of reasons
                      for (var reason in reasons)
                        Row(
                          children: [
                            Obx(() {
                              return Checkbox(
                                value: reason['selected'].value,
                                onChanged: (bool? newValue) {
                                  reason['selected'].value = newValue ?? false;
                                },
                              );
                            }),
                            Flexible(child: Text(reason['label'])),
                          ],
                        ),

                      const SizedBox(height: 15),

                      // Text Field
                      TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          labelText: 'Additional Notes',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),

              // Container for Cancel and Confirm buttons (Light Grey background)
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.grey[200], // Light grey color
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back(); // Close the bottom sheet when cancelled
                        },
                        child: Text(
                          textCancel, // Use passed cancel text
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Confirm Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Collect selected reasons
                          List<String> selectedReasons = [];
                          for (var reason in reasons) {
                            if (reason['selected'].value) {
                              selectedReasons.add(reason['label']);
                            }
                          }

                          if (selectedReasons.isEmpty) {
                            // Show Toast error if no checkbox is selected
                            ToastNotif(
                              message: 'Please select at least one reason.',
                              title: 'Error',
                            ).showErrorNotif(Get.context!);
                          } else {
                            // Capture the additional notes
                            String notes = textController.text;

                            // Perform the confirm action
                            if (onConfirm != null) {}

                            controller.updateDocumentStatus(
                                matchingDocument,
                                stat,
                                notes,
                                selectedReasons,
                                barbershopId,
                                barbershopFCM.toString());

                            controller.loadDocuments(barbershopId);
                            Get.back();
                          }
                        },
                        child: Text(
                          textConfirm, // Use passed confirm text
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true, // Allow the bottom sheet to be scrollable
    );
  }
}

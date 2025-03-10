import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmCancelPopUp {
  // Static method to show the customized dialog
  static void showDialog({
    required BuildContext context, // Add context as a required parameter
    required String title,
    required String description,
    required String textConfirm,
    void Function()? onConfirm,
    required String textCancel,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Adjust the roundness here
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    Theme.of(context).textTheme.bodyLarge, // Use context here
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style:
                    Theme.of(context).textTheme.bodyMedium, // Use context here
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text(textCancel), // Use passed cancel text
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          onConfirm ?? Get.back, // Handle confirm or close
                      child: Text(textConfirm), // Use passed confirm text
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

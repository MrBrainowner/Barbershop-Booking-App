import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/timeslot_controller/timeslot_controller.dart';

class OpenAndCloseHours extends StatelessWidget {
  const OpenAndCloseHours({super.key});

  @override
  Widget build(BuildContext context) {
    final TimeSlotController controller = Get.find();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text("Add Open Hours",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: controller.selectedOpenStartTime.value,
                        );
                        if (selectedTime != null) {
                          controller.setOpenTime(selectedTime);
                        }
                      },
                      child: const Text('Open'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: controller.selectedCloseEndTime.value,
                        );
                        if (selectedTime != null) {
                          controller.setCloseTime(selectedTime);
                        }
                      },
                      child: const Text('Closed'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(
                () => Text(
                    '${controller.selectedOpenStartTime.value.format(context)} - ${controller.selectedCloseEndTime.value.format(context)}'),
              ),
              const SizedBox(height: 20),
              Obx(
                () => controller.openHours.value.isEmpty
                    ? const Text('Please set your Open Hours')
                    : Column(
                        children: [
                          const Text('Open Hours:'),
                          Text(
                            controller.openHours.value,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Set Open Hours',
                        description: 'Set this time frame as your open hours?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          // Format the open and close hours into a single string
                          String openToClose =
                              '${controller.selectedOpenStartTime.value.format(context)} to ${controller.selectedCloseEndTime.value.format(context)}';

                          // Send the formatted string to the controller
                          controller.updateOpenHours(openToClose);
                          Get.back();
                        });
                  },
                  child: const Text('Save'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../controllers/timeslot_controller/timeslot_controller.dart';

class AddCreateTimeSlot extends StatelessWidget {
  const AddCreateTimeSlot({super.key});

  @override
  Widget build(BuildContext context) {
    final TimeSlotController controller = Get.find();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.timeSlots.isEmpty) {
                return const Center(child: Text('No Timeslots available.'));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 3,
                    ),
                    itemCount: controller.timeSlots.length,
                    itemBuilder: (context, index) {
                      final timeSlot = controller.timeSlots[index];
                      return GestureDetector(
                        onTap: () =>
                            showEditDeleteModal(context, controller, timeSlot),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1),
                          ),
                          child: Center(
                            child: Text(
                              (TimeSlotModel.formatTimeRange(
                                  timeSlot.startTime, timeSlot.endTime)),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (controller.openHours.value.isEmpty) {
            ToastNotif(
                message: 'You need to add open hours irst', title: 'Opss!');
          } else {
            showAddTimeSlotModal(context, controller);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void showAddTimeSlotModal(BuildContext context, TimeSlotController controller) {
  Get.bottomSheet(
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width:
            double.infinity, // Makes the bottom sheet take the available width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Add Time Slot",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      controller.selectedStartTime.value =
                          (await showTimePicker(
                              context: context, initialTime: TimeOfDay.now()))!;
                    },
                    child: const Text("Select Start Time"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      controller.selectedEndTime.value = (await showTimePicker(
                          context: context, initialTime: TimeOfDay.now()))!;
                    },
                    child: const Text("Select End Time"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Center(
                            child: Obx(
                      () => Text(
                          'Selected TimeSlot: ${TimeSlotModel.formatTime(controller.selectedStartTime.value)} - ${TimeSlotModel.formatTime(controller.selectedEndTime.value)}'),
                    )))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  ConfirmCancelPopUp.showDialog(
                      context: context,
                      title: 'Add Time Slot',
                      description:
                          'Are you sure you want to add this time slot?',
                      textConfirm: 'Confirm',
                      textCancel: 'Cancel',
                      onConfirm: () async {
                        final timeSlot = TimeSlotModel(
                            startTime: controller.selectedStartTime.value,
                            endTime: controller.selectedEndTime.value,
                            createdAt: DateTime.now() // Default for new slots
                            );
                        await controller.createTimeSlot(timeSlot);
                        Get.back();
                      });
                },
                child: const Text("Add Time Slot"),
              ),
            ),
          ],
        ),
      ),
    ),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );
}

void showEditDeleteModal(BuildContext context, TimeSlotController controller,
    TimeSlotModel timeSlot) {
  Get.bottomSheet(
    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double
              .infinity, // Makes the bottom sheet take the available width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit/Delete Time Slot",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(child: Center(child: Text(timeSlot.schedule)))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.selectedStartTime.value =
                            (await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now()))!;
                      },
                      child: const Text("Edit Start Time"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.selectedEndTime.value =
                            (await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now()))!;
                      },
                      child: const Text("Edit End Time"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Obx(
                      () => Text(
                        'Selected Time: ${TimeSlotModel.formatTime(controller.selectedStartTime.value)} - ${TimeSlotModel.formatTime(controller.selectedEndTime.value)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Edit Time Slot',
                        description: 'Save changes to this time slot?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          await controller.updateTimeSlot(
                              timeSlot.id.toString(),
                              controller.selectedStartTime.value,
                              controller.selectedEndTime.value);
                          Get.back();
                        });
                  },
                  child: const Text("Save Changes"),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Delete Time Slot',
                        description:
                            'Are you sure you want to delete this time slot?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          await controller
                              .deleteTimeSlot(timeSlot.id.toString());
                          Get.back();
                        });
                  },
                  child: const Text("Delete Time Slot"),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );
}

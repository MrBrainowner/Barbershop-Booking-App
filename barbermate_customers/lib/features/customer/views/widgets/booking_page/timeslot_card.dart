import 'package:barbermate_customers/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/timeslot_model/timeslot_model.dart';

class TimeSlotCard extends StatelessWidget {
  const TimeSlotCard({
    super.key,
    required this.timeSlot,
  });

  final TimeSlotModel timeSlot;

  @override
  Widget build(BuildContext context) {
    final BookingController controller =
        Get.find(); // Get the instance of CustomerBookingController

    return GestureDetector(
      onTap: () {
        if (controller.isTimeSlotSelectable(timeSlot)) {
          controller
              .selectTimeSlot(timeSlot); // Select the time slot when tapped
        }
      },
      child: Obx(() {
        bool isSelected = controller.selectedTimeSlot.value == timeSlot;
        bool isSelectable = controller.isTimeSlotSelectable(
            timeSlot); // Check if the time slot is selectable

        return Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : (isSelectable ? Colors.blue.shade50 : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1),
          ),
          child: Center(
            child: Text(
              TimeSlotModel.formatTimeRange(
                  timeSlot.startTime, timeSlot.endTime),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).primaryColor),
            ),
          ),
        );
      }),
    );
  }
}

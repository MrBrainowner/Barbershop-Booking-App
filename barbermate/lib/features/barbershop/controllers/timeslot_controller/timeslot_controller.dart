import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../../data/repository/barbershop_repo/timeslot_repository.dart';

class TimeSlotController extends GetxController {
  static TimeSlotController get instance => Get.find();

  final TimeslotRepository _repository = Get.find();

  //variables
  var isLoading = false.obs;
  var number = 1.obs;

  //================================================== time slots

  RxList<TimeSlotModel> timeSlots = <TimeSlotModel>[].obs;
  var selectedStartTime = TimeOfDay.now().obs;
  var selectedEndTime = TimeOfDay.now().obs;

  //================================================== open hours

  var selectedOpenStartTime = TimeOfDay.now().obs;
  var selectedCloseEndTime = TimeOfDay.now().obs;

  //================================================== available days

  RxList<DateTime> disabledDates =
      <DateTime>[].obs; // Store disabled specific dates
  RxList<bool> disabledDaysOfWeek =
      List.filled(7, false).obs; // Store disabled recurring days

  var openHours = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchTimeSlots();
    await fetchOpenHours();
  }

  //============================================================================ Open Hours

  void setOpenTime(TimeOfDay time) {
    selectedOpenStartTime.value = time;
  }

  void setCloseTime(TimeOfDay time) {
    selectedCloseEndTime.value = time;
  }

  Future<void> fetchOpenHours() async {
    try {
      final data = await _repository.fetchOpenHours();
      openHours.value = data!;
      _setInitialTimes();
    } catch (e) {
      throw 'error fetching $e';
    }
  }

  // Parse the open hours string into TimeOfDay objects
  void _setInitialTimes() {
    String startTime = '';
    String endTime = '';

    if (openHours.value.isEmpty) {
      // Split the openHours string into start and end times
      List<String> times = openHours.value.split(' to ');
      if (times.length == 2) {
        startTime = times[0]; // The first part is the start time
        endTime = times[1]; // The second part is the end time
      }
    }

    // Set initial start and end times
    selectedOpenStartTime.value = _parseTime(startTime);
    selectedCloseEndTime.value = _parseTime(endTime);
  }

  // Function to parse time strings like '8:00 AM' or '5:00 PM' into TimeOfDay
  TimeOfDay _parseTime(String time) {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final period = parts[1].toLowerCase(); // AM or PM

    int hour24 = hour;
    if (period == 'pm' && hour != 12) {
      hour24 += 12; // Convert PM times to 24-hour format
    } else if (period == 'am' && hour == 12) {
      hour24 = 0; // Convert 12 AM to 0 hours
    }

    return TimeOfDay(hour: hour24, minute: minute);
  }

  Future<void> updateOpenHours(String openHours) async {
    try {
      await _repository.updateOpenHours(openHours);
      ToastNotif(message: 'Open hours updated successfully', title: 'Success')
          .showSuccessNotif(Get.context!);
      fetchOpenHours();
    } catch (e) {
      ToastNotif(message: 'Failed to update open hours: $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  //============================================================================ Time Slots

  bool isTimeSlotConflict(TimeOfDay startTime, TimeOfDay endTime) {
    for (var timeSlot in timeSlots) {
      final existingStart = timeSlot.startTime;
      final existingEnd = timeSlot.endTime;

      // Check if the new slot is identical to an existing slot (same start and end times)
      if (startTime == existingStart && endTime == existingEnd) {
        return true;
      }
    }
    return false;
  }

  // Create a time slot
  Future<void> createTimeSlot(TimeSlotModel timeSlot) async {
    isLoading.value = true;
    try {
      // Check for conflicts
      if (isTimeSlotConflict(timeSlot.startTime, timeSlot.endTime)) {
        ToastNotif(
                message: 'Time slot conflicts with an existing slot.',
                title: 'Error')
            .showErrorNotif(Get.context!);
        return;
      }

      // Proceed to create the time slot if no conflict
      await _repository.createTimeSlot(timeSlot);
      await fetchTimeSlots();
      ToastNotif(message: 'Time slot created successfully.', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: e.toString(), title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  // Update a time slot
  Future<void> updateTimeSlot(
      String timeSlotId, TimeOfDay startTime, TimeOfDay endTime) async {
    isLoading.value = true;
    try {
      await _repository.updateTimeSlot(timeSlotId, startTime, endTime);
      ToastNotif(message: 'Time slot updated successfully.', title: 'Success');

      await fetchTimeSlots();
      Get.back();
    } catch (e) {
      ToastNotif(message: e.toString(), title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a time slot
  Future<void> deleteTimeSlot(String timeSlotId) async {
    isLoading.value = true;
    try {
      await _repository.deleteTimeSlot(timeSlotId);
      ToastNotif(message: 'Time slot deleted successfully.', title: 'Success')
          .showSuccessNotif(Get.context!);

      await fetchTimeSlots();
      Get.back();
    } catch (e) {
      ToastNotif(message: e.toString(), title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch TimeSlot
  Future<void> fetchTimeSlots() async {
    isLoading.value = true;
    try {
      timeSlots.value = await _repository.fetchTimeSlots();
    } catch (e) {
      ToastNotif(message: 'Error Fetching TimeSlots', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }
}

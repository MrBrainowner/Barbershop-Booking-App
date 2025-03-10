import 'dart:async';
import 'package:barbermate_customers/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:barbermate_customers/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GetBarbershopsController extends GetxController {
  static GetBarbershopsController get instace => Get.find();
  final Logger logger = Logger();
  final BarbershopRepository barbershopRepository = Get.find();
  RxList<BarbershopModel> barbershop = <BarbershopModel>[].obs;

  var isLoading = true.obs;
  var error = ''.obs;
  RxBool isOpenNow = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllBarbershops(); // Start listening when the controller is initialized
  }

  Future<void> refreshData() async {
    fetchAllBarbershops();
  }

//======================================================================== open hours logic

  void checkIsOpenNow(String? openHours) {
    if (openHours == null || openHours.isEmpty) {
      isOpenNow.value = false; // Default to closed if unverified
      return;
    }

    final currentTime = TimeOfDay.now();
    final parts = openHours.split(' to ');
    final openTime = _stringToTimeOfDay(parts[0].trim());
    final closeTime = _stringToTimeOfDay(parts[1].trim());

    // Update the observable value
    isOpenNow.value = _isTimeWithinRange(currentTime, openTime, closeTime);
  }

  static TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1].toUpperCase() == 'PM';

    return TimeOfDay(
      hour: isPM ? (hour % 12) + 12 : hour % 12,
      minute: minute,
    );
  }

  static bool _isTimeWithinRange(
      TimeOfDay currentTime, TimeOfDay startTime, TimeOfDay endTime) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

//======================================================================== fetch barbershop & haircuts

  void fetchAllBarbershops() {
    isLoading.value = true;
    // Listen to the customer stream and update the customer value
    barbershopRepository.fetchAllBarbershops().listen(
      (barbershops) {
        barbershop(barbershops); // Update the customer data when it changes
        // Once the first data comes in, stop loading
        if (isLoading.value) {
          isLoading(false);
        }
      },
      onError: (error) {
        // Handle errors
      },
      onDone: () {
        isLoading.value = false; // Stop loading when the stream is done
      },
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  DateTime getNextAvailableDate() {
    DateTime currentDate = DateTime.now();
    while (disabledDaysOfWeek.contains(currentDate.weekday)) {
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return currentDate;
  }

  var disabledDaysOfWeek = [6, 1, 7];
}

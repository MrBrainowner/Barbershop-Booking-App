import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeSlotModel {
  final String? id;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime? createdAt;

  TimeSlotModel({
    this.id,
    required this.startTime,
    required this.endTime,
    this.createdAt,
  });

  static TimeSlotModel empty() {
    return TimeSlotModel(
      id: null,
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay.now(),
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': timeOfDayToString(startTime), // Store time with AM/PM
      'end_time': timeOfDayToString(endTime), // Store time with AM/PM
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory TimeSlotModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TimeSlotModel(
      id: document.id,
      startTime: stringToTimeOfDay(
          data['start_time']), // Convert to TimeOfDay from string
      endTime: stringToTimeOfDay(
          data['end_time']), // Convert to TimeOfDay from string
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  TimeSlotModel copyWith({
    String? id,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? maxBooking,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return TimeSlotModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get schedule => "${formatTime(startTime)} - ${formatTime(endTime)}";

  static String timeOfDayToString(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod; // Convert to 12-hour format for AM/PM
    final minute = time.minute
        .toString()
        .padLeft(2, '0'); // Add leading zero to minute if necessary
    final period = time.period == DayPeriod.am
        ? 'AM'
        : 'PM'; // Get AM/PM based on the period

    return '$hour:$minute $period'; // Format like '9:00 AM'
  }

  static TimeOfDay stringToTimeOfDay(String timeString) {
    // Extract hour, minute, and period (AM/PM) from the string
    final parts = timeString.split(' '); // Splits into ["9:00", "AM"]
    final timeParts = parts[0].split(':'); // Splits "9:00" into ["9", "00"]
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1].toUpperCase() == 'PM'; // Check if PM

    // Convert to 24-hour format if PM
    final adjustedHour = isPM && hour < 12
        ? hour + 12
        : hour == 12 && !isPM
            ? 0
            : hour;

    return TimeOfDay(hour: adjustedHour, minute: minute);
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod; // Convert hour to 12-hour format if it's 0 AM
    final minute = time.minute
        .toString()
        .padLeft(2, '0'); // Add leading zero to minutes if needed
    final period = time.period == DayPeriod.am ? "AM" : "PM"; // Add AM/PM

    return '$hour:$minute $period'; // Format as '9:00 AM' or '9:00 PM'
  }

  static String formatTimeRange(TimeOfDay start, TimeOfDay end) {
    String formatTime(TimeOfDay time) {
      final int hour = time.hour == 0
          ? 12
          : time.hour > 12
              ? time.hour - 12
              : time.hour; // Convert 24-hour format to 12-hour format
      final String minute = time.minute
          .toString()
          .padLeft(2, '0'); // Ensure two digits for minutes
      final String period = time.hour < 12 ? 'AM' : 'PM'; // Determine AM/PM
      return '$hour:$minute $period';
    }

    final String startFormatted = formatTime(start);
    final String endFormatted = formatTime(end);

    return '$startFormatted - $endFormatted';
  }
}

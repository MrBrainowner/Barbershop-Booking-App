import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormatBookingStatus extends GetxController {
  // Helper to map status to colors
  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'done':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getTitle(String title) {
    switch (title.toLowerCase()) {
      case 'done':
        return 'Appointment Complete';
      case 'declined':
        return 'Appointment Declined';
      case 'pending':
        return 'Appointment Pending';
      case 'confirmed':
        return 'Upcoming Appointment';
      case 'canceled':
        return 'Appointment Canceled';
      default:
        return 'Appointment Unknown';
    }
  }
}

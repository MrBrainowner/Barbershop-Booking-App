import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BFormatter extends GetxController {
  static BFormatter get instance => Get.find();

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  DateTime parseDate(String dateString) {
    return DateFormat('MMMM dd, yyyy').parse(dateString);
  }

  String formatTimestamp(Timestamp timestamp) {
    // Convert Firebase Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Define your desired format
    String formattedDate = DateFormat('MMM d, yyyy | h:mma').format(dateTime);

    // Convert AM/PM to lowercase
    formattedDate = formattedDate.replaceAll('AM', 'am').replaceAll('PM', 'pm');

    return formattedDate;
  }

  String formatDateTime(DateTime dateTime) {
    // Define your desired format
    String formattedDate = DateFormat('MMM d, yyyy | h:mma').format(dateTime);

    // Convert AM/PM to lowercase
    formattedDate = formattedDate.replaceAll('AM', 'am').replaceAll('PM', 'pm');

    return formattedDate;
  }

  Timestamp convertDateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  String formatInitial(String? imageUrl, String name) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ""; // Return empty since the imageUrl exists
    }
    return name.isNotEmpty
        ? name[0].toUpperCase()
        : "?"; // Return the first letter of the name
  }
}

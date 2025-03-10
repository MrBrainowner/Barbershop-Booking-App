import 'package:barbermate/data/models/notifications_model/notification_model.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

//=================================================================================
/// Base Notification Card
class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = Get.put(BFormatter());

    return Card(
      elevation: notification.status == 'read' ? 0 : 1,
      color:
          notification.status == 'read' ? Colors.grey.shade100 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                getIcon(notification.type),
                const SizedBox(width: 10),
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color:
                          _getColor(notification.title, notification.status)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(dateFormatter.formatDateTime(notification.createdAt),
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 10),
            Text(notification.message,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

Color _getColor(String title, String status) {
  if (status == 'read') {
    return Colors.grey;
  } else {
    switch (title) {
      case 'Appointment Complete':
        return Colors.green;
      case 'Booking Confirmed':
        return Colors.green;
      case 'Booking Declined':
        return Colors.red;
      case 'New Appointment!':
        return Colors.blue;
      case 'Appointment Canceled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

Widget getIcon(String type) {
  switch (type) {
    case 'appointment_status':
      return const iconoir.InfoCircle();
    case 'booking':
      return const iconoir.Calendar();
    case 'review_prompt':
      return const iconoir.StarHalfDashed();
    default:
      return const iconoir.InfoCircle();
  }
}

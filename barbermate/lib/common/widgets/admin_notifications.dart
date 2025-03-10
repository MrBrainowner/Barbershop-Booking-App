import 'package:barbermate/data/models/notifications_model/notification_model.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

//=================================================================================
/// Base Notification Card
class AdminNotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const AdminNotificationCard({
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
                iconoir.ShopFourTiles(),
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
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'hold':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

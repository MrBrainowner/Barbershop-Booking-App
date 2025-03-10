import 'package:barbermate/common/widgets/admin_notifications.dart';
import 'package:barbermate/common/widgets/notification_template.dart';
import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/barbershop/views/appointments/appointments.dart';
import 'package:barbermate/features/barbershop/views/notifications/details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbershopNotifications extends StatelessWidget {
  const BarbershopNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final BarbershopNotificationController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          try {
            // Optionally rebind the stream to ensure it's still active
            Get.find<BarbershopNotificationController>()
                .bindNotificationsStream();

            // Show a toast or log for user feedback if needed
            // print("Stream reinitialized for notifications.");
          } catch (e) {
            // Handle any potential errors during refresh
            ToastNotif(
              message: 'Error refreshing notifications',
              title: 'Error',
            ).showErrorNotif(Get.context!);
          }
        },
        child: Obx(() {
          // Sort notifications by creation date in descending order
          final sortedNotifications = controller.notifications.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sortedNotifications.length,
            itemBuilder: (context, index) {
              final notification = sortedNotifications[index];
              return GestureDetector(
                  onTap: () async {
                    if (notification.type == 'barbershop-status') {
                      if (notification.reasons != null) {
                        await controller.updateNotifAsRead(notification);
                        Get.to(() => NotificationDetailsPage(
                            title: notification.title,
                            message: notification.message,
                            notes: notification.notes ?? '',
                            reasons: notification.reasons ?? []));
                      } else {
                        await controller.updateNotifAsRead(notification);
                      }
                    } else {
                      Get.off(() => const BarbershopAppointments());
                      await controller.updateNotifAsRead(notification);
                    }
                  },
                  child: notification.type == 'barbershop-status'
                      ? AdminNotificationCard(notification: notification)
                      : NotificationCard(notification: notification));
            },
          );
        }),
      ),
    );
  }
}

import 'package:barbermate_admin/common/widgets/notification_template.dart';
import 'package:barbermate_admin/common/widgets/toast.dart';
import 'package:barbermate_admin/features/admin/controllers/notification_controller.dart';
import 'package:barbermate_admin/features/admin/views/barbershops_acc/barbershop_accounts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminNotificationController controller = Get.find();

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
            Get.find<AdminNotificationController>().bindNotificationsStream();

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
                    await controller.updateNotifAsRead(notification);
                    Get.to(() => const BarbershopAccounts());
                  },
                  child: NotificationCard(notification: notification));
            },
          );
        }),
      ),
    );
  }
}

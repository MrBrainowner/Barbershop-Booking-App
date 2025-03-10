import 'package:barbermate_customers/common/widgets/notification_template.dart';
import 'package:barbermate_customers/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate_customers/features/customer/views/appointments/appointments.dart';
import 'package:barbermate_customers/features/customer/views/banned/banned_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller/notification_controller.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerNotificationController controller = Get.find();
    final CustomerController customerController = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: const [],
        title: const Text('Notifications'),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          controller.listenToNotificationsStream();
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
                    if (customerController.customer.value.status == 'banned' &&
                        notification.type == 'customer-status') {
                      Get.to(() => BannedPage(
                          reasons: notification.reasons ?? [],
                          notes: notification.notes ?? ''));
                      controller.updateNotifAsReadCustomer(notification);
                    } else if (notification.type == 'booking' ||
                        notification.type == 'appointment_status' ||
                        notification.type == 'review_prompt') {
                      Get.off(() => const BarbermateAppointments());
                      controller.updateNotifAsReadCustomer(notification);
                    } else {
                      controller.updateNotifAsReadCustomer(notification);
                    }
                  },
                  child: NotificationCard(notification: notification));
            },
          );
        }),
      ),
    );
  }
}

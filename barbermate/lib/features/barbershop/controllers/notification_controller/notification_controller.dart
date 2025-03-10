import 'dart:async';
import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/models/notifications_model/notification_from_admin.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/data/services/push_notification/push_notification.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../data/models/notifications_model/notification_model.dart';

class BarbershopNotificationController extends GetxController {
  static BarbershopNotificationController get instance => Get.find();

  var isLoading = false.obs;
  var notifications = <NotificationModel>[].obs;
  final NotificationsRepo _repo = Get.find();

  final _notificationServiceRepository = NotificationServiceRepository.instance;
  Rx<AdminNotifications?> notificationAdmin = Rx<AdminNotifications?>(null);

  // Check for unread notifications
  bool get hasUnreadNotifications {
    return notifications
        .any((notification) => notification.status == 'notRead');
  }

  final Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    bindNotificationsStream();
    _initializeFCMToken();
  }

  // fetch notification
  void bindNotificationsStream() {
    isLoading.value = true;

    // Listen to the notifications stream from the repository
    _repo.fetchNotificationsBarbershop().listen(
      (List<NotificationModel> data) {
        // Check for new notifications by comparing the current list with the previous one
        // if (notifications.isNotEmpty) {
        //   for (var newNotification in data) {
        //     // Show a toast for new notifications
        //     if (!notifications.any((n) => n.id == newNotification.id)) {
        //       // Assuming `newNotification.message` holds the notification message
        //       ToastNotif(
        //         message: newNotification.message,
        //         title: 'New Notification',
        //       ).showSuccessNotif(Get.context!);
        //     }
        //   }
        // }

        // Update the lists after showing notifications
        notifications.assignAll(data);
      },
      onError: (error) {
        ToastNotif(message: 'Error Fetching Notifications', title: 'Error')
            .showErrorNotif(Get.context!);
      },
      onDone: () {
        isLoading.value = false;
      },
    );
  }

  Future<void> sendNotifWhenBookingUpdated(
    BookingModel booking,
    String type,
    String title,
    String message,
    String status,
  ) async {
    try {
      await _repo.sendNotifWhenBookingUpdated(
          booking, type, title, message, status);
    } catch (e) {
      ToastNotif(message: 'Error Sending Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> updateNotifAsRead(NotificationModel notif) async {
    try {
      await _repo.updateNotifAsRead(notif);
    } catch (e) {
      ToastNotif(message: 'Error Updating Notifications $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> fetchAdminNotification(String id) async {
    try {
      isLoading.value = true;

      notificationAdmin.value = await _repo.fetchAdminNotif(id);
    } catch (e) {
      notificationAdmin.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Call the repository method for FCM token handling
  Future<void> _initializeFCMToken() async {
    try {
      final String userId = AuthenticationRepository
          .instance.authUser!.uid; // Replace with your user ID
      await _notificationServiceRepository
          .fetchAndSaveFCMTokenBarbershops(userId);
    } catch (e) {
      print('Error initializing FCM token in controller: $e');
    }
  }
}

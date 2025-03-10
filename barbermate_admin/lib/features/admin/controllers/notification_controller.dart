import 'dart:async';
import 'package:barbermate_admin/common/widgets/toast.dart';
import 'package:barbermate_admin/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate_admin/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate_admin/data/services/push_notification/push_notification.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../data/models/notifications_model/notification_model.dart';

class AdminNotificationController extends GetxController {
  static AdminNotificationController get instance => Get.find();

  var isLoading = false.obs;
  var notifications = <AdminNotifications>[].obs;
  final NotificationsRepo _repo = Get.find();
  final _notificationServiceRepository = NotificationServiceRepository.instance;

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
    _repo.fetchNotificationsAdmin().listen(
      (List<AdminNotifications> data) {
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
      String type,
      String barbershopId,
      String title,
      String message,
      String status,
      String barbershopToken) async {
    try {
      await _repo.sendNotifWhenStatusUpdated(type, barbershopId, title, message,
          null, null, status, barbershopToken);
    } catch (e) {
      ToastNotif(message: 'Error Sending Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> updateNotifAsRead(AdminNotifications notif) async {
    try {
      await _repo.updateNotifAsRead(notif);
    } catch (e) {
      ToastNotif(message: 'Error Updating Notifications $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // Call the repository method for FCM token handling
  Future<void> _initializeFCMToken() async {
    try {
      final String userId = AuthenticationRepository
          .instance.authUser!.uid; // Replace with your user ID
      await _notificationServiceRepository.fetchAndSaveFCMTokenAdmin(userId);
    } catch (e) {
      print('Error initializing FCM token in controller: $e');
    }
  }
}

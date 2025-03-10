import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/models/notifications_model/notification_from_admin.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/services/push_notification/push_notification.dart';
import 'package:barbermate/utils/exceptions/firebase_exceptions.dart';
import 'package:barbermate/utils/exceptions/format_exceptions.dart';
import 'package:barbermate/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/notifications_model/notification_model.dart';

class NotificationsRepo extends GetxController {
  static NotificationsRepo get instance => Get.find();
  final _notificationServiceRepository = NotificationServiceRepository.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final userId = Get.put(AuthenticationRepository.instance.authUser?.uid);

  Future<void> updateNotifAsRead(NotificationModel notif) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(userId)
          .collection('Notifications')
          .doc(notif.id)
          .update({'status': 'read'});
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // for barbershop updating the booking status
  Future<void> sendNotifWhenBookingUpdated(
    BookingModel booking,
    String type,
    String title,
    String message,
    String status,
  ) async {
    try {
      final customerNotification = NotificationModel(
        bookingId: booking.id,
        type: type,
        title: title,
        message: message,
        status: status,
        createdAt: DateTime.now(),
        customerId: booking.customerId,
        id: '',
        barbershopId: booking.barberShopId,
      );

      final docRef = await _db
          .collection('Customers')
          .doc(booking.customerId)
          .collection('Notifications')
          .add(customerNotification.toJson());
      final docId = docRef.id;

      await docRef.update({'id': docId});

      await _notificationServiceRepository.sendFCMNotificationToUser(
          token: booking.customerToken, title: title, body: message);
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> sendNotifWhenStatusUpdated(
    String type,
    String barbershopId,
    String title,
    String message,
    List<String>? reasons,
    String status,
  ) async {
    try {
      final barbershopNotification = AdminNotifications(
        title: title,
        message: message,
        status: status,
        createdAt: DateTime.now(),
        id: '',
        type: type,
      );

      // Get all admin documents from the Admins collection
      final adminsSnapshot = await _db.collection('Admins').get();

      // Loop through each admin and perform notification-related actions
      for (final adminDoc in adminsSnapshot.docs) {
        final adminData = adminDoc.data();
        final adminToken = adminData[
            'adminToken']; // Assume the token is stored under the 'token' field

        if (adminToken != null && adminToken.isNotEmpty) {
          // Add notification to the admin's Notifications sub-collection
          final docRef = await _db
              .collection('Admins')
              .doc(adminDoc.id)
              .collection('Notifications')
              .add(barbershopNotification.toJson());
          final docId = docRef.id;

          await docRef.update({'id': docId});

          // Send FCM notification to the admin
          await _notificationServiceRepository.sendFCMNotificationToUser(
            token: adminToken,
            title: title,
            body: message,
          );
        }
      }
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<AdminNotifications> fetchAdminNotif(String id) async {
    try {
      // Fetch the specific document from Firestore
      final documentSnapshot = await _db
          .collection('Barbershops')
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .collection('Notifications')
          .doc(id)
          .get();

      if (documentSnapshot.exists) {
        // Parse the document into an AdminNotifications object
        return AdminNotifications.fromSnapshot(documentSnapshot);
      } else {
        throw 'Notification not found';
      }
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Stream<List<NotificationModel>> fetchNotificationsBarbershop() {
    try {
      return _db
          .collection('Barbershops')
          .doc(userId)
          .collection('Notifications')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return NotificationModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}

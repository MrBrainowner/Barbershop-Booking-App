import 'package:barbermate_admin/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate_admin/data/services/push_notification/push_notification.dart';
import 'package:barbermate_admin/utils/exceptions/firebase_exceptions.dart';
import 'package:barbermate_admin/utils/exceptions/format_exceptions.dart';
import 'package:barbermate_admin/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/notifications_model/notification_model.dart';

class NotificationsRepo extends GetxController {
  static NotificationsRepo get instance => Get.find();
  final _notificationServiceRepository = NotificationServiceRepository.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final userId = Get.put(AuthenticationRepository.instance.authUser?.uid);

  Future<void> updateNotifAsRead(AdminNotifications notif) async {
    try {
      await _db
          .collection('Admins')
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

  Future<void> sendNotifWhenStatusUpdated(
      String type,
      String barbershopId,
      String title,
      String message,
      String? notes,
      List<String>? reasons,
      String status,
      String barbershopToken) async {
    try {
      final barbershopNotification = AdminNotifications(
        title: title,
        message: message,
        status: status,
        notes: notes,
        reasons: reasons,
        createdAt: DateTime.now(),
        id: '',
        type: type,
      );

      final docRef = await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Notifications')
          .add(barbershopNotification.toJson());
      final docId = docRef.id;

      await docRef.update({'id': docId});

      await _notificationServiceRepository.sendFCMNotificationToUser(
          token: barbershopToken, title: title, body: message);
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

  Future<void> sendNotifWhenStatusUpdatedCustomer(
      String type,
      String customerId,
      String title,
      String message,
      String? notes,
      List<String>? reasons,
      String status,
      String customerToken) async {
    try {
      final barbershopNotification = AdminNotifications(
        title: title,
        message: message,
        status: status,
        notes: notes,
        reasons: reasons,
        createdAt: DateTime.now(),
        id: '',
        type: type,
      );

      final docRef = await _db
          .collection('Customers')
          .doc(customerId)
          .collection('Notifications')
          .add(barbershopNotification.toJson());
      final docId = docRef.id;

      await docRef.update({'id': docId});

      await _notificationServiceRepository.sendFCMNotificationToUser(
          token: customerToken, title: title, body: message);
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

  Stream<List<AdminNotifications>> fetchNotificationsAdmin() {
    try {
      return _db
          .collection('Admins')
          .doc(userId)
          .collection('Notifications')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return AdminNotifications.fromSnapshot(
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

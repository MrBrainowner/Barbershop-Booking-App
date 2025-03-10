import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/data/services/push_notification/push_notification.dart';
import 'package:barbermate/data/models/user_authenthication_model/customer_model.dart';
import 'package:barbermate/utils/exceptions/firebase_exceptions.dart';
import 'package:barbermate/utils/exceptions/format_exceptions.dart';
import 'package:barbermate/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/user_authenthication_model/barbershop_model.dart';

class BookingRepo extends GetxController {
  static BookingRepo get instance => Get.find();

  //variables
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final authId = Get.put(AuthenticationRepository.instance.authUser?.uid);
  final bookingNotif = Get.put(NotificationsRepo());

  // accept booking
  Future<void> acceptBooking(String bookingId, String customerId) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(authId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'confirmed'});
      await _db
          .collection('Customers')
          .doc(customerId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'confirmed'});
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

  // reject booking
  Future<void> rejectBooking(String bookingId, String customerId) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(authId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'declined'});
      await _db
          .collection('Customers')
          .doc(customerId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'declined'});
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

  // Stream of bookings for barbershop
  Stream<List<BookingModel>> fetchBookingsBarbershop() {
    return _db
        .collection('Barbershops')
        .doc(authId)
        .collection('Bookings')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return BookingModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  // mark appointment as done
  Future<void> markAsDone(BookingModel booking) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(authId)
          .collection('Bookings')
          .doc(booking.id)
          .update({'status': 'done'});

      await _db
          .collection('Customers')
          .doc(booking.customerId)
          .collection('Bookings')
          .doc(booking.id)
          .update({'status': 'done'});
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

  // cancel booking(barbershops)
  Future<void> cancelBookingForBarbershop(
      String bookingId, String customerId) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(authId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'canceled'});

      await _db
          .collection('Customers')
          .doc(customerId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'canceled'});
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

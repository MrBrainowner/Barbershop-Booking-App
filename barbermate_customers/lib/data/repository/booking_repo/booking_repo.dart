import 'package:barbermate_customers/data/models/booking_model/booking_model.dart';
import 'package:barbermate_customers/data/models/user_authenthication_model/customer_model.dart';
import 'package:barbermate_customers/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate_customers/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate_customers/utils/exceptions/firebase_exceptions.dart';
import 'package:barbermate_customers/utils/exceptions/format_exceptions.dart';
import 'package:barbermate_customers/utils/exceptions/platform_exceptions.dart';
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

  // create booking
  Future<void> addBooking(BookingModel booking, BarbershopModel barbershop,
      CustomerModel customer) async {
    try {
      final docRefBarbershop = await _db
          .collection('Barbershops')
          .doc(booking.barberShopId)
          .collection('Bookings')
          .add(booking.toJson());

      booking.id = docRefBarbershop.id;

      await _db
          .collection('Customers')
          .doc(authId)
          .collection('Bookings')
          .doc(booking.id)
          .set(booking.toJson());

      // Step 10: Update the original booking document with the ID field
      await docRefBarbershop.update({'id': booking.id});
      // Step 11: Send notifications
      await bookingNotif.recieveNotificationCustomerOnly(
          barbershop, customer, booking.id);
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

  // cancel booking(customer)
  Future<void> cancelBooking(BookingModel booking) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(booking.barberShopId)
          .collection('Bookings')
          .doc(booking.id)
          .update({'status': 'canceled'});

      await _db
          .collection('Customers')
          .doc(authId)
          .collection('Bookings')
          .doc(booking.id)
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

  // Stream of bookings for customer
  Stream<List<BookingModel>> fetchBookingsCustomer() {
    return _db
        .collection('Customers')
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
}

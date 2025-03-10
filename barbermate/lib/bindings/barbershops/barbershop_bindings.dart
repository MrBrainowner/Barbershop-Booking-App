import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/documents_verification_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/haircut_repository.dart';
import 'package:barbermate/data/repository/barbershop_repo/timeslot_repository.dart';
import 'package:barbermate/data/repository/booking_repo/booking_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/barbershop/controllers/change_email_controller_barbershop/barbershop_change_email_controller.dart';
import 'package:barbermate/features/barbershop/controllers/haircuts_controller/haircuts_controller.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/barbershop/controllers/review_controller/review_controller.dart';
import 'package:barbermate/features/barbershop/controllers/timeslot_controller/timeslot_controller.dart';
import 'package:barbermate/features/barbershop/controllers/verification_controller/verification_controller.dart';
import 'package:get/get.dart';

class BarbershopBinding extends Bindings {
  @override
  void dependencies() {
    //============================================== repositories
    //barbershop
    Get.lazyPut<BarbershopRepository>(() => BarbershopRepository(),
        fenix: true);
    //notification
    Get.lazyPut<NotificationsRepo>(() => NotificationsRepo(), fenix: true);
    //booking
    Get.lazyPut<BookingRepo>(() => BookingRepo(), fenix: true);
    //reviews
    Get.lazyPut<ReviewRepo>(() => ReviewRepo(), fenix: true);
    //barbers
    Get.lazyPut<HaircutRepository>(() => HaircutRepository(), fenix: true);
    //timeslots
    Get.lazyPut<TimeslotRepository>(() => TimeslotRepository(), fenix: true);
    //verification
    Get.lazyPut<VerificationRepo>(() => VerificationRepo(), fenix: true);

    //============================================== controllers

    //barbershop
    Get.lazyPut<BarbershopController>(() => BarbershopController(),
        fenix: true);
    //change email
    Get.lazyPut<ChangeEmailControllerBarbershop>(
        () => ChangeEmailControllerBarbershop(),
        fenix: true);
    //barbershop notification
    Get.put<BarbershopNotificationController>(
        BarbershopNotificationController(),
        permanent: true);
    //barbershop booking
    Get.lazyPut<BarbershopBookingController>(
        () => BarbershopBookingController(),
        fenix: true);
    //barbershop review
    Get.lazyPut<ReviewController>(() => ReviewController(), fenix: true);
    //barber
    // Get.lazyPut<BarberController>(() => BarberController(), fenix: true);
    //haircuts
    Get.lazyPut<HaircutController>(() => HaircutController(), fenix: true);
    //timeslots
    Get.lazyPut<TimeSlotController>(() => TimeSlotController(), fenix: true);
    //verification
    Get.lazyPut<VerificationController>(() => VerificationController(),
        fenix: true);
  }
}

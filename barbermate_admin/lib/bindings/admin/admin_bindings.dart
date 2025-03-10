import 'package:barbermate_admin/data/repository/barbershop_repo/barbershop_repo.dart';

import 'package:barbermate_admin/data/repository/barbershop_repo/haircut_repository.dart';
import 'package:barbermate_admin/data/repository/customer_repo/customer_repo.dart';
import 'package:barbermate_admin/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate_admin/data/repository/review_repo/review_repo.dart';
import 'package:barbermate_admin/features/admin/controllers/barbershop_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/customer_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/haircut_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/notification_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/review_controller.dart';
import 'package:get/get.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    //============================================== repositories
    //barbershop
    Get.lazyPut<BarbershopRepository>(() => BarbershopRepository(),
        fenix: true);
    Get.lazyPut<CustomerRepository>(() => CustomerRepository(), fenix: true);
    //notification
    Get.lazyPut<NotificationsRepo>(() => NotificationsRepo(), fenix: true);
    //reviews
    Get.lazyPut<ReviewRepo>(() => ReviewRepo(), fenix: true);
    //haircuts
    Get.lazyPut<HaircutRepository>(() => HaircutRepository(), fenix: true);
    //timeslots

    //============================================== controllers
    //barbershop
    Get.lazyPut<BarbershopController>(() => BarbershopController(),
        fenix: true);
    //admin notification
    Get.put<AdminNotificationController>(AdminNotificationController(),
        permanent: true);
    Get.lazyPut<CustomerController>(() => CustomerController(), fenix: true);
    //barbershop review
    Get.lazyPut<ReviewController>(() => ReviewController(), fenix: true);
    //haircuts
    Get.lazyPut<HaircutController>(() => HaircutController(), fenix: true);
    //admin controller
  }
}

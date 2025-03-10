import 'package:barbermate_customers/bindings/customer/customer_bindings.dart';
import 'package:barbermate_customers/features/auth/views/account_set_up/customer/account_set_up.dart';
import 'package:barbermate_customers/features/customer/views/appointments/appointments.dart';
import 'package:barbermate_customers/features/customer/views/dashboard/dashboard.dart';
import 'package:barbermate_customers/features/customer/views/notifications/notifications.dart';
import 'package:get/get.dart';

class BarbermatePages {
  static List<GetPage> getPages() {
    return [
      //=============================================== customer pages
      GetPage(
          name: '/customer/dashboard',
          page: () => const CustomerDashboard(),
          binding: BarbermateBindings(),
          children: [
            GetPage(
              name: '/customer/customerNotifications',
              page: () => const NotificationsPage(),
            ),
            GetPage(
              name: '/customer/appointments',
              page: () => const BarbermateAppointments(),
            ),
          ]),
      GetPage(
          name: '/customer/setup_profile',
          binding: BarbermateBindings(),
          page: () => CustomerAccountSetUpPage())
    ];
  }
}

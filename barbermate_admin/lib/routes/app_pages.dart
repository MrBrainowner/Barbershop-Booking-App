import 'package:barbermate_admin/bindings/admin/admin_bindings.dart';
import 'package:barbermate_admin/features/admin/views/barbershops_acc/barbershop_accounts.dart';
import 'package:barbermate_admin/features/admin/views/dashboard/dashboard.dart';
import 'package:get/get.dart';

class RoleBasedPage {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: '/barbershops',
        page: () => const BarbershopAccounts(),
        binding: AdminBinding(),
      ),
      GetPage(
        name: '/dashboard',
        page: () => const AdminDashBoard(),
        binding: AdminBinding(),
      ),
    ];
  }
}

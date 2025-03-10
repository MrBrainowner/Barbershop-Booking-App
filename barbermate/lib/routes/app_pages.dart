import 'package:barbermate/bindings/barbershops/barbershop_bindings.dart';
import 'package:barbermate/features/auth/views/account_set_up/barbershop/banner_set_up.dart';
import 'package:barbermate/features/auth/views/account_set_up/barbershop/logo_set_up.dart';
import 'package:barbermate/features/auth/views/account_set_up/barbershop/profile_set_up.dart';
import 'package:barbermate/features/barbershop/views/dashboard/dashboard.dart';
import 'package:get/get.dart';

class RoleBasedPage {
  static List<GetPage> getPages() {
    return [
      //=============================================== setting up profile account
      //==== barbershop
      GetPage(
          name: '/barbershop/setup_profile',
          page: () => const BarbershopAccountSetUpPage(),
          binding: BarbershopBinding(),
          children: [
            GetPage(
              name: '/barbershop/setup_banner',
              page: () => const BarbershopAccountSetUpPageBanner(),
            ),
            GetPage(
              name: '/barbershop/setup_logo',
              page: () => const BarbershopAccountSetUpPageLogo(),
            ),
          ]),
      GetPage(
        name: '/barbershop/dashboard',
        page: () => const BarbershopDashboard(),
        binding: BarbershopBinding(),
      ),
    ];
  }
}

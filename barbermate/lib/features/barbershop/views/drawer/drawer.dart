import 'package:barbermate/common/controller/shocase_controller.dart';
import 'package:barbermate/common/pages/about_us_page.dart';
import 'package:barbermate/common/pages/privacy_policy_page.dart';
import 'package:barbermate/features/barbershop/views/account/barbershop_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:showcaseview/showcaseview.dart';
import 'package:wiredash/wiredash.dart';
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../../../utils/popups/confirm_cancel_pop_up.dart';
import '../../controllers/barbershop_controller/barbershop_controller.dart';
import '../profile/profile.dart';

class BarbershopDrawer extends StatelessWidget {
  const BarbershopDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopController());
    final ShowcaseController showcaseController = Get.put(ShowcaseController());
    return Drawer(
      child: Column(
        children: [
          // Custom Drawer Header with CircleAvatar
          Obx(
            () => DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          controller.barbershop.value.barbershopName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  color:
                                      const Color.fromRGBO(238, 238, 238, 1)),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          controller.barbershop.value
                              .email, // Replace with dynamic user email
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      const Color.fromRGBO(238, 238, 238, 1)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Drawer Items
          Showcase(
            key: showcaseController.key9,
            title: 'Verify Account',
            description: 'Tap on the account tile',
            child: ListTile(
              leading: const iconoir.User(
                height: 25,
              ),
              title: const Text('Account'),
              onTap: () {
                // Handle profile navigation
                Get.to(() => const BarbershopAccount());
              },
            ),
          ),
          ListTile(
            leading: const iconoir.Shop(
              height: 25,
            ),
            title: const Text('Barbershop'),
            onTap: () {
              // Handle profile navigation
              Get.to(() => const BarbershopProfile());
            },
          ),
          ListTile(
            leading: const iconoir.PrivacyPolicy(
              height: 25,
            ),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Handle profile navigation
              Get.to(() => const PrivacyPolicyPage());
            },
          ),
          ListTile(
            leading: const iconoir.InfoCircle(
              height: 25,
            ),
            title: const Text('About Us'),
            onTap: () {
              // Handle profile navigation
              Get.to(() => const AboutUsPage());
            },
          ),
          ListTile(
            leading: const iconoir.ElectronicsChip(
              height: 25,
            ),
            title: const Text('Feedback and Reports'),
            onTap: () {
              // Handle profile navigation
              Wiredash.of(context).show(inheritMaterialTheme: true);
            },
          ),
          ListTile(
            leading: const iconoir.LogOut(
              height: 25,
            ),
            title: const Text('Log Out'),
            onTap: () => ConfirmCancelPopUp.showDialog(
                title: 'Log Out',
                description: 'Are you sure you want to log out?',
                textConfirm: 'Confirm',
                textCancel: 'Cancel',
                onConfirm: () => AuthenticationRepository.instance.logOut(),
                context: Get.context!),
          ),
        ],
      ),
    );
  }
}

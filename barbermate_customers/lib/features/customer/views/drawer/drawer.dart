import 'package:barbermate_customers/common/controller/showcase_controller.dart';
import 'package:barbermate_customers/common/pages/about_us_page.dart';
import 'package:barbermate_customers/common/pages/privacy_policy_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:wiredash/wiredash.dart';
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../../../utils/popups/confirm_cancel_pop_up.dart';
import '../../controllers/customer_controller/customer_controller.dart';
import '../appointments/appointments.dart';
import '../account/account.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController controller = Get.find();
    final ShowcaseController showcaseController = Get.put(ShowcaseController());
    return Drawer(
      child: Column(
        children: [
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
                          controller.customer.value.firstName +
                              controller.customer.value.lastName,
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
                          controller.customer.value
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
          ListTile(
            leading: const iconoir.User(
              height: 25,
            ),
            title: const Text('Account'),
            onTap: () {
              // Handle profile navigation
              Get.to(() => const CustomerAccount());
            },
          ),
          ListTile(
            leading: const iconoir.Calendar(
              height: 25,
            ),
            title: const Text('Appointments'),
            onTap: () {
              // Handle profile navigation
              Get.to(() => const BarbermateAppointments());
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
              Wiredash.of(context).show(inheritMaterialTheme: true);
            },
          ),
          ListTile(
            leading: const iconoir.HelpCircle(
              height: 25,
            ),
            title: const Text('Help'),
            onTap: () {
              showcaseController.startShowcase(context, [
                showcaseController.key1,
                showcaseController.key2,
                showcaseController.key3,
                showcaseController.key4,
                showcaseController.key5,
                showcaseController.key6,
                showcaseController.key7,
              ]);

              Get.back();
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

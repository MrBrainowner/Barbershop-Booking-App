import 'package:barbermate_customers/common/controller/showcase_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate_customers/features/customer/views/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:showcaseview/showcaseview.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget? title;
  final bool? centertitle;
  const CustomerAppBar({
    super.key,
    required this.scaffoldKey,
    required this.title,
    this.centertitle,
  });

  @override
  Widget build(BuildContext context) {
    final CustomerNotificationController controller = Get.find();
    final ShowcaseController showcaseController = Get.put(ShowcaseController());

    return AppBar(
      centerTitle: centertitle,
      title: title,

      leading: Showcase(
          key: showcaseController.key1,
          title: 'Drawer',
          description: 'Information and settings',
          targetShapeBorder: CircleBorder(),
          child: AppBarIcon(scaffoldKey: scaffoldKey)), // Drawer Icon
      actions: [
        Obx(
          () => Showcase(
            key: showcaseController.key2,
            title: 'Notifications',
            description: 'All notification are here',
            targetShapeBorder: CircleBorder(),
            targetPadding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () => Get.to(() =>
                    const NotificationsPage()), // Navigate to notifications
                child: controller.hasUnreadNotifications
                    ? const Badge(
                        child: iconoir.Bell(
                          height: 25, // Bell Icon height
                        ),
                      )
                    : const iconoir.Bell(
                        height: 25, // Bell Icon height
                      )),
          ),
        ),

        const SizedBox(width: 10), // Padding for right spacing
      ],
    );
  }

  // This is necessary to implement the PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    super.key,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const iconoir.Menu(
        height: 25,
      ),
      onPressed: () {
        scaffoldKey.currentState?.openDrawer(); // Open the drawer when tapped
      },
    );
  }
}

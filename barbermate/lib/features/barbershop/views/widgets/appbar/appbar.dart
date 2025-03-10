import 'package:barbermate/common/controller/shocase_controller.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/barbershop/views/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:showcaseview/showcaseview.dart';

class BarbershopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget? title;
  final bool? centertitle;
  const BarbershopAppBar({
    super.key,
    required this.scaffoldKey,
    required this.title,
    this.centertitle,
  });

  @override
  Widget build(BuildContext context) {
    final BarbershopNotificationController controller = Get.find();
    final ShowcaseController showcaseController = Get.put(ShowcaseController());

    return AppBar(
      centerTitle: centertitle,
      title: title,
      leading: Showcase(
        key: showcaseController.key8,
        title: 'Drawer',
        description: 'Tap the drawer',
        targetShapeBorder: CircleBorder(),
        child: Showcase(
            key: showcaseController.key1,
            title: 'Drawer',
            description: 'Information and settings',
            targetShapeBorder: CircleBorder(),
            child: BarbershopAppBarIcon(scaffoldKey: scaffoldKey)),
      ), // Drawer Icon
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
                    const BarbershopNotifications()), // Navigate to notifications
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
        const SizedBox(width: 15), // Padding for right spacing
      ],
    );
  }

  // This is necessary to implement the PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BarbershopAppBarIcon extends StatelessWidget {
  const BarbershopAppBarIcon({
    super.key,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final deviceStorage = GetStorage();
    final ShowcaseController showcaseController = Get.put(ShowcaseController());
    return IconButton(
      icon: const iconoir.Menu(
        height: 25,
      ),
      onPressed: () {
        if (deviceStorage.read("drawer") == false) {
          scaffoldKey.currentState?.openDrawer();
          Future.delayed(Duration(milliseconds: 1000), () {
            showcaseController
                .startShowcase(context, [showcaseController.key9]);
          });
        } else {
          scaffoldKey.currentState?.openDrawer();
        }
      },
    );
  }
}

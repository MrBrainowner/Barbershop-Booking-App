import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../../../utils/popups/confirm_cancel_pop_up.dart';

// Drawer Widget
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Custom Drawer Header with CircleAvatar
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      AuthenticationRepository.instance.authUser!.email
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Drawer Items
          ListTile(
            leading: const Icon(Icons.logout_outlined),
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

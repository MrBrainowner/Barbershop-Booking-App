import 'package:barbermate_customers/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate_customers/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate_customers/features/customer/views/account/edit_email.dart';
import 'package:barbermate_customers/features/customer/views/account/edit_name.dart';
import 'package:barbermate_customers/features/customer/views/account/edit_number.dart';
import 'package:barbermate_customers/features/customer/views/account/edit_password.dart';
import 'package:barbermate_customers/utils/constants/format_date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class CustomerAccount extends StatelessWidget {
  const CustomerAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController = Get.find();
    final BFormatter format = Get.put(BFormatter());

    return PopScope(
      canPop: true,
      onPopInvoked: (dipPop) async {
        customerController.clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          centerTitle: true,
        ),
        body: Obx(() {
          // Show loading indicator when data is being fetched
          if (customerController.profileLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          // Access customer data
          final customer = customerController.customer.value;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image with if statement
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl:
                            customerController.customer.value.profileImage,
                        fit: BoxFit.cover,
                      )),
                ),
                TextButton(
                    onPressed: () => customerController.uploadImage('Profile'),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconoir.MediaImagePlus(),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Upload Photo'),
                      ],
                    )),
                // Full Name
                const SizedBox(height: 5),
                Text(
                  'Credentials',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Divider(),
                const SizedBox(height: 5),
                CanBeEdited(
                  widget: const iconoir.User(),
                  text: '${customer.firstName} ${customer.lastName}',
                  onPressed: () {
                    Get.to(() => const CustomerEditName());
                  },
                ),
                const SizedBox(height: 5),
                // Email
                CanBeEdited(
                  widget: const iconoir.Mail(),
                  text: AuthenticationRepository.instance.authUser!.email
                      .toString(),
                  onPressed: () {
                    Get.to(() => const CustomerEditEmail());
                  },
                ),
                const SizedBox(height: 5),
                CanBeEdited(
                  widget: const iconoir.Phone(),
                  text: customer.phoneNo,
                  onPressed: () {
                    Get.to(() => const CustomerEditNumber());
                  },
                ),
                CanBeEdited(
                  widget: const iconoir.Lock(),
                  text: 'Change Password',
                  onPressed: () {
                    Get.to(() => const CustomerEditPassword());
                  },
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                CannotBeEdited(
                  text: 'Created at ${format.formatDate(customer.createdAt)}',
                  widget: const iconoir.Calendar(),
                ),

                // Phone Number
              ],
            ),
          );
        }),
      ),
    );
  }
}

class CannotBeEdited extends StatelessWidget {
  const CannotBeEdited({
    super.key,
    required this.text,
    required this.widget,
  });

  final String text;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget,
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class CanBeEdited extends StatelessWidget {
  const CanBeEdited({
    super.key,
    required this.text,
    required this.onPressed,
    required this.widget,
  });

  final String text;
  final Widget widget;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget,
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const iconoir.ArrowRight(),
        ),
      ],
    );
  }
}

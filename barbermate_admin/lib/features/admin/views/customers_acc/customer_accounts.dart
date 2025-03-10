import 'package:barbermate_admin/features/admin/controllers/customer_controller.dart';
import 'package:barbermate_admin/features/admin/views/profiles/customer.dart';
import 'package:barbermate_admin/features/admin/views/widgets/customer_status.dart';
import 'package:barbermate_admin/utils/constants/format_date.dart';
import 'package:barbermate_admin/utils/popups/confirm_cancel_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class CustomerAccounts extends StatelessWidget {
  const CustomerAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('Customers'),
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Active'), // Active customers
                Tab(text: 'Banned'), // Banned customers
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCustomerList('active'), // Display active customers
                  _buildCustomerList('banned'), // Display banned customers
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerList(String status) {
    final CustomerController customerController = Get.find();
    final formatterController = Get.put(BFormatter());

    return Obx(() {
      // Filter customers based on the status
      final filteredCustomers = customerController.customers
          .where((customer) => customer.status == status)
          .toList();

      if (filteredCustomers.isEmpty) {
        return const Center(child: Text('No customers found.'));
      }

      return ListView.builder(
        itemCount: filteredCustomers.length,
        itemBuilder: (context, index) {
          final customer = filteredCustomers[index];

          return GestureDetector(
            onTap: () {
              Get.to(() => CustomerProfilePage(
                    id: customer.id,
                    firstName: customer.firstName,
                    lastName: customer.lastName,
                    email: customer.email,
                    profileImage: customer.profileImage,
                    phoneNo: customer.phoneNo,
                    createdAt: customer.createdAt,
                    status: customer.status,
                  ));
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  customer.profileImage,
                ),
                child: Text(formatterController.formatInitial(
                    customer.profileImage, customer.firstName)),
              ),
              title: Text(customer.firstName + " " + customer.lastName),
              subtitle: Text(customer.status.capitalizeFirst ?? ''),
              trailing: IconButton(
                icon: iconoir.ArrowRight(),
                onPressed: () {
                  status == 'active'
                      ? UpdateCustomerStatusWidget.showBottomSheet(
                          customerid: customer.id,
                          context: context,
                          title: 'Ban Account',
                          description:
                              'Please select the reason(s) and add any additional notes.',
                          textConfirm: 'Confirm',
                          textCancel: 'Cancel',
                          onConfirm: () async {},
                          customerToken: customer.fcmToken.toString(),
                        )
                      : ConfirmCancelPopUp.showDialog(
                          context: context,
                          title: 'Unban Customer',
                          description:
                              'Are you sure you want to unban this customer?',
                          textConfirm: 'Confirm',
                          textCancel: 'Cancel',
                          onConfirm: () async {
                            await customerController.updateCustomerField(
                                customer.id,
                                'active',
                                null,
                                null,
                                customer.fcmToken.toString());
                          },
                        );
                },
              ),
            ),
          );
        },
      );
    });
  }
}

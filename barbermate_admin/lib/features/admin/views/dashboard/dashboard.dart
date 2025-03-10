import 'package:barbermate_admin/features/admin/controllers/barbershop_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/customer_controller.dart';
import 'package:barbermate_admin/features/admin/views/barbershops_acc/barbershop_accounts.dart';
import 'package:barbermate_admin/features/admin/views/customers_acc/customer_accounts.dart';
import 'package:barbermate_admin/features/admin/views/widgets/appbar.dart';
import 'package:barbermate_admin/features/admin/views/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashBoard extends StatelessWidget {
  const AdminDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final CustomerController customerController = Get.find();
    final BarbershopController barbershopController = Get.find();

    return Scaffold(
      key: scaffoldKey,
      appBar: AdminAppBar(
        centertitle: true,
        title: Text(
          "Admin Dashboard",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        scaffoldKey: scaffoldKey,
      ),
      drawer: const AdminDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => DashboardCard(
                  title: "Customers",
                  count: customerController.customers.length,
                  icon: Icons.people,
                  color: Colors.blue,
                  onTap: () {
                    Get.to(() => const CustomerAccounts());
                  },
                )),
            const SizedBox(height: 20), // Spacing between cards
            Obx(() => DashboardCard(
                  title: "Barbershops",
                  count: barbershopController.barbershops.length,
                  icon: Icons.store,
                  color: Colors.green,
                  onTap: () {
                    Get.to(() => const BarbershopAccounts());
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // Fixed width for better UI
      height: 200, // Fixed height
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      count.toString(),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

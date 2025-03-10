import 'package:barbermate_customers/common/widgets/appointment_case.dart';
import 'package:barbermate_customers/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbermateAppointments extends StatelessWidget {
  const BarbermateAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          bottom: TabBar(tabs: [
            Tab(
                child: Text('My Appointments',
                    style: Theme.of(context).textTheme.bodyLarge)),
            Tab(
                child: Text('History',
                    style: Theme.of(context).textTheme.bodyLarge)),
          ]),
        ),
        body: TabBarView(
          children: [
            // Tab for "Pending" bookings
            RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                controller.listenToBookingsStream();
              },
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.pendingAndConfirmedBookings.length,
                  itemBuilder: (context, index) {
                    final booking =
                        controller.pendingAndConfirmedBookings[index];

                    return buildAppointmentWidget(booking);
                  },
                );
              }),
            ),

            // Tab for "Confirmed" bookings
            RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                controller.listenToBookingsStream();
              },
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.doneBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.doneBookings[index];

                    return buildAppointmentWidget(booking);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

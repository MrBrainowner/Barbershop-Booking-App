import 'package:barbermate/common/widgets/appointment_case.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbershopAppointments extends StatelessWidget {
  const BarbershopAppointments({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final BarbershopBookingController controller = Get.find();
    // Fetch appointments when the UI is built

    return DefaultTabController(
      initialIndex: initialIndex,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          bottom: TabBar(tabs: [
            Tab(
                child:
                    Text('New', style: Theme.of(context).textTheme.bodyLarge)),
            Tab(
                child: Text('Upcoming',
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
                  itemCount: controller.pendingBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.pendingBookings[index];

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
                  itemCount: controller.confirmedBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.confirmedBookings[index];

                    return buildAppointmentWidget(booking);
                  },
                );
              }),
            ),

            // Tab for "Done" bookings
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

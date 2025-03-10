import 'package:barbermate_customers/common/widgets/toast.dart';
import 'package:barbermate_customers/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate_customers/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate_customers/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershop_data_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate_customers/features/customer/views/dashboard/dashboard.dart';
import 'package:barbermate_customers/features/customer/views/widgets/booking_page/timeslot_card.dart';
import 'package:barbermate_customers/utils/constants/format_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class ChooseSchedule extends StatelessWidget {
  const ChooseSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.find();
    final GetBarbershopDataController getBarbershopsDataController = Get.find();

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        bookingController.clearBookingData();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                  bookingController.clearBookingData();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text(
            'Choose Schedule',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Obx(() {
                  return EasyDateTimeLinePicker(
                    focusedDate: bookingController.selectedDate.value,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030, 3, 18),
                    onDateChange: (date) {
                      // bookingController.selectedDate.value = date;
                      bookingController.updateSelectedDate(date);
                      print(bookingController.selectedDate.value);
                    },
                  );
                }),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: Obx(() {
                    var timeslot = getBarbershopsDataController.timeSlots;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 3,
                      ),
                      itemCount: timeslot.length,
                      itemBuilder: (context, index) {
                        final slot = timeslot[index];
                        return TimeSlotCard(
                            timeSlot: slot); // Pass the time slot to the card
                      },
                    );
                  }),
                ),
              ])),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Obx(
                () => Expanded(
                    child: bookingController.selectedTimeSlot.value?.id == null
                        ? ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.grey.shade300)),
                            onPressed: () {},
                            child: const Text('Book Now'))
                        : ElevatedButton(
                            onPressed: () {
                              print(bookingController
                                  .chosenBarbershop.value.fcmToken);
                              showBookingDetailsBottomSheet(
                                  context,
                                  bookingController.selectedTimeSlot.value!,
                                  bookingController.selectedHaircut.value,
                                  bookingController.chosenBarbershop.value,
                                  bookingController.selectedDate.value!);
                            },
                            child: const Text('Book Now'))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showBookingDetailsBottomSheet(BuildContext context, TimeSlotModel timeSlot,
    HaircutModel haircut, BarbershopModel barbershop, DateTime date) {
  final format = Get.put(BFormatter());
  final BookingController bookingController = Get.find();
  final CustomerController customer = Get.find();
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Booking Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Barbershop: ${barbershop.barbershopName}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Haircut: ${haircut.name}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Selected Time Slot: ${TimeSlotModel.formatTimeRange(timeSlot.startTime, timeSlot.endTime)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Date: ${format.formatDate(date)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Add more booking details like price, services, etc.
            Text(
              "Price: ${haircut.price}", // Example of price
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Cancel')),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (customer.customer.value.status == 'banned') {
                        ToastNotif(
                                message:
                                    "Your account is banned. Can't do this action.",
                                title: 'Account banned')
                            .showErrorNotif(context);
                      } else {
                        await bookingController
                            .addBooking(); // Close bottom sheet
                        Get.off(() => const CustomerDashboard());
                      }
                    },
                    child: const Text("Confirm Booking"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true, // To allow BottomSheet to be scrollable if needed
  );
}

import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershop_data_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate_customers/features/customer/views/booking/choose_schedule.dart';
import 'package:barbermate_customers/features/customer/views/widgets/booking_page/haircuts_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ChooseHaircut extends StatelessWidget {
  const ChooseHaircut({
    super.key,
  });

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
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Choose a Haircut',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  bookingController.selectedHaircut.value.id = null;

                  Get.to(() => const ChooseSchedule());
                },
                child:
                    Text('Skip', style: Theme.of(context).textTheme.bodyLarge))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Price Range: ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Obx(
                  () => SfRangeSlider(
                    min: 0.0,
                    max: 500.0,
                    values: getBarbershopsDataController.selectedRange.value,
                    interval: 100,
                    showLabels: true,
                    showTicks: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 1,
                    dragMode: SliderDragMode.both,
                    numberFormat: NumberFormat('\₱'),
                    onChanged: (SfRangeValues value) {
                      getBarbershopsDataController.selectedRange.value = value;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  child: Obx(() {
                    // Wait for data to load and filter based on selected range
                    final filteredHaircuts =
                        getBarbershopsDataController.getFilteredHaircuts();

                    if (filteredHaircuts.isEmpty) {
                      return const Center(
                          child: Text('No Haircuts found in this range.'));
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.7,
                        mainAxisExtent: 215,
                      ),
                      itemCount: filteredHaircuts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final haircut = filteredHaircuts[index];
                        return HaircutsCard(haircut: haircut);
                      },
                    );
                  }),
                ),
              ],
            )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () async {
                            bookingController.clearBookingData();
                            Get.back();
                          },
                          child: const Text('Cancel'))),
                  const SizedBox(width: 10),
                  Obx(
                    () => Expanded(
                        child: bookingController.selectedHaircut.value.id ==
                                null
                            ? ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.grey)),
                                onPressed: () {},
                                child: const Text('Next'))
                            : ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const ChooseSchedule());
                                },
                                child: const Text('Next'))),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

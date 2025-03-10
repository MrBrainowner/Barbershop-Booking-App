import 'package:barbermate_customers/common/controller/showcase_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershop_data_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershops_controller.dart';
import 'package:barbermate_customers/features/customer/views/face_shape_detector/face_shape_detection_ai.dart';
import 'package:barbermate_customers/features/customer/views/test_map/test_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../controllers/customer_controller/customer_controller.dart';
import '../drawer/drawer.dart';
import '../widgets/dashboard/barbershop_card.dart';
import '../widgets/appbar/customer_appbar.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final CustomerController customerController = Get.find();
    final GetBarbershopsController getBarbershopsController = Get.find();
    final GetBarbershopDataController getBarbershopsDataController = Get.find();
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('MMMM d, y').format(now);
    final ShowcaseController showcaseController = Get.put(ShowcaseController());

    return ShowCaseWidget(
      builder: (context) => // Run showcase when first tap happens
          Stack(
        children: [
          Scaffold(
            key: scaffoldKey,
            appBar: CustomerAppBar(
              centertitle: false,
              scaffoldKey: scaffoldKey,
              title: const Text(''),
            ),
            drawer: const CustomerDrawer(),
            // Make sure you have a drawer defined here
            body: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                await getBarbershopsController.refreshData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Flexible(
                                  child: Obx(
                                    () => Text(
                                      'Welcome to Barbermate, ${customerController.customer.value.firstName}',
                                      maxLines: 3,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                  ),
                                )
                              ],
                            )),
                          ],
                        ),
                        const SizedBox(height: 70),
                        Text(formattedDate,
                            style: Theme.of(context).textTheme.labelSmall),
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Showcase(
                                        targetPadding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        key: showcaseController.key3,
                                        title: 'Suggest Haircuts',
                                        description:
                                            'AI feature to suggest you a haircut base on your face shape.',
                                        child: OutlinedButton(
                                            onPressed: () => Get.to(() =>
                                                const SuggestHaircutAiPage()),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const iconoir.Scissor(
                                                  height: 25,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  'Suggest Me',
                                                  overflow: TextOverflow.clip,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Showcase(
                                  targetPadding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  key: showcaseController.key4,
                                  title: 'Map',
                                  description:
                                      'Locations and directions of all the barbershop',
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => const MapWidgetTest());
                                    },
                                    child: const iconoir.Map(
                                        height: 25,
                                        color:
                                            Color.fromRGBO(238, 238, 238, 1)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Book Now',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Obx(() {
                            if (getBarbershopsController.isLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (getBarbershopsController
                                .barbershop.isEmpty) {
                              return const Center(
                                  child: Text('No Barbershop available.'));
                            } else {
                              final barbershops =
                                  getBarbershopsController.barbershop;

                              return ListView.builder(
                                itemCount: barbershops.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final shops = barbershops[index];
                                  getBarbershopsController
                                      .checkIsOpenNow(shops.openHours);
                                  getBarbershopsDataController
                                      .fetchReviews(shops.id);

                                  // Apply showcase only to the first item
                                  return index == 0
                                      ? Showcase(
                                          key: showcaseController
                                              .key5, // Key applied only to the first item
                                          title: 'Barbershop',
                                          description:
                                              'Choose a barbershop you want',
                                          child: CustomerBarbershopCard(
                                            isIndex0: true,
                                            averageRating:
                                                getBarbershopsDataController
                                                            .averageRatings[
                                                        shops.id] ??
                                                    0.0,
                                            barbershop: shops,
                                          ),
                                        )
                                      : CustomerBarbershopCard(
                                          averageRating:
                                              getBarbershopsDataController
                                                          .averageRatings[
                                                      shops.id] ??
                                                  0.0,
                                          barbershop: shops,
                                        );
                                },
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(() => !showcaseController.hasTapped.value
              ? Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showcaseController.showWelcomeDialog(context);
                    },
                  ),
                )
              : SizedBox()), // Hide overlay after first tap
        ],
      ),
    );
  }
}

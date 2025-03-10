import 'package:barbermate/common/controller/shocase_controller.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/barbershop/controllers/haircuts_controller/haircuts_controller.dart';
import 'package:barbermate/features/barbershop/controllers/timeslot_controller/timeslot_controller.dart';
import 'package:barbermate/features/barbershop/views/appointments/appointments.dart';
import 'package:barbermate/features/barbershop/views/management/haircut/management.dart';
import 'package:barbermate/features/barbershop/views/reviews/reviews.dart';
import 'package:barbermate/features/barbershop/views/widgets/appbar/appbar.dart';
import 'package:barbermate/features/barbershop/views/widgets/dashboard/overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:showcaseview/showcaseview.dart';
import '../drawer/drawer.dart';
import '../management/timeslots/timeslots.dart';

class BarbershopDashboard extends StatelessWidget {
  const BarbershopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final BarbershopController controller = Get.find();
    final BarbershopBookingController bookingController = Get.find();
    final HaircutController haircutController = Get.find();
    final TimeSlotController timeSlotController = Get.find();
    final ShowcaseController showcaseController = Get.put(ShowcaseController());

    return ShowCaseWidget(
      builder: (context) => Stack(
        children: [
          Scaffold(
            key: scaffoldKey,
            appBar: BarbershopAppBar(
              centertitle: false,
              scaffoldKey: scaffoldKey,
              title: Text(
                '',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            drawer: const BarbershopDrawer(),
            body: RefreshIndicator(
              onRefresh: () async {
                timeSlotController.fetchTimeSlots();
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
                                      'Welcome to Barbermate, ${controller.barbershop.value.barbershopName}',
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
                        const SizedBox(height: 90),
                        Text('Haircut Styles | Time Slots | Barbers',
                            style: Theme.of(context).textTheme.labelSmall),
                        Row(
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Showcase(
                                            targetPadding: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            key: showcaseController.key3,
                                            title: 'Add Haircuts',
                                            description:
                                                'Add offered hairstyles',
                                            child: OutlinedButton(
                                                onPressed: () {
                                                  Get.to(() =>
                                                      const HaircutManagementPage());
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const iconoir.Scissor(
                                                      height: 25,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Obx(
                                                      () => Text(
                                                          '${haircutController.haircuts.length}'),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Showcase(
                                            targetPadding: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            key: showcaseController.key4,
                                            title: 'Time Slots',
                                            description:
                                                'Add time slots for customers to choose',
                                            child: OutlinedButton(
                                                onPressed: () {
                                                  Get.to(() =>
                                                      const TimeslotsPage());
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const iconoir.Timer(
                                                      height: 25,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Obx(
                                                      () => Text(
                                                          '${timeSlotController.timeSlots.length}'),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    // Row(
                                    //   children: [
                                    //     ElevatedButton(
                                    //       onPressed: () {
                                    //         Get.to(() => const ManageBarbersPage());
                                    //       },
                                    //       child: Row(
                                    //         children: [
                                    //           const iconoir.Group(
                                    //               height: 25,
                                    //               color: Color.fromRGBO(
                                    //                   238, 238, 238, 1)),
                                    //           const SizedBox(width: 10),
                                    //           Obx(() => Text(
                                    //               '${barberController.barbers.length}')),
                                    //         ],
                                    //       ),
                                    //     )
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Overview',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Showcase(
                                  targetPadding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  key: showcaseController.key5,
                                  title: 'New Appointments',
                                  description:
                                      'All new appointments can be seen here',
                                  child: OverviewCard(
                                    flex1: 1,
                                    flex2: 0,
                                    color: Colors.blue.shade100,
                                    color2: Colors.white,
                                    title: 'New Appointments',
                                    sometext:
                                        '${bookingController.pendingBookings.length}',
                                    titl2: '   ',
                                    sometext2: '   ',
                                    onTapCard1: () => Get.to(() =>
                                        const BarbershopAppointments(
                                            initialIndex: 0)),
                                    onTapCard2: () {},
                                  ),
                                ),
                                Showcase(
                                  targetPadding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  key: showcaseController.key6,
                                  title: 'Upcoming Appointments',
                                  description:
                                      'All upcoming appointments can be seen here',
                                  child: OverviewCard(
                                    flex1: 0,
                                    flex2: 1,
                                    color: Colors.white,
                                    color2: Colors.orange.shade100,
                                    title: '    ',
                                    sometext: '   ',
                                    titl2: 'Upcoming Appointments',
                                    sometext2:
                                        '${bookingController.confirmedBookings.length}',
                                    onTapCard1: null,
                                    onTapCard2: () => Get.to(() =>
                                        const BarbershopAppointments(
                                            initialIndex: 1)),
                                  ),
                                ),
                                Showcase(
                                  targetPadding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  key: showcaseController.key7,
                                  title: 'Barbershop Reviews',
                                  description:
                                      'Customer reviews can be seen here',
                                  child: OverviewCard(
                                    flex1: 1,
                                    flex2: 0,
                                    color: Colors.yellow.shade100,
                                    color2: Colors.white,
                                    title: 'Reviews',
                                    sometext: (controller.reviews.isEmpty
                                            ? 0.0
                                            : controller.reviews.fold(
                                                    0.0,
                                                    (sum, review) =>
                                                        sum + review.rating) /
                                                controller.reviews.length)
                                        .toStringAsFixed(1),
                                    titl2: '   ',
                                    sometext2: '   ',
                                    onTapCard1: () =>
                                        Get.to(() => const ReviewsPage()),
                                    onTapCard2: null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
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

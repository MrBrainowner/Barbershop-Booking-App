import 'package:barbermate_customers/common/controller/showcase_controller.dart';
import 'package:barbermate_customers/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershop_data_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershops_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate_customers/features/customer/views/barbershop/barbershop.dart';
import 'package:barbermate_customers/utils/themes/text_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:showcaseview/showcaseview.dart';
import '../../../../../utils/themes/outline_button_theme.dart';
import '../../booking/choose_haircut.dart';

class CustomerBarbershopCard extends StatelessWidget {
  const CustomerBarbershopCard({
    super.key,
    required this.barbershop,
    required this.averageRating,
    this.isIndex0 = false,
  });

  final BarbershopModel barbershop;
  final double averageRating;
  final bool isIndex0;

  @override
  Widget build(BuildContext context) {
    final darkThemeOutlinedButton =
        BarbermateOutlinedButton.darkThemeOutlinedButton.style;
    final forOutlinedDarkText = BarbermateTextTheme.darkTextTheme.bodyMedium;
    final GetBarbershopsController controller = Get.find();
    final GetBarbershopDataController dataController = Get.find();
    final BookingController bookingController = Get.find();
    final ShowcaseController showcaseController = Get.put(ShowcaseController());

    const ngolor = Color.fromRGBO(238, 238, 238, 1);
    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 130,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: barbershop.barbershopBannerImage.isEmpty
                            ? Image.asset('assets/images/barbershop.jpg',
                                fit: BoxFit.cover)
                            : CachedNetworkImage(
                                imageUrl: barbershop.barbershopBannerImage,
                                fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Theme.of(context).primaryColor,
                        ),
                        height: 20,
                        width: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 3),
                            iconoir.StarSolid(
                              height: 15,
                              color: Colors.yellow.shade600,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                averageRating
                                    .toString(), // Average rating rounded to 1 decimal place
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(color: Colors.yellow.shade600),
                              ),
                            ),
                            const SizedBox(width: 3),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      barbershop.openHours == null ||
                              barbershop.openHours!.isEmpty
                          ? 'Not set'
                          : controller.isOpenNow.value
                              ? 'OPEN NOW'
                              : 'CLOSED',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: barbershop.openHours == null ||
                                    barbershop.openHours!.isEmpty
                                ? Colors.orange
                                : controller.isOpenNow.value
                                    ? Colors.green
                                    : Colors.red,
                          ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(barbershop.barbershopName,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: ngolor)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(barbershop.streetAddress,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: ngolor)),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (isIndex0 == true)
                                Showcase(
                                  targetPadding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  key: showcaseController.key6,
                                  title: 'Barbershop Profile',
                                  description:
                                      'Barbershop profile, informations and haicuts offered',
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      dataController.fetchHaircuts(
                                          barberShopId: barbershop.id,
                                          descending: true);
                                      dataController
                                          .fetchTimeSlots(barbershop.id);
                                      bookingController.chosenBarbershop.value =
                                          barbershop;

                                      await dataController
                                          .fetchReviews(barbershop.id);
                                      bookingController
                                          .averageRating.value = dataController
                                              .averageRatings[barbershop.id] ??
                                          0.0;
                                      Get.to(() => BarbershopProfilePage(
                                            barbershop: barbershop,
                                          ));
                                    },
                                    style: darkThemeOutlinedButton,
                                    child: const iconoir.Shop(
                                      color: ngolor,
                                      height: 30,
                                    ),
                                  ),
                                )
                              else
                                OutlinedButton(
                                  onPressed: () async {
                                    dataController.fetchHaircuts(
                                        barberShopId: barbershop.id,
                                        descending: true);
                                    dataController
                                        .fetchTimeSlots(barbershop.id);
                                    bookingController.chosenBarbershop.value =
                                        barbershop;

                                    await dataController
                                        .fetchReviews(barbershop.id);
                                    bookingController
                                        .averageRating.value = dataController
                                            .averageRatings[barbershop.id] ??
                                        0.0;
                                    Get.to(() => BarbershopProfilePage(
                                          barbershop: barbershop,
                                        ));
                                  },
                                  style: darkThemeOutlinedButton,
                                  child: const iconoir.Shop(
                                    color: ngolor,
                                    height: 30,
                                  ),
                                ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: isIndex0
                                    ? Showcase(
                                        key: showcaseController.key7,
                                        title: 'Book Barbershop',
                                        description:
                                            'Book the chosen barbershop',
                                        targetPadding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            dataController.fetchHaircuts(
                                                barberShopId: barbershop.id,
                                                descending: true);
                                            dataController
                                                .fetchTimeSlots(barbershop.id);
                                            bookingController.chosenBarbershop
                                                .value = barbershop;
                                            Get.to(() => const ChooseHaircut());
                                          },
                                          style: darkThemeOutlinedButton,
                                          child: Text(
                                            'Book Now',
                                            style: forOutlinedDarkText,
                                          ),
                                        ),
                                      )
                                    : OutlinedButton(
                                        onPressed: () async {
                                          dataController.fetchHaircuts(
                                              barberShopId: barbershop.id,
                                              descending: true);
                                          dataController
                                              .fetchTimeSlots(barbershop.id);
                                          bookingController.chosenBarbershop
                                              .value = barbershop;
                                          Get.to(() => const ChooseHaircut());
                                        },
                                        style: darkThemeOutlinedButton,
                                        child: Text(
                                          'Book Now',
                                          style: forOutlinedDarkText,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

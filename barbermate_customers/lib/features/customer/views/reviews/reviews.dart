import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershop_data_controller.dart';
import 'package:barbermate_customers/utils/constants/format_date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerReviewsPage extends StatelessWidget {
  const CustomerReviewsPage({super.key, required this.barberId});

  final String barberId;

  @override
  Widget build(BuildContext context) {
    final GetBarbershopDataController getBarbershopsDataController = Get.find();
    final BFormatter format = Get.put(BFormatter());

    getBarbershopsDataController.fetchReviews(barberId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reviews'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Trigger a manual refresh if needed
          await getBarbershopsDataController.fetchReviews(barberId);
        },
        child: Obx(() {
          // Wait for data loading
          if (getBarbershopsDataController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (getBarbershopsDataController.reviewsList.isEmpty) {
            return const Center(child: Text('No reviews available.'));
          } else {
            return ListView.builder(
              itemCount: getBarbershopsDataController.reviewsList.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final review = getBarbershopsDataController.reviewsList[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    height: 90,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: review.customerImage.isNotEmpty
                                      ? review.customerImage
                                      : 'assets/images/prof.jpg', // Placeholder image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 15, color: Colors.orange),
                                const SizedBox(width: 3),
                                Text('${review.rating}'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            child: Container(
                              height: 100,
                              color: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          review.name,
                                          textAlign: TextAlign.justify,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          format.formatDate(review.createdAt),
                                          textAlign: TextAlign.justify,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            review.reviewText,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}

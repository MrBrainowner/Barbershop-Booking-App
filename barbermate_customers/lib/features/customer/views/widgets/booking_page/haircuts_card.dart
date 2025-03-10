import 'package:barbermate_customers/data/models/haircut_model/haircut_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/booking_controller/booking_controller.dart';

class HaircutsCard extends StatelessWidget {
  const HaircutsCard({
    super.key,
    required this.haircut,
  });

  final HaircutModel haircut;

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();

    return Obx(() {
      // Check if the haircut is selected
      final isSelected = controller.selectedHaircut.value == haircut;

      return GestureDetector(
        onTap: () {
          // Toggle selection: Select if not selected, deselect if already selected
          if (isSelected) {
            controller.selectedHaircut.value.id = null;
          } else {
            controller.selectedHaircut.value = haircut;
          }
        },
        child: SizedBox(
          child: Card(
            elevation: isSelected ? 5 : 2, // Add elevation for better feedback
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isSelected
                    ? Colors.black
                    : Colors.transparent, // Visible border for selection
                width: 2, // Border width
              ),
              borderRadius:
                  BorderRadius.circular(8), // Border radius for rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    child: Image(
                      height: 140,
                      fit: BoxFit.cover,
                      image: haircut.imageUrl.isNotEmpty
                          ? CachedNetworkImageProvider(haircut.imageUrl)
                          : const AssetImage('assets/images/prof.jpg')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    haircut.name,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  const SizedBox(height: 2),
                  Text('₱ ${haircut.price}'),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

import 'package:barbermate_customers/data/models/combined_model/barber_haircut.dart';
import 'package:barbermate_customers/data/models/haircut_model/haircut_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SuggestHairstyle extends StatelessWidget {
  const SuggestHairstyle({
    super.key,
    required this.haircut,
    required this.barbershop,
  });

  final HaircutModel haircut;
  final BarbershopHaircut barbershop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 2, // Add elevation for better feedback
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Border radius for rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Flexible(
                  child: Text(
                barbershop.barbershop.barbershopName,
                maxLines: 2,
                overflow: TextOverflow.clip,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

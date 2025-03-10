import 'package:barbermate_admin/data/models/haircut_model/haircut_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HaircutCard2 extends StatelessWidget {
  final HaircutModel haircut;

  const HaircutCard2({
    super.key,
    required this.haircut,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
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
                        ? CachedNetworkImageProvider(
                            haircut.imageUrl,
                          )
                        : const AssetImage('assets/images/prof.jpg')
                            as ImageProvider),
              ),
              const SizedBox(height: 5),
              Text(haircut.name),
              const SizedBox(height: 2),
              Text('₱ ${haircut.price}'),
            ],
          ),
        ),
      ),
    );
  }
}

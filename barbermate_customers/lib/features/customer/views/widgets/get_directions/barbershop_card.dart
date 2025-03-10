import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BarbershopCard extends StatelessWidget {
  final String name;
  final String distance;
  final VoidCallback onTap;
  final String profile;

  const BarbershopCard({
    required this.name,
    required this.distance,
    required this.onTap,
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        leading: CircleAvatar(
            backgroundImage: profile.isNotEmpty
                ? CachedNetworkImageProvider(profile)
                : const AssetImage('assets/images/prof.jpg') as ImageProvider),
        title: Text(name),
        subtitle: Text(distance),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

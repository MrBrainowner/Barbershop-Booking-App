import 'package:barbermate_admin/utils/constants/format_date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomerProfilePage extends StatelessWidget {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileImage;
  final String phoneNo;
  final DateTime createdAt;
  final String status;

  const CustomerProfilePage({
    Key? key,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
    required this.phoneNo,
    required this.createdAt,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatterController = Get.put(BFormatter());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image & Name Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  maxRadius: 60,
                  backgroundImage: CachedNetworkImageProvider(
                    profileImage,
                  ),
                  child: Text(formatterController.formatInitial(
                      profileImage, firstName)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "$firstName $lastName",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Customer Details inside a Card
            Card(
              elevation: 5, // Shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileDetailRow(
                      icon: Icons.email,
                      label: "Email",
                      value: email,
                      color: Colors.blue,
                    ),
                    ProfileDetailRow(
                      icon: Icons.phone,
                      label: "Phone Number",
                      value: phoneNo,
                      color: Colors.green,
                    ),
                    ProfileDetailRow(
                      icon: Icons.info,
                      label: "Status",
                      value: status,
                      color: status == "Active" ? Colors.green : Colors.red,
                    ),
                    ProfileDetailRow(
                      icon: Icons.calendar_today,
                      label: "Joined",
                      value: DateFormat('yyyy-MM-dd').format(createdAt),
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Profile Details Row (Reusable)
class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const ProfileDetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(
            "$label:",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

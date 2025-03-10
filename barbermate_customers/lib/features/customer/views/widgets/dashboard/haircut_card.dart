// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomerHaircutCard extends StatelessWidget {
  const CustomerHaircutCard({
    super.key,
    required this.title,
    required this.imagePath,
  });
  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(title, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}

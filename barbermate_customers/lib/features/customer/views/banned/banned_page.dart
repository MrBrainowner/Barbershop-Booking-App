import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BannedPage extends StatelessWidget {
  const BannedPage({super.key, required this.reasons, required this.notes});

  final List<String> reasons;
  final String notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Account Banned"),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Warning Icon & Message
            const Icon(Icons.warning_amber_rounded,
                size: 60, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              "Your account has been banned.",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Reasons & Notes in a Card
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Reasons for banning:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // Display reasons as a list
                        ...reasons.map((reason) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.circle,
                                      size: 10, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      reason,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            )),

                        const SizedBox(height: 16),
                        const Text(
                          "Notes:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notes.isNotEmpty
                              ? notes
                              : "No additional notes provided.",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Contact Section
            const SizedBox(height: 20),
            const Text(
              "If you have concerns, contact us at:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse("mailto:thebarbermate@gmail.com"));
              },
              child: const Text(
                "thebarbermate@gmail.com",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

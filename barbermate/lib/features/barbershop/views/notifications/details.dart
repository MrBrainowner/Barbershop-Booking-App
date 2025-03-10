import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatelessWidget {
  final String title;
  final String message;
  final String notes;
  final List<String> reasons;

  const NotificationDetailsPage({
    Key? key,
    required this.title,
    required this.message,
    required this.notes,
    required this.reasons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notification Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text("Notes:", style: Theme.of(context).textTheme.titleMedium),
            Text(notes.isEmpty ? 'No notes added' : notes,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text("Reasons:", style: Theme.of(context).textTheme.titleMedium),
            Expanded(
              child: ListView.builder(
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: Text(reasons[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

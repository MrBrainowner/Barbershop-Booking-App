import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotifications {
  String? id;
  final String type;
  final String title;
  final String message;
  final List<String>? reasons; // Nullable list of reasons
  final String? notes; // Nullable notes
  final String status; // Optional, can be null
  final DateTime createdAt; // Optional field for timestamp

  AdminNotifications({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.reasons, // Optional field
    this.notes, // Optional field
    required this.status, // Optional field
    required this.createdAt,
  });

  // Static method for an empty Notification (if needed)
  static AdminNotifications empty() {
    return AdminNotifications(
      id: '',
      type: '',
      title: '',
      message: '',
      reasons: null,
      notes: null,
      status: '',
      createdAt: DateTime.now(),
    );
  }

  // Convert the NotificationModel into a Map (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'reasons': reasons, // Can be null
      'notes': notes, // Can be null
      'status': status, // Can be null
      'created_at': Timestamp.fromDate(createdAt), // Optional field
    };
  }

  // Create a NotificationModel from a Firestore snapshot
  factory AdminNotifications.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AdminNotifications(
      id: document.id,
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      reasons: (data['reasons'] as List<dynamic>?)
          ?.map((reason) => reason.toString())
          .toList(), // Handle nullable reasons
      notes: data['notes'] as String?, // Can be null
      status: data['status'], // Can be null
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }
}

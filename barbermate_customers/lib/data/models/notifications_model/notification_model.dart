// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  final String type; // e.g., "booking", "appointment_status", etc.
  final String title;
  final String message;
  final List<String>? reasons; // Nullable list of reasons
  final String? notes; // Nullable notes
  final String status; // Optional, used for specific notifications
  final DateTime createdAt; // Optional field for timestamp
  String bookingId;
  String customerId;
  String barbershopId;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.reasons, // Optional field
    this.notes, // Optional field
    required this.status,
    required this.createdAt,
    required this.bookingId,
    required this.customerId,
    required this.barbershopId,
  });

  // Static method for an empty Notification (if needed)
  static NotificationModel empty() {
    return NotificationModel(
      id: '',
      type: '',
      title: '',
      message: '',
      reasons: null,
      notes: null,
      status: '',
      createdAt: DateTime.now(),
      bookingId: '',
      customerId: '',
      barbershopId: '',
    );
  }

  // Convert the NotificationModel into a Map (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'barbershopId': barbershopId,
      'customerId': customerId,
      'type': type,
      'title': title,
      'message': message,
      'reasons': reasons, // Can be null
      'notes': notes, // Can be null
      'status': status,
      'created_at': Timestamp.fromDate(createdAt), // Optional field
    };
  }

  // Create a NotificationModel from a Firestore snapshot
  factory NotificationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return NotificationModel(
        id: document.id,
        bookingId: data['bookingId'] ?? '',
        barbershopId: data['barbershopId'] ?? '',
        customerId: data['customerId'] ?? '',
        type: data['type'] ?? '',
        title: data['title'] ?? '',
        message: data['message'] ?? '',
        reasons: (data['reasons'] as List<dynamic>?)
            ?.map((reason) => reason.toString())
            .toList(), // Handle nullable reasons
        notes: data['notes'] as String?, // Can be null
        status: data['status'], // Can be null
        createdAt: (data['created_at'] as Timestamp).toDate());
  }

  // Copy with method to update specific fields while keeping others unchanged
  NotificationModel copyWith({
    String? id,
    String? bookingId,
    String? barbershopId,
    String? customerId,
    String? type,
    String? title,
    String? message,
    String? status,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      barbershopId: barbershopId ?? this.barbershopId,
      customerId: customerId ?? this.customerId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

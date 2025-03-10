import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String id;
  String firstName;
  String lastName;
  final String email;
  String profileImage;
  String phoneNo;
  String? fcmToken; // Added fcmToken
  final String role;
  bool existing; // Allowing this to be modified from the constructor
  final DateTime createdAt;
  String status; // Added status field

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
    required this.phoneNo,
    this.fcmToken, // Added fcmToken to the constructor
    required this.role,
    required this.createdAt,
    this.existing = false,
    this.status = 'active', // Default value is 'active'
  });

  static CustomerModel empty() {
    return CustomerModel(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      profileImage: '',
      phoneNo: '',
      fcmToken: '', // Ensure fcmToken defaults to an empty string
      role: '',
      createdAt: DateTime.now(),
      existing: false, // Ensure it defaults to false for an empty object
      status: 'active', // Default value for empty object
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_image': profileImage,
      'phone_no': phoneNo,
      'fcmToken': fcmToken, // Include fcmToken in JSON conversion
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'existing': existing, // Include 'existing' in JSON conversion
      'status': status, // Include 'status' in JSON conversion
    };
  }

  factory CustomerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CustomerModel(
      id: document.id,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profile_image'] ?? '',
      phoneNo: data['phone_no'] ?? '',
      fcmToken: data['fcmToken'] ?? '', // Retrieve fcmToken from Firestore
      role: data['role'] ?? '',
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      existing: data['existing'] ?? false, // Handle 'existing' from Firebase
      status: data['status'] ??
          'active', // Handle 'status' from Firebase with default value
    );
  }

  CustomerModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImage,
    String? phoneNo,
    String? fcmToken, // Add fcmToken to the copyWith
    String? role,
    DateTime? createdAt,
    bool? existing, // Add this to the copyWith
    String? status, // Add status to the copyWith
  }) {
    return CustomerModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phoneNo: phoneNo ?? this.phoneNo,
      fcmToken: fcmToken ?? this.fcmToken, // Set fcmToken in copyWith
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      existing: existing ?? this.existing, // Set 'existing' in copyWith
      status: status ?? this.status, // Set 'status' in copyWith
    );
  }
}

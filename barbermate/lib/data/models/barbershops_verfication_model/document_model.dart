import 'package:cloud_firestore/cloud_firestore.dart';

class BarbershopDocumentModel {
  final String documentType;
  final String documentURL;
  final String status;
  final String? feedback;

  BarbershopDocumentModel({
    required this.documentType,
    required this.documentURL,
    this.status = 'pending', // Default to 'Pending'
    this.feedback,
  });

  // Convert the BarbershopDocumentModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'document_url': documentURL,
      'status': status,
      'feedback': feedback,
    };
  }

  // Factory method to create a BarbershopDocumentModel from a Firestore DocumentSnapshot
  factory BarbershopDocumentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception("Document data is null");
    }
    return BarbershopDocumentModel(
      documentType: data['document_type'] ?? '',
      documentURL: data['document_url'] ?? '',
      status: data['status'] ?? '',
      feedback: data['feedback'],
    );
  }

  // Copy method to create a modified version of the BarbershopDocumentModel
  BarbershopDocumentModel copyWith({
    String? documentType,
    String? documentURL,
    String? status,
    String? feedback,
  }) {
    return BarbershopDocumentModel(
      documentType: documentType ?? this.documentType,
      documentURL: documentURL ?? this.documentURL,
      status: status ?? this.status,
      feedback: feedback ?? this.feedback,
    );
  }
}

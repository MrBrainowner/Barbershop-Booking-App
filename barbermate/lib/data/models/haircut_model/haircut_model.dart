import 'package:cloud_firestore/cloud_firestore.dart';

class HaircutModel {
  String? id;
  String name;
  double price;
  int duration;
  List<String> category;
  String imageUrl; // Changed to store a single image only
  final DateTime? createdAt;

  HaircutModel({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.category,
    required this.imageUrl, // Initialize for single image
    this.createdAt,
  });

  static HaircutModel empty() {
    return HaircutModel(
      id: null,
      name: '',
      price: 0.0,
      duration: 0,
      category: [],
      imageUrl: '', // Initialize with empty string for single image
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'category': category,
      'imageUrl': imageUrl, // Serialize single image
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory HaircutModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return HaircutModel(
      id: document.id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0.0,
      duration: data['duration'] ?? 0,
      category: List<String>.from(data['category'] ?? []),
      imageUrl: data['imageUrl'] ?? '', // Deserialize single image
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  HaircutModel copyWith({
    String? id,
    String? name,
    double? price,
    int? duration,
    List<String>? category,
    String? imageUrl, // Single image in copyWith
    DateTime? createdAt,
  }) {
    return HaircutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl, // Update single image field
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

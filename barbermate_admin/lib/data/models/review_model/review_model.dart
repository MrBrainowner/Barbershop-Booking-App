import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsModel {
  String? id;
  String customerId;
  String name;
  String barberShopId;
  double rating;
  String reviewText;
  String customerImage;
  final DateTime createdAt;

  ReviewsModel({
    this.id,
    required this.customerId,
    required this.name,
    required this.barberShopId,
    required this.rating,
    required this.reviewText,
    required this.customerImage,
    required this.createdAt,
  });

  static ReviewsModel empty() {
    return ReviewsModel(
      id: null,
      customerId: '',
      name: '',
      barberShopId: '',
      rating: 0.0,
      reviewText: '',
      customerImage: '',
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'name': name,
      'barber_shop_id': barberShopId,
      'rating': rating,
      'review_text': reviewText,
      'customer_image': customerImage,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory ReviewsModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ReviewsModel(
        id: document.id,
        customerId: data['customer_id'] ?? '',
        name: data['name'] ?? '',
        barberShopId: data['barber_shop_id'] ?? '',
        rating: (data['rating'] ?? 0.0).toDouble(),
        reviewText: data['review_text'] ?? '',
        customerImage: data['customer_image'] ?? '',
        createdAt: (data['created_at'] as Timestamp).toDate());
  }

  ReviewsModel copyWith({
    String? id,
    String? customerId,
    String? name,
    String? barberShopId,
    double? rating,
    String? reviewText,
    String? customerImage,
    DateTime? createdAt,
  }) {
    return ReviewsModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      barberShopId: barberShopId ?? this.barberShopId,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      customerImage: customerImage ?? this.customerImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerId': customerId,
      'name': name,
      'barberShopId': barberShopId,
      'rating': rating,
      'reviewText': reviewText,
      'customerImage': customerImage,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ReviewsModel.fromMap(Map<String, dynamic> map) {
    return ReviewsModel(
      id: map['id'] != null ? map['id'] as String : null,
      customerId: map['customerId'] as String,
      name: map['name'] as String,
      barberShopId: map['barberShopId'] as String,
      rating: map['rating'] as double,
      reviewText: map['reviewText'] as String,
      customerImage: map['customerImage'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}

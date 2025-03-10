import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String id;
  String barbershopProfileImageUrl;
  String customerProfileImageUrl;
  String customerName;
  String haircutName;
  double haircutPrice;
  bool isReviewed; // Updated field name for typo consistency
  String barbershopName;
  String customerPhoneNo;
  String customerToken;
  String barbershopToken;
  String timeSlot;
  String barberShopId;
  String barberId;
  String customerId;
  String? haircutId;
  String date; // YYYY-MM-DD format
  String timeSlotId;
  String status;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.barbershopProfileImageUrl,
    required this.customerProfileImageUrl,
    required this.customerName,
    required this.haircutName,
    required this.haircutPrice,
    this.isReviewed = false, // Default value set to false
    required this.barbershopName,
    required this.customerPhoneNo,
    required this.customerToken,
    required this.barbershopToken,
    required this.timeSlot,
    required this.barberShopId,
    required this.barberId,
    required this.customerId,
    this.haircutId,
    required this.date,
    required this.timeSlotId,
    required this.status,
    required this.createdAt,
  });

  static BookingModel empty() {
    return BookingModel(
      id: '',
      barbershopProfileImageUrl: '',
      customerProfileImageUrl: '',
      barberShopId: '',
      barberId: '',
      customerId: '',
      haircutId: '',
      haircutName: '',
      haircutPrice: 0.0,
      isReviewed: false, // Default value
      date: '',
      timeSlotId: '',
      status: 'pending',
      createdAt: DateTime.now(),
      customerName: '',
      barbershopName: '',
      customerPhoneNo: '',
      customerToken: '',
      barbershopToken: '',
      timeSlot: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barbershopProfileImageUrl': barbershopProfileImageUrl,
      'customerProfileImageUrl': customerProfileImageUrl,
      'barbershop_id': barberShopId,
      'customerName': customerName,
      'barbershopName': barbershopName,
      'customerPhoneNo': customerPhoneNo,
      'customerToken': customerToken,
      'barbershopToken': barbershopToken,
      'timeSlot': timeSlot,
      'barber_id': barberId,
      'customer_id': customerId,
      'haircut_id': haircutId,
      'haircutName': haircutName,
      'haircutPrice': haircutPrice,
      'isReviewed': isReviewed, // Added to JSON representation
      'date': date,
      'time_slot_id': timeSlotId,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory BookingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BookingModel(
      id: document.id,
      barbershopProfileImageUrl: data['barbershopProfileImageUrl'] ?? '',
      customerProfileImageUrl: data['customerProfileImageUrl'] ?? '',
      barberShopId: data['barbershop_id'] ?? '',
      barberId: data['barber_id'] ?? '',
      customerId: data['customer_id'] ?? '',
      haircutId: data['haircut_id'] ?? '',
      haircutName: data['haircutName'] ?? '',
      haircutPrice: (data['haircutPrice'] ?? 0).toDouble(),
      isReviewed:
          data['isReviewed'] ?? false, // Default to false if not present
      date: data['date'] ?? '',
      timeSlotId: data['time_slot_id'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      customerName: data['customerName'] ?? '',
      barbershopName: data['barbershopName'] ?? '',
      customerPhoneNo: data['customerPhoneNo'] ?? '',
      customerToken: data['customerToken'] ?? '',
      barbershopToken: data['barbershopToken'] ?? '',
      timeSlot: data['timeSlot'] ?? '',
    );
  }

  BookingModel copyWith({
    String? id,
    String? barbershopProfileImageUrl,
    String? customerProfileImageUrl,
    String? barberShopId,
    String? customerName,
    String? barbershopName,
    String? customerPhoneNo,
    String? customerToken,
    String? barbershopToken,
    String? timeSlot,
    String? barberId,
    String? customerId,
    String? haircutId,
    String? haircutName,
    double? haircutPrice,
    bool? isReviewed, // Added to copyWith
    String? date,
    String? timeSlotId,
    String? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      barbershopProfileImageUrl:
          barbershopProfileImageUrl ?? this.barbershopProfileImageUrl,
      customerProfileImageUrl:
          customerProfileImageUrl ?? this.customerProfileImageUrl,
      barberShopId: barberShopId ?? this.barberShopId,
      barberId: barberId ?? this.barberId,
      customerName: customerName ?? this.customerName,
      barbershopName: barbershopName ?? this.barbershopName,
      timeSlot: timeSlot ?? this.timeSlot,
      customerPhoneNo: customerPhoneNo ?? this.customerPhoneNo,
      customerToken: customerToken ?? this.customerToken,
      barbershopToken: barbershopToken ?? this.barbershopToken,
      customerId: customerId ?? this.customerId,
      haircutId: haircutId ?? this.haircutId,
      haircutName: haircutName ?? this.haircutName,
      haircutPrice: haircutPrice ?? this.haircutPrice,
      isReviewed: isReviewed ?? this.isReviewed, // Update with new value
      date: date ?? this.date,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

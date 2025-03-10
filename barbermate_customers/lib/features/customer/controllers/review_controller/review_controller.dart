import 'dart:async';
import 'package:barbermate_customers/common/widgets/toast.dart';
import 'package:barbermate_customers/data/models/review_model/review_model.dart';
import 'package:barbermate_customers/data/repository/review_repo/review_repo.dart';
import 'package:barbermate_customers/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewControllerCustomer extends GetxController {
  static ReviewControllerCustomer get instance => Get.find();
  final ReviewRepo _repo = Get.find();

  // Observable list for storing reviews in real-time
  final reviewText = TextEditingController();
  final ratingController = TextEditingController();
  final CustomerController customer = Get.find();
  Rx<ReviewsModel> review = ReviewsModel.empty().obs;

  // Observable for storing the average rating
  final averageRatingValue = 0.0.obs;

  // Add a review
  Future<void> addReview(String babershopId, String bookingId) async {
    try {
      final newReview = ReviewsModel(
        customerId: customer.customer.value.id,
        createdAt: DateTime.now(),
        customerImage: customer.customer.value.profileImage,
        rating: review.value.rating,
        reviewText: reviewText.text,
        barberShopId: babershopId,
        name:
            '${customer.customer.value.firstName} ${customer.customer.value.lastName}',
      );
      await _repo.createReview(newReview, bookingId);
      ToastNotif(message: 'Review added successfully!', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: e.toString(), title: 'Error')
          .showErrorNotif(Get.context!);

      print(e.toString());
    }
  }
}

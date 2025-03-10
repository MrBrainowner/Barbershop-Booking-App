import 'dart:async';
import 'package:barbermate_admin/common/widgets/toast.dart';
import 'package:barbermate_admin/data/models/review_model/review_model.dart';
import 'package:barbermate_admin/data/repository/review_repo/review_repo.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final ReviewRepo _repo = Get.find();

  // Observable list for storing reviews in real-time
  final reviewsList = <ReviewsModel>[].obs;

  // Observable for storing the average rating
  final averageRating = 0.0.obs;

  RxMap<String, double> averageRatings = <String, double>{}.obs;
  final isLoading = false.obs;

  // Fetch reviews for a barbershop and update the observable list
  Future<void> fetchReviews(String barbershopId) async {
    try {
      isLoading.value = true;
      final reviews = await _repo.fetchReviewsOnce(barbershopId);

      reviewsList.assignAll(reviews);

      // Calculate the average rating for this specific barbershop
      calculateAverageRating(reviews, barbershopId);
    } catch (error) {
      ToastNotif(
        message: error.toString(),
        title: 'Error fetching reviews',
      ).showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

// Calculate the average rating from the reviews list
  void calculateAverageRating(List<ReviewsModel> reviews, String barbershopId) {
    if (reviews.isEmpty) {
      averageRatings[barbershopId] = 0.0;
      return;
    }

    // Sum up all ratings and calculate average
    double totalRating =
        reviews.fold(0.0, (sum, review) => sum + (review.rating ?? 0.0));
    double avgRating = totalRating / reviews.length;

    averageRatings[barbershopId] = double.parse(
      avgRating.toStringAsFixed(1),
    );
  }
}

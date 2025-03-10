import 'dart:async';
import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final ReviewRepo _repo = Get.find();

  // Observable list for storing reviews in real-time
  final reviewsList = <ReviewsModel>[].obs;

  // Observable for storing the average rating
  final averageRating = 0.0.obs;

  StreamSubscription? _reviewsStreamSubscription;

  @override
  void onInit() async {
    super.onInit();
    listenToReviewsStream();
  }

  // Fetch reviews for a barbershop and update the observable list
  void listenToReviewsStream() {
    // Listen to the reviews stream
    _repo.fetchReviewsStreamBarbershop().listen(
      (reviews) {
        reviewsList.assignAll(reviews); // Update the reviews list reactively

        // Calculate average rating whenever the reviews list is updated
        calculateAverageRating(reviews);
      },
      onError: (error) {
        // Handle errors here
        ToastNotif(message: error.toString(), title: 'Error fetching reviews')
            .showErrorNotif(Get.context!);
      },
    );
  }

// Calculate the average rating from the reviews list
  void calculateAverageRating(List<ReviewsModel> reviews) {
    try {
      if (reviews.isEmpty) {
        averageRating.value = 0.0; // If no reviews, set average to 0
        return;
      }

      double totalRating = 0.0;
      for (var review in reviews) {
        totalRating += review.rating; // Sum up all ratings
      }

      // Calculate the average rating and format it to 1 decimal place
      double calculatedRating = totalRating / reviews.length;
      averageRating.value = double.parse(
          calculatedRating.toStringAsFixed(1)); // Format to 1 decimal place
    } catch (e) {
      Get.snackbar('Error', 'Error calculating average rating: $e');
    }
  }

  @override
  void onClose() {
    // Cancel the stream subscription to prevent memory leaks
    _reviewsStreamSubscription?.cancel();
    super.onClose();
  }
}

import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReviewRepo extends GetxController {
  static ReviewRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = Get.put(AuthenticationRepository.instance.authUser?.uid);

//=========================================================== if the current user is the customer
  // Create a review and save it in the barbershop's reviews collection
  Future<void> createReview(ReviewsModel review, String bookingId) async {
    try {
      final reviews = await _db
          .collection('Barbershops')
          .doc(review.barberShopId)
          .collection('Reviews')
          .add(review.toJson());
      await _db
          .collection('Barbershops')
          .doc(review.barberShopId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'isReviewed': true});
      await _db
          .collection('Customers')
          .doc(review.customerId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'isReviewed': true});

      final docId = reviews.id;

      await reviews.update({'id': docId});
    } catch (e) {
      throw Exception('Error creating review: $e');
    }
  }

  // Fetch all reviews for a specific barbershop (method for customers)
  Future<List<ReviewsModel>> fetchReviewsOnce(String barberShopId) async {
    try {
      final snapshot = await _db
          .collection('Barbershops')
          .doc(barberShopId)
          .collection('Reviews')
          .orderBy('created_at', descending: true)
          .get(); // Fetch the data once

      return snapshot.docs
          .map((doc) => ReviewsModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }

  Future<double> fetchAverageRating(String barberShopId) async {
    try {
      final snapshot = await _db
          .collection('Barbershops')
          .doc(barberShopId)
          .collection('Reviews')
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      // Calculate average rating
      final totalRating = snapshot.docs.fold<double>(
        0.0,
        (sumM, doc) => sumM + (doc['rating'] ?? 0.0),
      );
      return totalRating / snapshot.docs.length;
    } catch (e) {
      throw Exception('Error fetching average rating: $e');
    }
  }

//=========================================================== if the current user is the barbershop
  Stream<List<ReviewsModel>> fetchReviewsStreamBarbershop() {
    try {
      // Listen to changes in the 'Reviews' collection for the specific barbershop
      return _db
          .collection('Barbershops')
          .doc(user)
          .collection('Reviews')
          .orderBy('created_at', descending: true)
          .snapshots() // Use snapshots() for real-time updates
          .map((snapshot) => snapshot.docs
              .map((doc) => ReviewsModel.fromSnapshot(doc))
              .toList());
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }

  Stream<List<ReviewsModel>> fetchReviewsStream(String id) {
    try {
      // Listen to changes in the 'Reviews' collection for the specific barbershop
      return _db
          .collection('Barbershops')
          .doc(id)
          .collection('Reviews')
          .orderBy('created_at', descending: true)
          .snapshots() // Use snapshots() for real-time updates
          .map((snapshot) => snapshot.docs
              .map((doc) => ReviewsModel.fromSnapshot(doc))
              .toList());
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }
}

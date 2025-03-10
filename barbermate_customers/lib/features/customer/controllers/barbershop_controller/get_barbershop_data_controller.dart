import 'package:barbermate_customers/common/widgets/toast.dart';
import 'package:barbermate_customers/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate_customers/data/models/review_model/review_model.dart';
import 'package:barbermate_customers/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate_customers/data/repository/barbershop_repo/haircut_repository.dart';
import 'package:barbermate_customers/data/repository/barbershop_repo/timeslot_repository.dart';
import 'package:barbermate_customers/data/repository/review_repo/review_repo.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class GetBarbershopDataController extends GetxController {
  static GetBarbershopDataController get instance => Get.find();

  final HaircutRepository _haircutRepository = Get.find();
  final TimeslotRepository _timeslotRepository = Get.find();
  final ReviewRepo _repo = Get.find();

  RxList<HaircutModel> haircuts = <HaircutModel>[].obs;
  RxList<TimeSlotModel> timeSlots = <TimeSlotModel>[].obs;
  final reviewsList = <ReviewsModel>[].obs;

  Rx<SfRangeValues> selectedRange = const SfRangeValues(0.0, 500.0).obs;

  List<HaircutModel> getFilteredHaircuts() {
    return haircuts
        .where((haircut) =>
            haircut.price >= selectedRange.value.start &&
            haircut.price <= selectedRange.value.end)
        .toList();
  }

  final isLoading = false.obs;
  RxMap<String, double> averageRatings = <String, double>{}.obs;

  // fetch barbershop haicuts

  void fetchHaircuts({
    required String barberShopId,
    required bool descending,
  }) {
    try {
      isLoading(true); // Show loading indicator

      // Fetch the haircuts stream from the repository
      _haircutRepository
          .fetchHaircutsforCustomers(
        barberShopId,
        descending: descending,
      )
          .listen(
        (haircutsList) {
          // Update the list of haircuts dynamically
          haircuts.assignAll(haircutsList);
        },
        onError: (error) {
          // Handle any error that occurs during the fetch
          ToastNotif(
            message: 'Error fetching haircuts: $error',
            title: 'Error',
          ).showErrorNotif(Get.context!);
        },
      );
    } catch (error) {
      // Handle unexpected errors
      ToastNotif(
        message: 'Unexpected error: $error',
        title: 'Error',
      ).showErrorNotif(Get.context!);
    } finally {
      isLoading(false); // Stop loading regardless of success or error
    }
  }

  // fetch time slot
  void fetchTimeSlots(String barberShopId) {
    isLoading.value = true; // Start loading indicator

    try {
      // Listen to the time slots stream
      _timeslotRepository.fetchBarbershopTimeSlotsStream(barberShopId).listen(
        (timeSlotsList) {
          timeSlots(timeSlotsList); // Update the timeSlots list
        },
        onError: (error) {
          // Show error notification on stream error
          ToastNotif(
            message: 'Error Fetching TimeSlots: $error',
            title: 'Error',
          ).showErrorNotif(Get.context!);
        },
      );
    } catch (e) {
      // Handle unexpected errors
      ToastNotif(
        message: 'Unexpected Error: $e',
        title: 'Error',
      ).showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false; // Stop loading indicator
    }
  }

  // fetch reviews
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

  void calculateAverageRating(List<ReviewsModel> reviews, String barbershopId) {
    if (reviews.isEmpty) {
      averageRatings[barbershopId] = 0.0;
      return;
    }

    // Sum up all ratings and calculate average
    double totalRating =
        reviews.fold(0.0, (sum, review) => sum + (review.rating));
    double avgRating = totalRating / reviews.length;

    averageRatings[barbershopId] = double.parse(
      avgRating.toStringAsFixed(1),
    );
  }
}

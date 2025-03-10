import 'dart:async';
import 'package:barbermate_admin/data/models/barbershops_verfication_model/document_model.dart';
import 'package:barbermate_admin/data/models/review_model/review_model.dart';
import 'package:barbermate_admin/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:barbermate_admin/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate_admin/data/repository/review_repo/review_repo.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/barbershop_repo.dart';

class BarbershopController extends GetxController {
  static BarbershopController get instance => Get.find();

  // Variables
  final profileLoading = false.obs;
  final NotificationsRepo _repo = Get.find();
  RxList<BarbershopModel> barbershops = <BarbershopModel>[].obs;
  final BarbershopRepository barbershopRepository = Get.find();
  final ReviewRepo reviewRepo = Get.find();
  var isLoading = true.obs;
  var reviews = <ReviewsModel>[].obs;
  final Logger logger = Logger();
  var error = ''.obs;

  var documents = <BarbershopDocumentModel>[].obs;

  late StreamSubscription<List<ReviewsModel>> _reviewsSubscription;

  @override
  void onInit() async {
    super.onInit();
    listenToBarbershopStream();
    fetchReviewsForBarbershop();
    // fetchReviewsForBarbershop();
  }

  // Fetch Barbershop Data
  void listenToBarbershopStream() {
    isLoading(true); // Show loading indicator

    // Fetch the specific barbershop by its ID
    barbershopRepository.fetchAllBarbershopsFromAdmin().listen(
        (barbershopData) {
      barbershops(barbershopData); // Update the customer data when it changes
      // Once the first data comes in, stop loading
      if (isLoading.value) {
        isLoading(false);
      } // Hide loading spinner
    }, onError: (error) {
      logger.e("Error fetching barbershop by ID: $error");
      isLoading(false); // Hide loading spinner in case of error
    });
  }

  // Fetch documents from the repository and store them in 'documents'
  Future<void> loadDocuments(String barbershopId) async {
    try {
      // Fetch documents from the repository
      List<BarbershopDocumentModel> docs =
          await barbershopRepository.fetchDocuments(barbershopId);

      // Store documents in GetX variable
      documents.value = docs;
    } catch (e) {
      print("Error loading documents: $e");
      // Optionally, you can show a user-friendly error message or handle the error more gracefully
    }
  }

  Future<void> updateDocumentStatus(
      BarbershopDocumentModel document,
      String status,
      String? notes,
      List<String>? reasons,
      String barbershopId,
      String barbershopToken) async {
    try {
      await barbershopRepository.updateDocumentStatus(
          document, status, barbershopId);
      await _repo.sendNotifWhenStatusUpdated(
          'barbershop-status',
          barbershopId,
          'Document Status',
          'Your document ${document.documentType} is $status',
          notes,
          reasons,
          'notRead',
          barbershopToken);

      ToastNotif(
        message: 'Status updated successfully.',
        title: 'Success',
      ).showSuccessNotif(Get.context!);
      Get.back();
    } catch (e) {
      ToastNotif(
        message: e.toString(),
        title: 'Error',
      ).showErrorNotif(Get.context!);
      print("Error updating documents: $e");
    }
  }

  // Method to open the file URL
  Future<void> openFile(Uri? url) async {
    if (await canLaunchUrl(url!)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // // Method to fetch reviews for a specific barbershop
  void fetchReviewsForBarbershop() {
    isLoading(true); // Set loading to true when fetching

    // Start listening to the reviews stream from the repository
    _reviewsSubscription = reviewRepo.fetchReviewsStreamBarbershop().listen(
      (reviewsData) {
        reviews.value = reviewsData; // Update the reviews with fetched data
        isLoading(false); // Set loading to false once data is fetched
      },
      onError: (error) {
        // Handle error (you can show an error message or log it)
        print("Error fetching reviews: $error");
        isLoading(false); // Stop loading even if an error occurs
      },
    );
  }

  // Update a single fied
  Future<void> updateSingleFieldBarbershop(String barbershopId, String? notes,
      List<String>? reasons, String barbershopToken, String status) async {
    try {
      await barbershopRepository.updateBarbershopSingleField(
          barbershopId, status);
      await _repo.sendNotifWhenStatusUpdated(
          'barbershop-status',
          barbershopId,
          'Barbershop Status',
          'Your barbershop account has been $status',
          notes,
          reasons,
          'notRead',
          barbershopToken);
      ToastNotif(
        message: 'Status updated successfully.',
        title: 'Success',
      ).showSuccessNotif(Get.context!);
      Get.back();
    } catch (e) {
      ToastNotif(
        message: e.toString(),
        title: 'Error',
      ).showErrorNotif(Get.context!);
    }
  }

  @override
  void onClose() {
    // Cancel the stream when the controller is disposed
    _reviewsSubscription.cancel();
    super.onClose();
  }
}

import 'dart:async';
import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:barbermate/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/barbershop_repo.dart';

class BarbershopController extends GetxController {
  static BarbershopController get instance => Get.find();

  // Variables
  final profileLoading = false.obs;
  Rx<BarbershopModel> barbershop = BarbershopModel.empty().obs;
  final BarbershopRepository barbershopRepository = Get.find();
  final ReviewRepo reviewRepo = Get.find();
  final _authRepository = Get.put(AuthenticationRepository());
  var isLoading = true.obs;
  var reviews = <ReviewsModel>[].obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  final address = TextEditingController();
  final floors = TextEditingController();
  final landmark = TextEditingController();
  final barbershopName = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final hidePassword = true.obs;
  final ImagePicker _picker = ImagePicker();
  final Logger logger = Logger();
  var error = ''.obs;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  late StreamSubscription<List<ReviewsModel>> _reviewsSubscription;

  @override
  void onInit() async {
    super.onInit();
    listenToBarbershopStream();
    fetchReviewsForBarbershop();
    // fetchReviewsForBarbershop();
  }

  void clear() async {
    firstName.value = TextEditingValue.empty;
    lastName.value = TextEditingValue.empty;
    email.value = TextEditingValue.empty;
    password.value = TextEditingValue.empty;
    number.value = TextEditingValue.empty;
    address.value = TextEditingValue.empty;
    floors.value = TextEditingValue.empty;
    landmark.value = TextEditingValue.empty;
    barbershopName.value = TextEditingValue.empty;
    currentPasswordController.value = TextEditingValue.empty;
    newPasswordController.value = TextEditingValue.empty;
  }

  // update the exist field to make the profile setup only once
  void makeBarbershopExist() async {
    await barbershopRepository.makeBarbershopExist();
  }

  Future<void> uploadImage(String type) async {
    try {
      // Pick an image from the gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        return;
      } else {
        ToastNotif(message: 'Your image is uploading', title: 'Uploading')
            .showSuccessNotif(Get.context!);
      }

      // Upload the image to Firebase Storage
      final downloadUrl = await barbershopRepository.uploadImageToStorage(
          XFile(pickedFile.path), type);
      if (downloadUrl != null) {
        // Update Firestore with the image URL
        await barbershopRepository.updateProfileImageInFirestore(
            downloadUrl, type);

        ToastNotif(
                message: 'Profile image updated successfully', title: 'Success')
            .showSuccessNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(message: 'Failed to upload profile image', title: 'Error')
          .showSuccessNotif(Get.context!);
    }
  }

  // Fetch Barbershop Data
  void listenToBarbershopStream() {
    isLoading(true); // Show loading indicator

    // Fetch the specific barbershop by its ID
    barbershopRepository.barbershopDetailsStream().listen((barbershopData) {
      barbershop(barbershopData); // Update the customer data when it changes
      // Once the first data comes in, stop loading
      if (isLoading.value) {
        isLoading(false);
      } // Hide loading spinner
    }, onError: (error) {
      logger.e("Error fetching barbershop by ID: $error");
      isLoading(false); // Hide loading spinner in case of error
    });
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

  // Save Barbershop data from any registration provider
  Future<void> saveBarbershopData({
    String? firstNamee,
    String? lastNamee,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final existingData = barbershop.value;

        // Create an updated model only with the fields you want to change
        final updatedBarbershop = existingData.copyWith(
          firstName: firstNamee ?? barbershop.value.firstName,
          lastName: lastNamee ?? barbershop.value.lastName,
        );

        // Update the barbershop data in Firestore
        await barbershopRepository.updateBarbershopData(updatedBarbershop);
        ToastNotif(message: 'Update Successful', title: 'Success')
            .showSuccessNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(
              message: 'Someting went wrong while saving your information. $e.',
              title: 'Data not saved')
          .showWarningNotif(Get.context!);
    }
  }

  // Update a single fied
  Future<void> updateSingleFieldBarbershop(Map<String, dynamic> json) async {
    try {
      await barbershopRepository.updateBarbershopSingleField(json);

      ToastNotif(
        message: 'Field updated successfully.',
        title: 'Success',
      ).showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(
        message: e.toString(),
        title: 'Error',
      ).showErrorNotif(Get.context!);
    }
  }

  // change password
  Future<void> changePassword() async {
    try {
      profileLoading.value = true;

      // Call the repository method to change the password
      await _authRepository.changePassword(
          currentPasswordController.text.trim(),
          newPasswordController.text.trim());
    } catch (e) {
      // Show an error message if something went wrong
      ToastNotif(
              message: 'Failed to change password: ${e.toString()}',
              title: 'Error')
          .showWarningNotif(Get.context!);
    } finally {
      profileLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Cancel the stream when the controller is disposed
    _reviewsSubscription.cancel();
    super.onClose();
  }
}

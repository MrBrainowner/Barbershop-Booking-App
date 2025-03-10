import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/haircut_repository.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../barbershop_controller/barbershop_controller.dart';

class HaircutController extends GetxController {
  static HaircutController get instance => Get.find();
  final BarbershopController barbershopController = Get.find();
  final HaircutRepository _haircutRepository = Get.find();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  Rx<File?> selectedImage = Rx<File?>(null);

  RxList<HaircutModel> haircuts = <HaircutModel>[].obs;
  final ImagePicker picker = ImagePicker();
  var isLoading = true.obs;
  var imageUrl = ''.obs; // Now stores only a single image URL
  var selectedCategories = <String>[].obs;

  GlobalKey<FormState> addHaircutFormKey = GlobalKey<FormState>();

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void onInit() async {
    super.onInit();
    subscribeToHaircuts();
    print('initialize haircut');
  }

  void resetForm() {
    nameController.clear();
    priceController.clear();
    durationController.clear();
    selectedImage.value = null; // Reset image URL
  }

  void updateSelectedCategories(List<String> categories) {
    selectedCategories.value = categories;
  }

  Future<void> addHaircut() async {
    if (!addHaircutFormKey.currentState!.validate() ||
        selectedCategories.isEmpty) {
      ToastNotif(message: 'Fields and categories are required', title: 'Error')
          .showWarningNotif(Get.context!);
      return;
    } else if (selectedImage.value == null) {
      // Show a warning if no image is selected
      ToastNotif(message: 'Please upload an image', title: 'Error')
          .showWarningNotif(Get.context!);
      return;
    }
    try {
      FullScreenLoader.openLoadingDialog(
          'Adding Haircut...', 'assets/images/animation.json');
      // Create a HaircutModel with initial data
      final haircut = HaircutModel(
        name: nameController.text,
        price: double.parse(priceController.text),
        duration: int.parse(durationController.text),
        category: selectedCategories,
        imageUrl: '', // Initially empty
        createdAt: DateTime.now(),
        id: '',
      );

      // Add the haircut model to Firestore and get the document ID
      final haircutId = await _haircutRepository.addHaircut(haircut);

      // Upload image if any image has been selected

      final imageUrl = await _haircutRepository.uploadImageToStorage(
          XFile(selectedImage.value!.path),
          haircutId); // Pass XFile to the repository

      // Update the image URL in Firestore if the upload is successful
      await _haircutRepository.updateHaircutImage(haircutId, imageUrl);

      ToastNotif(
              message: 'Haircut added successfully', title: 'New Haircut Added')
          .showSuccessNotif(Get.context!);
      resetForm();
      Get.back();
    } catch (e) {
      ToastNotif(message: e.toString(), title: 'Error adding haircut')
          .showErrorNotif(Get.context!);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  Future<void> updateHaircut(HaircutModel haircut) async {
    if (!addHaircutFormKey.currentState!.validate() ||
        selectedCategories.isEmpty) {
      ToastNotif(message: 'Fields and categories are required', title: 'Error')
          .showWarningNotif(Get.context!);
      return;
    } else if (haircut.imageUrl.isEmpty) {
      // Show a warning if no image is selected
      ToastNotif(message: 'Please upload an image', title: 'Error')
          .showWarningNotif(Get.context!);
      return;
    }
    try {
      FullScreenLoader.openLoadingDialog(
          'Updating Haircut...', 'assets/images/animation.json');
      XFile? newImageFile;

      // Convert Rx<File?> to XFile if a new image is selected
      if (selectedImage.value != null) {
        newImageFile = XFile(selectedImage.value!.path);
      }

      // Create the updated haircut model
      final haircutUpdate = haircut.copyWith(
        name: nameController.text,
        price: double.parse(priceController.text),
        duration: int.parse(durationController.text),
        category: selectedCategories,
        imageUrl: '', // Update image URL if necessary
      );

      // Update the haircut model in Firestore
      await _haircutRepository.updateHaircut(
          haircutId: haircut.id.toString(),
          updatedHaircut: haircutUpdate,
          newImageFile: newImageFile);

      ToastNotif(
              message: 'Haircut updated successfully', title: 'Haircut Updated')
          .showSuccessNotif(Get.context!);

      Get.back(); // Close the update screen
    } catch (e) {
      ToastNotif(message: 'Error updating haircut', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  Future<void> deleteHaircut(String haircutId) async {
    FullScreenLoader.openLoadingDialog(
        'Deleting Haircut...', 'assets/images/animation.json');

    try {
      await _haircutRepository.deleteHaircut(haircutId);
      ToastNotif(
              message: 'Haircut deleted successfully', title: 'Haircut Deleted')
          .showSuccessNotif(Get.context!);

      resetForm();
      Get.back();
    } catch (e) {
      ToastNotif(message: 'Error deleting haircut', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  void subscribeToHaircuts() {
    isLoading(true); // Start the loading indicator

    _haircutRepository.fetchAllHaircuts().listen(
      (haircutsListss) {
        if (haircutsListss.isNotEmpty) {
          // Update the list of haircuts
          haircuts.assignAll(haircutsListss);
          isLoading(false); // Stop loading once data is received
        }
      },
      onError: (error) {
        // Handle errors in the stream
        logger.e(error.toString());
        ToastNotif(message: 'Error fetching haircuts: $error', title: 'Error')
            .showErrorNotif(Get.context!);
        isLoading(false); // Stop loading on error
      },
      onDone: () {
        // Optionally handle stream completion if necessary
        if (haircuts.isEmpty) {
          isLoading(false); // Ensure loading stops if no data arrives
        }
      },
    );
  }

  // Future<void> fetchHaircutsOnce() async {
  //   try {
  //     isLoading(true); // Show loading indicator

  //     // Fetch the haircuts once from the repository
  //     final haircutsList = await _haircutRepository.fetchHaircutsOnce();

  //     // Update the list of haircuts
  //     haircuts.assignAll(haircutsList);
  //   } catch (error) {
  //     // Handle error if any occurs during the fetch
  //     ToastNotif(message: 'Error fetching haircuts: $error', title: 'Error')
  //         .showErrorNotif(Get.context!);
  //   } finally {
  //     isLoading(false); // Stop loading regardless of success or error
  //   }
  // }
}

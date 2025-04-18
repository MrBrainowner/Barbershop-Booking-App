import 'dart:io';
import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/barbershops_verfication_model/document_model.dart';
import 'package:barbermate/data/repository/barbershop_repo/documents_verification_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/utils/popups/full_screen_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();
  final VerificationRepo verificationRepo = Get.find();
  final Logger logger = Logger();
  final NotificationsRepo _repo = Get.find();
  final BarbershopController barbershop = Get.find();

  // List of required document types
  final List<String> requiredDocumentTypes = [
    'business_registration',
    'barangay_clearance',
    'mayors_permit',
  ].obs;

  // final RxMap<String, File?> businessRegistration = <String, File?>{}.obs;
  // final RxMap<String, File?> barangayClearance = <String, File?>{}.obs;
  // final RxMap<String, File?> mayorsPermit = <String, File?>{}.obs;

  var documents = <BarbershopDocumentModel>[].obs;
  // A map to hold selected files for each document type
  final RxMap<String, File?> selectedFiles = <String, File?>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDocuments();
  }

  // Fetch documents from the repository and store them in 'documents'
  Future<void> loadDocuments() async {
    try {
      List<BarbershopDocumentModel> docs =
          await verificationRepo.fetchDocuments();
      documents.value = docs;

      // Map existing document paths to selectedFiles for each type
      for (var doc in docs) {
        selectedFiles[doc.documentType] = File(doc.documentURL);
      }
      selectedFiles.refresh();
    } catch (e) {
      logger.e("Error loading documents: $e");
    }
  }

  // Pick file for a document
  Future<void> pickFile(String documentType) async {
    try {
      debugPrint('test');
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        // Update the map and trigger reactivity
        selectedFiles[documentType] = File(result.files.single.path!);
        selectedFiles.refresh(); // Important to trigger UI updates
        logger
            .i('File selected for $documentType: ${result.files.single.path}');
      } else {
        logger.w('No file selected for $documentType');
      }
    } catch (e) {
      logger.e('Error picking file for $documentType: $e');
    }
  }

  // Submit the uploaded files
  Future<void> submitFiles() async {
    // Ensure all required documents are selected before submitting
    for (var documentType in requiredDocumentTypes) {
      if (selectedFiles[documentType] == null) {
        ToastNotif(
                message: 'Please select the $documentType document',
                title: 'Missing Document')
            .showErrorNotif(Get.context!);
        return;
      }
    }

    try {
      FullScreenLoader.openLoadingDialog(
          'Uploading Files...', 'assets/images/animation.json');

      // Upload all selected files for the required documents
      for (var documentType in requiredDocumentTypes) {
        final file = selectedFiles[documentType];
        if (file != null) {
          await verificationRepo.uploadFile(file, documentType);
        }
      }

      logger.i('All files uploaded successfully');
      ToastNotif(message: 'File Upload Successful', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      FullScreenLoader.stopLoading();
      logger.e('Error uploading files: $e');
      ToastNotif(message: e.toString(), title: 'Upload Failed')
          .showErrorNotif(Get.context!);
    } finally {
      Get.back();
      FullScreenLoader.stopLoading();
    }
  }

  Future<void> sendNotifWhenBookingUpdated(
      String type,
      String barbershopId,
      String title,
      String message,
      List<String> reasons,
      String barbershopToken) async {
    try {
      await _repo.sendNotifWhenStatusUpdated(
          type, barbershopId, title, message, reasons, 'notRead');
    } catch (e) {
      ToastNotif(message: 'Error Sending Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }
}

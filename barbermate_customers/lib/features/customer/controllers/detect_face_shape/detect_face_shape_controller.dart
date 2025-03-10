import 'dart:io';
import 'package:barbermate_customers/data/models/combined_model/barber_haircut.dart';
import 'package:barbermate_customers/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate_customers/data/models/review_model/review_model.dart';
import 'package:barbermate_customers/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:barbermate_customers/data/repository/review_repo/review_repo.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rxdart/rxdart.dart' as rx;

class DetectFaceShape extends GetxController {
  static DetectFaceShape get instance => Get.find();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString faceShapeResult = ''.obs;
  RxString faceShapeDescription = ''.obs;
  final ImagePicker picker = ImagePicker();
  var confidence = 0.0;
  var label = '';
  Logger logger = Logger();
  var predictions = <String, double>{}.obs;
  var recommendedHairstyles = <String>[].obs; // Recommended hairstyles
  var isLoading = true.obs;

  final BarbershopRepository _barbershopRepository = Get.find();
  final ReviewRepo _reviewRepository = Get.find();

  RxList<BarbershopHaircut> barbershopCombinedModel = <BarbershopHaircut>[].obs;

  final Map<String, Map<String, dynamic>> faceShapeRecommendations = {
    'Oval': {
      'description':
          "With an oval face shape, you have the versatility to rock almost any hairstyle. Styles like the Pompadour, Quiff, Undercut, Side Part, and Tapered Cuts highlight your balanced proportions. If you prefer shorter cuts, go for a Crew Cut or a Buzz Cut. Medium to long styles, like the Man Bun or Swept-Back looks, also suit you perfectly.",
      'hairstyles': [
        'Pompadour',
        'Quiff',
        'Undercut',
        'Side Part',
        'Tapered Cuts',
        'Buzz Cut',
        'Crew Cut',
        'Man Bun',
        'Swept-Back',
      ],
    },
    'Rectangle': {
      'description':
          "For a rectangular face shape, balance the length of your face with styles that add volume on the sides or texture on top. Try a Textured Crop, Fringe, or a Side Part for a softer look. Medium-length styles like the Pompadour and Quiff are also flattering. Avoid overly short sides to keep your features proportionate.",
      'hairstyles': [
        'Textured Crop',
        'Fringe',
        'Side Part',
        'Pompadour',
        'Quiff',
      ],
    },
    'Round': {
      'description':
          "For a round face shape, choose hairstyles that add height and angles to elongate your appearance. The Pompadour, Quiff, Faux Hawk, and Mohawk are excellent choices. Side Part and Undercut styles can also create structure. Avoid cuts that add width to the sides, such as very short crops.",
      'hairstyles': [
        'Pompadour',
        'Quiff',
        'Faux Hawk',
        'Mohawk',
        'Side Part',
        'Undercut',
      ],
    },
    'Square': {
      'description':
          "Square face shapes are characterized by a strong jawline and angular features. Highlight your structure with sharp and clean styles like the Fade, Ivy League, or Regulation Cut. Medium styles like the Side Part, Pompadour, or Fringe add balance, while buzz cuts enhance the strong shape.",
      'hairstyles': [
        'Fade',
        'Ivy League',
        'Regulation Cut',
        'Side Part',
        'Pompadour',
        'Fringe',
        'Buzz Cut',
      ],
    },
  };

  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true, // Enable if you want additional face data
      enableClassification: false,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    _tfliteInit();
    fetchAllBarbershopData();
  }

  void fetchAllBarbershopData() {
    isLoading(true);

    _barbershopRepository.fetchAllBarbershopsFromAdmin().listen(
        (barbershopList) {
      List<Stream<BarbershopHaircut>> barbershopDataStreams =
          barbershopList.map((barbershop) {
        // Fetch haircut, timeslot, and review streams for each barbershop
        Stream<List<HaircutModel>> haircutsStream =
            _barbershopRepository.fetchBarbershopHaircuts(barbershop.id);
        Stream<List<ReviewsModel>> reviewsStream =
            _reviewRepository.fetchReviewsStream(barbershop.id);

        // Combine all streams for a single barbershop
        return rx.CombineLatestStream.combine2<List<HaircutModel>,
            List<ReviewsModel>, BarbershopHaircut>(
          haircutsStream,
          reviewsStream,
          (haircuts, reviews) {
            logger.i('Barbershop ID: ${barbershop.id}');
            logger.i('Haircuts (${haircuts.length}): $haircuts');

            logger.i('Reviews (${reviews.length}): $reviews');

            return BarbershopHaircut(
              barbershop: barbershop,
              haircuts: haircuts,
              review: reviews,
            );
          },
        );
      }).toList();

      // Combine all barbershops data streams
      rx.CombineLatestStream(
        barbershopDataStreams,
        (List<BarbershopHaircut> combinedList) => combinedList,
      ).listen((result) {
        barbershopCombinedModel.assignAll(result);
        isLoading(false); // Hide loading spinner
      }, onError: (error) {
        logger.e("Error fetching combined data: $error");
        isLoading(false);
      });
    }, onError: (error) {
      logger.e("Error fetching barbershops: $error");
      isLoading(false);
    });
  }

  Future<void> selectImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      bool faceDetected = await _detectFace(image.path); // Check for face
      if (faceDetected) {
        runModel(image.path); // Run the model only if a face is detected
      } else {
        faceShapeResult.value = "No face detected.";
        logger.e("No face detected in the selected image.");
        predictions.clear();
        recommendedHairstyles.clear();
        faceShapeDescription.value = '';
      }
    }
  }

  Future<void> openCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImage.value = File(image.path);
      bool faceDetected = await _detectFace(image.path); // Check for face
      if (faceDetected) {
        runModel(image.path); // Run the model only if a face is detected
      } else {
        faceShapeResult.value = "No face detected.";
        logger.e("No face detected in the captured image.");
        predictions.clear();
        recommendedHairstyles.clear();
        faceShapeDescription.value = '';
      }
    }
  }

  Future<bool> _detectFace(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        logger.i("Face(s) detected in the image.");
        return true; // Return true if a face is detected
      } else {
        logger.e("No face detected.");
        return false;
      }
    } catch (e) {
      logger.e("Face detection failed: $e");
      return false;
    }
  }

  Future<void> _tfliteInit() async {
    String? result = await Tflite.loadModel(
      model: "assets/models/model_unquant.tflite",
      labels: "assets/models/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    logger.e("TFLite Model Loaded: $result");
  }

  Future<void> runModel(String imagePath) async {
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 4,
      threshold: 0.2,
      asynch: true,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      // Clear previous data
      predictions.clear();
      recommendedHairstyles.clear();

      for (var result in recognitions) {
        double confidencePercentage = (result['confidence'] * 100);
        String label = result['label'];
        predictions[label] = confidencePercentage;
      }

      // Determine the top prediction
      var topResult = recognitions[0];
      double confidence = (topResult['confidence'] * 100);
      String label = topResult['label'];

      faceShapeResult.value = "$label: ${confidence.toStringAsFixed(2)}%";

      // Get recommendations based on the detected face shape
      if (faceShapeRecommendations.containsKey(label)) {
        var recommendation = faceShapeRecommendations[label];
        recommendedHairstyles.addAll(recommendation!['hairstyles']);
        faceShapeDescription.value = recommendation['description'] as String;
      } else {
        faceShapeDescription.value =
            "Sorry, we don't have recommendations for this face shape.";
      }

      logger.i("Predictions updated: $predictions");
      logger.i("Top Prediction: ${faceShapeResult.value}");
      logger.i("Recommended Hairstyles: $recommendedHairstyles");
      logger.i("Face Shape Description: ${faceShapeDescription.value}");
    } else {
      faceShapeResult.value = "No results from the model.";
      predictions.clear();
      recommendedHairstyles.clear();
      faceShapeDescription.value = "Unable to detect a face shape.";
      logger.e("No results from the model.");
    }
  }

  @override
  void onClose() {
    super.onClose();
    faceDetector.close(); // Close ML Kit face detector
    Tflite.close(); // Unload model when controller is closed
  }
}

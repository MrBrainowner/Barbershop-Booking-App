import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../../../data/repository/barbershop_repo/barbershop_repo.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../data/models/user_authenthication_model/barbershop_model.dart';
import '../../views/email_verification/email_verification.dart';
import 'network_manager.dart';

class BarbershopSignUpController extends GetxController {
  static BarbershopSignUpController get instance => Get.find();

  //======================================= Variables
  final barbershopName = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final landMark = TextEditingController();
  final businessLicenseNumber = TextEditingController();
  final floorUnit = TextEditingController();
  final streetAddress = TextEditingController();
  final hidePassword = true.obs;
  final mapController = MapController();

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> signUpFormKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> signUpFormKey3 = GlobalKey<FormState>();

  final selectedAddress = ''.obs; // Holds the address
  final selectedLatLng = const LatLng(7.449564938212336, 125.8078227665786).obs;
  final markers = <Marker>[].obs;

  // Boundary for Tagum City
  final bounds = LatLngBounds(
    const LatLng(7.403583177421027, 125.75984051277152),
    const LatLng(7.491435195356264, 125.84387165498403),
  );

// Inside your BarbershopSignUpController class

  Future<void> getCurrentLocation() async {
    try {
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        ToastNotif(
                message: 'Location services are disabled on your device.',
                title: 'Error')
            .showErrorNotif(Get.context!);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          ToastNotif(
                  message: 'Location permissions are permanently denied.',
                  title: 'Error')
              .showErrorNotif(Get.context!);
          return;
        } else if (permission == LocationPermission.denied) {
          ToastNotif(message: 'Location permission is denied.', title: 'Error')
              .showErrorNotif(Get.context!);
          return;
        }
      }

      // Define Android-specific location settings
      final locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        forceLocationManager: false,
        intervalDuration: const Duration(seconds: 10),
        timeLimit: const Duration(days: 1),
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      final newLatLng = LatLng(position.latitude, position.longitude);
      selectedLatLng.value = newLatLng;
      streetAddress.text = '${position.latitude}, ${position.longitude}';

      if (bounds.contains(newLatLng)) {
        streetAddress.text = '${position.latitude}, ${position.longitude}';

        // Update map center and zoom level
        mapController.move(newLatLng, 14.0);

        // Place marker
        markers.clear();
        markers.add(Marker(
          point: newLatLng,
          child: const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          ),
        ));

        ToastNotif(
                message: 'Location is set to your current location.',
                title: 'Success')
            .showSuccessNotif(Get.context!);
        // Call reverse geocoding to update address
        await reverseGeocodeWithMapbox(selectedLatLng.value);
      } else {
        ToastNotif(
                message: 'Current location is outside Tagum.', title: 'Error')
            .showErrorNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(message: 'Could not retrieve location: $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // Reverse geocode the location using Mapbox API
  Future<void> reverseGeocodeWithMapbox(LatLng latLng) async {
    const accessToken =
        'pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY200eDJmaGg1MGlrbzJqcXZjenF0OWpwaCJ9.lc2Iye0e4SRDrU3LMO8DGg';
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${latLng.longitude},${latLng.latitude}.json?access_token=$accessToken';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          final placeName = data['features'][0]['place_name'];
          // Extract street and city information from the place_name
          final address = extractStreetAndCity(placeName);
          selectedAddress.value = address;
          streetAddress.text = address;

          ToastNotif(message: 'Address: $address', title: 'Location Selected')
              .showNormalNotif(Get.context!);
        } else {
          ToastNotif(
                  message: 'No address found for this location', title: 'Error')
              .showErrorNotif(Get.context!);
        }
      } else {
        ToastNotif(
                message:
                    'Failed to reverse geocode location: ${response.statusCode}',
                title: 'Error')
            .showErrorNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(message: 'Failed to fetch address: $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  String extractStreetAndCity(String placeName) {
    final components = placeName.split(',');
    if (components.length >= 2) {
      final streetAddress = components[0].trim();
      final city = components[1].trim();
      // Return street and city combined
      return '$streetAddress, $city';
    } else if (components.isNotEmpty) {
      // If there's no city, return just the street address
      return components[0].trim();
    }
    return placeName;
  }

  // request location persmission
  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are permanently denied, handle this situation

        ToastNotif(
                message: 'Location permissions are permanently denied.',
                title: 'Error')
            .showErrorNotif(Get.context!);
      } else if (permission == LocationPermission.denied) {
        ToastNotif(message: 'Location permission is denied.', title: 'Error')
            .showErrorNotif(Get.context!);
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Permission granted, proceed to get location
      await getCurrentLocation();
    }
  }

  // Set location on tap and reverse geocode it
  void setSelectedLocation(_, LatLng latLng) async {
    selectedLatLng.value = latLng;

    // Temporarily comment this part to disable Tagum boundary check
    if (bounds.contains(latLng)) {
      markers.clear();
      markers.add(Marker(
        point: latLng,
        child: const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 40,
        ),
      ));

      // Call the Mapbox reverse geocoding function
      await reverseGeocodeWithMapbox(latLng);
    } else {
      ToastNotif(message: 'Location is outside Tagum', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  //======================================= SignUp

  void signUp() async {
    try {
      //======================================= Start Loading
      FullScreenLoader.openLoadingDialog(
          'We are processing your information...',
          'assets/images/animation.json');

      //======================================= Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      //======================================= Form Validation
      if (!signUpFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      //======================================= Privacy Policy

      //======================================= Register User and save data to Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      //======================================= Save Authenticated user data to Firebase Firestore
      final newBarbershop = BarbershopModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        phoneNo: phone.text.trim(),
        role: 'barbershop',
        createdAt: DateTime.now(),
        barbershopName: barbershopName.text.trim(),
        barbershopProfileImage: '',
        barbershopBannerImage: '',
        status: 'new',
        longitude: selectedLatLng.value.longitude,
        latitude: selectedLatLng.value.latitude,
        landMark: landMark.text.trim(),
        streetAddress: streetAddress.text.trim(),
        floorNumber: floorUnit.text.trim(),
        profileImage: '',
        existing: false,
      );

      final userRepository = Get.put(BarbershopRepository());
      await userRepository.saveBarbershopData(newBarbershop);

      //======================================= remove loader
      FullScreenLoader.stopLoading();

      //======================================= Show Toast Success
      ToastNotif(
              message:
                  'Your account has been created! Verify email to continue',
              title: 'Verify your Email!')
          .showSuccessNotif(Get.context!);

      //======================================= Move to Verify Email Page
      Get.to(() => EmailVerification(email: email.text.trim()));
    } catch (e) {
      //======================================= remove loader
      FullScreenLoader.stopLoading();

      //======================================= Show Error to User
      ToastNotif(message: e.toString(), title: 'Oh Snap!')
          .showErrorNotif(Get.context!);
    }
  }
}

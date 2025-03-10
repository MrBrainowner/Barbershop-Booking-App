import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationService extends GetxController {
  static LocationService get instance => Get.find();
  final Location _location = Location();
  var heading = 0.0.obs;
  Rx<LatLng?> liveLocation = Rx<LatLng?>(null);

  @override
  void onInit() async {
    super.onInit();
    await getCurrentLocation();
    _listenToLocationChanges();
  }

  Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return null;
    }

    // Check if permission is granted
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    // Get the current location
    final locationData = await _location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      if (locationData.heading != null) {
        // Convert heading from degrees to radians
        heading.value = locationData.heading! * (3.14159265359 / 180);
      }

      return LatLng(locationData.latitude!, locationData.longitude!);
    }

    return null;
  }

  void _listenToLocationChanges() {
    _location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        liveLocation.value =
            LatLng(locationData.latitude!, locationData.longitude!);
      }

      if (locationData.heading != null) {
        // Update heading as radians
        heading.value = locationData.heading! * (3.14159265359 / 180);
      }
    });
  }
}

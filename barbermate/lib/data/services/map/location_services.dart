import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationService extends GetxController {
  static LocationService get instance => Get.find();
  final Location _location = Location();

  Rx<LatLng?> liveLocation = Rx<LatLng?>(null);

  @override
  void onInit() {
    super.onInit();
    _listenToLocationChanges();
  }

  Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return null;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    final locationData = await _location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  void _listenToLocationChanges() {
    _location.onLocationChanged.listen((locationData) {
      liveLocation.value =
          LatLng(locationData.latitude!, locationData.longitude!);
    });
  }
}

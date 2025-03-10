import 'package:barbermate_customers/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershop_data_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershops_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate_customers/features/customer/views/booking/choose_haircut.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../../data/services/map/direction_services.dart';
import '../../../../data/services/map/location_services.dart';

class GetDirectionsController extends GetxController {
  static GetDirectionsController get instace => Get.find();
  final LocationService _locationService = Get.find();
  final DirectionsService _directionsService = Get.find();
  final GetBarbershopsController barbershopsController = Get.find();

  Rx<LatLng?> selectedBarbershopLocation = Rx<LatLng?>(null);
  RxList<LatLng> routeCoordinates = <LatLng>[].obs;
  RxMap<int, double> barbershopDistances = <int, double>{}.obs;

  var markers = <Marker>[].obs;
  var polylines = <Polyline>[].obs;
  var polygons = <Polygon>[].obs;
  var isAscending = true.obs;

  final bounds = LatLngBounds(
    const LatLng(7.678178606609754, 126.04005688502966),
    const LatLng(7.219967451991697, 125.53193922489729),
  );

  final mapController = MapController();

  // Threshold distance in meters to trigger updates
  final double distanceThreshold = 100.0;

  @override
  void onInit() async {
    super.onInit();

    // Initialize distances
    await calculateAllDistances();

    // Listen to live location updates
    _locationService.liveLocation.listen((newLocation) async {
      if (newLocation != null) {
        final previousLocation = _locationService.liveLocation.value;

        // Update location and trigger recalculation only if user moves by threshold
        if (previousLocation == null ||
            Geolocator.distanceBetween(
                  previousLocation.latitude,
                  previousLocation.longitude,
                  newLocation.latitude,
                  newLocation.longitude,
                ) >
                distanceThreshold) {
          _locationService.liveLocation.value = newLocation;

          // Recalculate all distances only after significant movement
          await calculateAllDistances();

          if (selectedBarbershopLocation.value != null) {
            fetchDirectionsPolygon(selectedBarbershopLocation.value!);
          }
        }
      }
    });
  }

  // Sort barbershops by distance
  void sortBarbershops() {
    final sortedEntries = barbershopDistances.entries.toList()
      ..sort((a, b) => isAscending.value
          ? a.value.compareTo(b.value)
          : b.value.compareTo(a.value));
    barbershopDistances.value = Map.fromEntries(sortedEntries);
  }

  // Toggle sorting order
  void toggleSortingOrder() {
    isAscending.value = !isAscending.value;
    sortBarbershops();
  }

  Future<void> calculateAllDistances() async {
    if (_locationService.liveLocation.value == null) return;

    for (int i = 0; i < barbershopsController.barbershop.length; i++) {
      final distance = await _directionsService.getDistance(
          _locationService.liveLocation.value!,
          LatLng(barbershopsController.barbershop[i].latitude,
              barbershopsController.barbershop[i].longitude));

      if (distance != null) {
        barbershopDistances[i] = distance;
      }
    }

    update();
  }

  Future<void> fetchDirectionsPolygon(LatLng destination) async {
    if (_locationService.liveLocation.value == null) return;
    routeCoordinates.value = await _directionsService.fetchDirections(
        _locationService.liveLocation.value!, destination);
    update();
  }

  void selectBarbershop(LatLng location) {
    selectedBarbershopLocation.value = location;
    fetchDirectionsPolygon(location);
  }

  void showBarbershopDetails(LatLng location, String name, String distance,
      String front, BarbershopModel barbershop) {
    final BookingController customerBookingController = Get.find();
    final GetBarbershopDataController getBarbershopDataController = Get.find();

    Get.bottomSheet(
      barrierColor: Colors.transparent,
      isDismissible: true,
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, -2)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8.0),
                  Text('Barbershop Details',
                      style: Get.textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: front.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: front, // Dummy image URL
                              fit: BoxFit.cover,
                              scale: 1.0)
                          : Image.asset('assets/images/barbershop.jpg',
                              fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(name, style: Get.textTheme.headlineMedium),
              Text('Distance: $distance km', style: Get.textTheme.bodyMedium),
              Text('Address: ${barbershop.streetAddress}',
                  style: Get.textTheme.bodyMedium),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text('Reviews'),
                  // SizedBox(width: 3),
                  // iconoir.StarSolid(
                  //   height: 15,
                  // ),
                  // SizedBox(width: 3),
                  // Flexible(
                  //   child: Text(
                  //     // Calculate the average rating
                  //     (barbershop.review.isEmpty
                  //             ? 0.0
                  //             : barbershop.review.fold(0.0,
                  //                     (sum, review) => sum + review.rating) /
                  //                 barbershop.review.length)
                  //         .toStringAsFixed(
                  //             1), // Average rating rounded to 1 decimal place
                  //     overflow: TextOverflow.clip,
                  //     maxLines: 1,
                  //   ),
                  // ),
                  SizedBox(width: 3),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        getBarbershopDataController.fetchHaircuts(
                            barberShopId: barbershop.id, descending: true);
                        getBarbershopDataController
                            .fetchTimeSlots(barbershop.id);
                        customerBookingController.chosenBarbershop.value =
                            barbershop;
                        Get.to(() => const ChooseHaircut());
                      },
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

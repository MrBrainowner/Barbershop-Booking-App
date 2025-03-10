// import 'package:barbermate_customers/features/customer/controllers/customer_controller/customer_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import '../../controllers/get_directions_controller/get_directions_controller.dart';
// import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

// class MapWidget extends StatelessWidget {
//   const MapWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final GetDirectionsController controller = Get.find();
//     return Obx(
//       () => Positioned(
//         top: 0,
//         bottom: Get.height * (1 - controller.mapHeightRatio.value) - 40,
//         left: 0,
//         right: 0,
//         child: FlutterMap(
//           mapController: controller.mapController,
//           options: MapOptions(
//             initialCenter: controller.selectedBarbershopLocation.value ??
//                 const LatLng(7.44659415181318, 125.80925506524625),
//             initialZoom: 12.3,
//             cameraConstraint:
//                 CameraConstraint.containCenter(bounds: controller.bounds),
//             minZoom: 12.3,
//             interactionOptions: const InteractionOptions(
//                 flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
//           ),
//           children: [
//             TileLayer(
//                 urlTemplate:
//                     // 'https://api.mapbox.com/styles/v1/geo11000/cm18lrmh9058m01pq5iyyc95j/tiles/256/%7Bz%7D/%7Bx%7D/%7By%7D{r}?access_token=pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY20wczJ0eHVyMGcwMzJqbjVyamMxemFncyJ9.8Sh3_L9HB32tr5ZQadPkig',
//                     'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY20wczJ0eHVyMGcwMzJqbjVyamMxemFncyJ9.8Sh3_L9HB32tr5ZQadPkig',
//                 additionalOptions: const {
//                   'accessToken':
//                       'pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY20wczJ0eHVyMGcwMzJqbjVyamMxemFncyJ9.8Sh3_L9HB32tr5ZQadPkig',
//                   'id': 'mapbox/light-v11'
//                 }),
//             PolylineLayer(
//               polylines: [
//                 if (controller.routeCoordinates.isNotEmpty)
//                   Polyline(
//                     points: controller.routeCoordinates,
//                     strokeWidth: 4.0,
//                     useStrokeWidthInMeter: true,
//                     borderStrokeWidth: 3.0,
//                     borderColor: Theme.of(context).primaryColor,
//                     color: Theme.of(context).primaryColor,
//                   ),
//               ],
//             ),
//             MarkerLayer(
//               markers: _buildMarkers(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Marker> _buildMarkers() {
//     final GetDirectionsController controller = Get.find();
//     final CustomerController customerController = Get.find();

//     final barbershops = controller.barbershopsController.barbershop;

//     return [
//       if (controller.currentLocation.value != null)
//         Marker(
//           point: controller.currentLocation.value!,
//           width: 100.0,
//           height: 80.0,
//           child: Column(
//             children: [
//               Flexible(
//                   child: Text(
//                 customerController.customer.value.firstName,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               )),
//               CircleAvatar(
//                 radius: 20.0,
//                 backgroundImage: NetworkImage(
//                     customerController.customer.value.profileImage),
//               ),
//             ],
//           ),
//         ),
//       ...barbershops.asMap().entries.map((entry) {
//         final index = entry.key;
//         final barbershop = barbershops[index];
//         final location = LatLng(barbershop.latitude, barbershop.longitude);
//         final logoUrl = barbershop.barbershopProfileImage;

//         return Marker(
//           point: location,
//           width: 100.0,
//           height: 80.0,
//           child: Column(
//             children: [
//               Flexible(
//                   child: Text(
//                 barbershop.barbershopName,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               )),
//               GestureDetector(
//                 onTap: () async {
//                   final distance = controller.barbershopDistances[index]
//                           ?.toStringAsFixed(2) ??
//                       'Turn on location...';
//                   controller.selectBarbershop(location);
//                   controller.fetchDirections(location);
//                   controller.showBarbershopDetails(
//                       location,
//                       barbershop.barbershopName,
//                       distance,
//                       barbershop.barbershopBannerImage,
//                       barbershop);
//                 },
//                 child: logoUrl.isEmpty
//                     ? CircleAvatar(
//                         radius: 20.0,
//                         backgroundColor: Colors.grey.shade400,
//                         child: const iconoir.QuestionMark(height: 30),
//                       )
//                     : CircleAvatar(
//                         radius: 20.0, backgroundImage: NetworkImage(logoUrl)),
//               )
//             ],
//           ),
//         );
//       }),
//     ];
//   }
// }

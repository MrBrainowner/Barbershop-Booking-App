// import 'package:barbermate_customers/features/customer/views/widgets/get_directions/barbershop_card.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import '../../controllers/get_directions_controller/get_directions_controller.dart';

// class BarbershopList extends StatelessWidget {
//   const BarbershopList({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final GetDirectionsController controller = Get.find();

//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, -2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Barbershops Near You',
//               style: Theme.of(context).textTheme.headlineSmall),
//           Expanded(
//             child: Obx(() {
//               if (controller.barbershopDistances.isEmpty) {
//                 controller.calculateAllDistances();
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final barbershops = controller.barbershopsController.barbershop;

//               return ListView.builder(
//                 itemCount: barbershops.length,
//                 itemBuilder: (context, index) {
//                   final barbershop = barbershops[index];
//                   final distance = controller.barbershopDistances[index]
//                           ?.toStringAsFixed(2) ??
//                       'Turn on location';

//                   return BarbershopCard(
//                     profile: barbershop.barbershopProfileImage,
//                     name: barbershop.barbershopName,
//                     distance: '$distance km',
//                     onTap: () async {
//                       var locations =
//                           LatLng(barbershop.latitude, barbershop.longitude);
//                       await controller.fetchDirections(locations);
//                       controller.selectBarbershop(locations);
//                       controller.showBarbershopDetails(
//                           locations,
//                           barbershop.barbershopName,
//                           distance,
//                           barbershop.barbershopBannerImage,
//                           barbershop);
//                     },
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

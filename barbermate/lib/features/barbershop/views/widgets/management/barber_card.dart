// import 'package:barbermate/data/models/barber_model/barber_model.dart';
// import 'package:flutter/material.dart';

// class BarberCard extends StatelessWidget {
//   final BarberModel barber;

//   const BarberCard({
//     super.key,
//     required this.barber,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: SizedBox(
//         child: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(3)),
//                   child: Image(
//                       height: 140,
//                       fit: BoxFit.cover,
//                       image: barber.profileImage.isNotEmpty
//                           ? NetworkImage(barber.profileImage)
//                           : const AssetImage('assets/images/prof.jpg')
//                               as ImageProvider),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(barber.fullName),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

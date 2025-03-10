// import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
// import 'package:barbermate/features/auth/controllers/phone_verification_controller/verify_phone_controller.dart';
// import 'package:barbermate/features/customer/views/dashboard/dashboard.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
// import 'package:pinput/pinput.dart';

// class PhoneNumberOTP extends StatelessWidget {
//   const PhoneNumberOTP({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final phoneController = Get.put(VerifyPhoneController());
//     String otp;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//               onPressed: () => AuthenticationRepository.instance.logOut(),
//               icon: const Icon(CupertinoIcons.clear))
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: Column(
//             children: [
//               const iconoir.SmartphoneDevice(
//                 height: 50,
//               ),
//               const SizedBox(height: 20),
//               Text('Enter Verification Code',
//                   style: Theme.of(context).textTheme.headlineMedium),
//               const SizedBox(height: 20),
//               Text(
//                   'A verification code has been sent to your phone. Please enter it below.',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.bodyLarge),
//               const SizedBox(height: 20),
//               Pinput(
//                 onCompleted: (pin) {
//                   otp = pin;
//                   phoneController.verifyOTP(otp);
//                 },
//                 length: 6,
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                       onPressed: () {
//                         Get.offAll(() => const CustomerDashboard());
//                       },
//                       child: const Text('Verify'))),
//               SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                       onPressed: () {
//                         phoneController.resendToken();
//                       },
//                       child: const Text('Resend Code')))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

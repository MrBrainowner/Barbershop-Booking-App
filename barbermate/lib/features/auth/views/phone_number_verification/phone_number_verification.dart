// import 'package:barbermate/features/auth/controllers/phone_verification_controller/verify_phone_controller.dart';
// import 'package:barbermate/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
// import 'package:barbermate/utils/validators/validators.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

// class PhoneNumberVerification extends StatelessWidget {
//   const PhoneNumberVerification({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final validator = Get.put(ValidatorController());
//     final phoneController = Get.put(VerifyPhoneController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Phone Verification'),
//         centerTitle: true,
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
//               Text('Verify Your Phone Number',
//                   style: Theme.of(context).textTheme.headlineMedium),
//               const SizedBox(height: 20),
//               Text(
//                   'Enter your phone number to receive a verification code. This helps us secure your account and enhance your experience. You will automatically be redirected if the code is sent.',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.bodyLarge),
//               const SizedBox(height: 20),
//               MyTextField(
//                 controller: phoneController.number,
//                 validator: (value) => validator.validatePhoneNumber(value),
//                 keyboardtype: TextInputType.number,
//                 labelText: 'Phone',
//                 obscureText: false,
//                 icon: const Icon(Icons.phone),
//               ),
//               const SizedBox(height: 5),
//               SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         await phoneController
//                             .sendOTP(phoneController.number.text);
//                       },
//                       child: const Text('Send Code')))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sign_in/sign_in_page.dart';
import '../sign_up/sign_up_page.dart';
import 'welcome_widgets/elevated_welcome_button.dart';
import 'welcome_widgets/outlined_welcome_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.asset(
                        'assets/images/banner.jpg',
                        fit: BoxFit.cover,
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Welcome to Barbermate\n',
                      style: Theme.of(context).textTheme.headlineLarge,
                      children: [
                        TextSpan(
                            text:
                                'your go-to app for effortless barbershop bookings. Barbermate – your personal barbering assistant.',
                            style: Theme.of(context).textTheme.bodyLarge)
                      ]),
                ),
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ElevatedWelcomeButton(
                          width: 150,
                          text: 'Sign In',
                          onPressed: () {
                            Get.offAll(() => const SignInPage());
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: OutlinedWelcomeButton(
                          width: 150,
                          text: 'Sign Up',
                          onPressed: () {
                            Get.to(() => const SignUpPage());
                          },
                          icon: null,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

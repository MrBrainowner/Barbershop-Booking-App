import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../sign_in/sign_in_page.dart';
import 'welcome_widgets/elevated_welcome_button.dart';

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
                      text: 'Barbermate Admins\n',
                      style: Theme.of(context).textTheme.headlineLarge,
                      children: [
                        TextSpan(
                            text:
                                'This app is made for administrative operation',
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

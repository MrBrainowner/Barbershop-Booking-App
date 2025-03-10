import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/onboarding_controller/onboarding_controller.dart';
import '../../controllers/onboarding_controller/onboarding_next.dart';
import '../../controllers/onboarding_controller/onboarding_page.dart';
import '../../controllers/onboarding_controller/onboarding_skip.dart';
import '../../controllers/onboarding_controller/page_indicator.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Stack(
            children: [
              // ==================================================================================== Pages
              PageView(
                controller: controller.pageContoller,
                onPageChanged: controller.updatePageIndicator,
                children: const [
                  OnboardingPage(
                    title: 'Style',
                    subtitle:
                        'Explore and Perfect Your Unique Style with Expert Guidance from Our Barbers.',
                    image: 'assets/images/onboarding/style.svg',
                  ),
                  OnboardingPage(
                    title: 'Book',
                    subtitle:
                        'Effortlessly Book Your Next Grooming Appointment Anytime, Anywhere with Barbermate.',
                    image: 'assets/images/onboarding/book.svg',
                  ),
                  OnboardingPage(
                    title: 'Shine',
                    subtitle:
                        'Shine Brighter and Exude Confidence After Every Professional Barbermate Session.',
                    image: 'assets/images/onboarding/shine.svg',
                  ),
                ],
              ),
              // ==================================================================================== Skip Button
              const Positioned(
                top: 0,
                right: 0,
                child: OnboardingSkip(text: 'Skip'),
              ),
              // ==================================================================================== Page Indicator
              const Positioned(
                bottom: 0,
                left: 0,
                child: PageIndicatorWidget(),
              ),
              // ==================================================================================== Buttons
              const Positioned(
                bottom: 0,
                right: 0,
                child: NextButtonWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

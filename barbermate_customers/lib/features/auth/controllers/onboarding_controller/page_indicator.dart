import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboarding_controller.dart';

class PageIndicatorWidget extends StatelessWidget {
  const PageIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SmoothPageIndicator(
        controller: controller.pageContoller,
        count: 3,
        onDotClicked: controller.dotNavigationClick,
        effect: ExpandingDotsEffect(
          activeDotColor: Theme.of(context).primaryColor,
          dotHeight: 5,
        ),
      ),
    );
  }
}

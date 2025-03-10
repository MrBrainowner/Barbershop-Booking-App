import 'package:flutter/material.dart';

import 'onboarding_controller.dart';

class OnboardingSkip extends StatelessWidget {
  final String text;

  const OnboardingSkip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => OnboardingController.instance.skipPage(),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

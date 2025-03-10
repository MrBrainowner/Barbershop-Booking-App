import 'package:flutter/material.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

import 'onboarding_controller.dart';

class NextButtonWidget extends StatelessWidget {
  const NextButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => OnboardingController.instance.nextPage(),
      child: iconoir.ArrowRight(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}

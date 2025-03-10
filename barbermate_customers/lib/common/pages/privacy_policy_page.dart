import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for Barbermate',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Effective Date: September 14, 2024',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '1. Introduction',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome to Barbermate. We are committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner. This Privacy Policy explains how we collect, use, and protect your information when you use our app.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '2. Information We Collect',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '- Personal Information: When you register or use our services, we may collect personal details such as your name, email address, phone number, and payment information.\n'
              '- Usage Data: We may collect information about how you use the app, including your booking history, preferences, and interactions with barbers.\n'
              '- Device Information: We may collect information about your device, including its IP address, operating system, and unique identifiers.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '3. How We Use Your Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '- To Provide Services: We use your information to process bookings, manage appointments, and communicate with you regarding your account and services.\n'
              '- To Improve Our App: We analyze usage data to enhance the app\'s functionality, performance, and user experience.\n'
              '- For Marketing: With your consent, we may use your information to send you promotional offers, updates, and newsletters.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '4. Sharing Your Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'We do not sell or rent your personal information to third parties. We may share your information with:\n'
              '- Service Providers: Third-party vendors who assist us in operating the app and providing services.\n'
              '- Legal Requirements: If required by law or to protect our rights, we may disclose your information to comply with legal obligations or respond to legal requests.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '5. Data Security',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'We take reasonable measures to protect your personal information from unauthorized access, disclosure, alteration, and destruction. However, no data transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '6. Your Choices',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '- Access and Update: You can access and update your personal information by logging into your account or contacting us.\n'
              '- Opt-Out: You can opt out of receiving promotional communications by following the instructions in those communications.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '7. Changes to This Policy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'We may update this Privacy Policy from time to time. Any changes will be posted on this page, and the effective date will be updated accordingly. We encourage you to review this policy periodically.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '8. Contact Us',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'If you have any questions or concerns about this Privacy Policy, please contact us via email barbermate@gmail.com.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

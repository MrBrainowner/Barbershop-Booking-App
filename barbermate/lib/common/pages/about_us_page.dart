import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Barbermate!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'At Barbermate, we believe that finding a great barbershop should be simple and convenient. Our mission is to connect you with top-notch barbershops in your area, making it easy for you to book appointments, discover new styles, and enjoy exceptional haircut services.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Our Story',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Founded in 2024, Barbermate was created to address the need for a user-friendly platform where people could effortlessly find and book appointments with barbershops. Our team is passionate about enhancing your haircut experience and ensuring that you receive the best service every time you visit a barbershop.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'What We Offer',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '- Easy Booking: Schedule appointments with your favorite barbers with just a few taps.\n'
              '- Diverse Barbers: Explore profiles of various barbers and choose the one that fits your style.\n'
              '- Customer Reviews: Read reviews and ratings to make informed decisions.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Our Commitment',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'We are dedicated to providing a seamless and secure experience for our users. Your satisfaction is our top priority, and we are continuously working to improve our services and features based on your feedback.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Have questions or need assistance? Feel free to reach out to us at [Your Contact Email] or visit our website at [Your Website URL].',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

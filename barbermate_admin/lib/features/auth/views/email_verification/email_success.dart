import 'package:flutter/material.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

import '../../../../data/repository/auth_repo/auth_repo.dart';

class EmailSuccess extends StatelessWidget {
  const EmailSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const iconoir.CheckCircle(
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your Account is successfully Created!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Congratulations! Your Account Has Been Created.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () => AuthenticationRepository.instance
                                .pageRedirect(),
                            child: const Text('Continue')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

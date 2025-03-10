import 'package:flutter/material.dart';

class OutlinedWelcomeButton extends StatelessWidget {
  final double width;
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const OutlinedWelcomeButton(
      {super.key,
      required this.width,
      required this.text,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(text)],
        ),
      ),
    );
  }
}

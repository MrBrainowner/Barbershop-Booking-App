import 'package:flutter/material.dart';

class ElevatedWelcomeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;

  const ElevatedWelcomeButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
        ));
  }
}

import 'package:flutter/material.dart';

class BarbershopInfos extends StatelessWidget {
  const BarbershopInfos({super.key, required this.text, required this.widget});
  final String text;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget,
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            maxLines: 3,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

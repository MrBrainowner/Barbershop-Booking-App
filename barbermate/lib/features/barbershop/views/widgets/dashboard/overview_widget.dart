import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard(
      {super.key,
      required this.color,
      required this.title,
      required this.sometext,
      required this.titl2,
      required this.sometext2,
      this.onTapCard1,
      this.onTapCard2,
      required this.color2,
      required this.flex1,
      required this.flex2});

  final Color color;
  final Color color2;
  final String title;
  final String sometext;
  final String titl2;
  final String sometext2;
  final Function()? onTapCard1;
  final Function()? onTapCard2;
  final int flex1;
  final int flex2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: flex1,
          child: GestureDetector(
            onTap: onTapCard1,
            child: Card(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5), // Adjust the radius here
              ),
              elevation: 4, // Optional: Adjust shadow depth
              child: Padding(
                padding: const EdgeInsets.all(10), // Adjust padding for spacing
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      title, // Dynamic text
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      child: Text(
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        sometext, // Dynamic text
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: flex2,
          child: GestureDetector(
            onTap: onTapCard2,
            child: Card(
              color: color2,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5), // Adjust the radius here
              ),
              elevation: 4, // Optional: Adjust shadow depth
              child: Padding(
                padding: const EdgeInsets.all(10), // Adjust padding for spacing
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      titl2, // Dynamic text
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      child: Text(
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        sometext2, // Dynamic text
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

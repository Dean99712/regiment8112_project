import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class Bubble extends StatelessWidget {
  const Bubble({super.key, required this.date, required this.text});

  final String date;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(fontSize: 12, color: colorScheme.onBackground, text: date,),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: isDark ? greyShade400 : greyShade100,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: CustomText(fontSize: 16, color: colorScheme.onBackground, text: text,textAlign: TextAlign.start),
            ),
          )
        ],
      ),
    );
  }
}

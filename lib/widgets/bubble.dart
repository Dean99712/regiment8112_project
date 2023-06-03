import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'custom_text.dart';

class Bubble extends StatelessWidget {
  const Bubble({super.key, required this.date, required this.text});

  final String date;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(fontSize: 12,color:  const Color.fromRGBO(190, 190, 190, 1),text: date),
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(121, 121, 121, 1),
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: CustomText(fontSize: 16, color: white ,text: text),
        )
      ],
    );
  }
}

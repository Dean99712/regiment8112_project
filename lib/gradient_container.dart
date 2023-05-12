import 'package:flutter/material.dart';
import 'package:regiment8112_project/custom_text.dart';

const topAlignment = Alignment.topLeft;
const bottomAlignment = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.colors, {super.key});

  final List<Color> colors;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: colors,
        begin: topAlignment,
        end: bottomAlignment,
      )),
      child: const Center(child: CustomText("Hello World!")),
    );
  }
}

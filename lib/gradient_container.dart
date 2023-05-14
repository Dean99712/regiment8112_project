import 'package:flutter/material.dart';
import 'package:regiment8112_project/swipable_tab.dart';
import 'package:regiment8112_project/top_section.dart';

const topAlignment = Alignment.topLeft;
const bottomAlignment = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.colors, {super.key});

  final List<Color> colors;

  @override
  Widget build(context) {
    return Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.9,
          colors: colors,
        )),
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: const [
              TopSection(),
              SwipeableTab()
            ],
          ),
        ));
  }
}

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
          image: const DecorationImage(
              opacity: 0.12,
              image: AssetImage("assets/images/Group 126.png"),
              fit: BoxFit.cover),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.1,
            colors: colors,
          )),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: TopSection(),
          ), Expanded(child: SwipeableTab())],
        ),
      ),
    );
  }
}

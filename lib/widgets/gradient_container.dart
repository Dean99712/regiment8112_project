import 'package:flutter/material.dart';
import 'package:regiment8112_project/widgets/contacts.dart';
import 'package:regiment8112_project/widgets/swipable_tab.dart';
import 'package:regiment8112_project/widgets/top_section.dart';

const topAlignment = Alignment.topLeft;
const bottomAlignment = Alignment.bottomRight;

class GradientContainer extends StatefulWidget {
  const GradientContainer(this.colors, {super.key});

  final List<Color> colors;

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  var activeTab = '';

  @override
  void initState() {
    activeTab = 'news';
    super.initState();
  }

  @override
  Widget build(context) {
    print(activeTab);
    return Container(
      decoration: BoxDecoration(
          image: const DecorationImage(
              opacity: 0.12,
              image: AssetImage("assets/images/Group 126.png"),
              fit: BoxFit.cover),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.1,
            colors: widget.colors,
          )),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: TopSection(activeTab, (value) {
                setState(() {
                  activeTab = value;
                });
              }),
            ),
             Expanded(
                child: activeTab == 'news' ? const SwipeableTab() : const Contacts())
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:regiment8112_project/tabs/tap_bar.dart';

class SwipeableTab extends StatefulWidget {
  const SwipeableTab({Key? key}) : super(key: key);

  @override
  State<SwipeableTab> createState() => _SwipeableTabState();
}

class _SwipeableTabState extends State<SwipeableTab> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Center(
        child: Column(
          children: [
            TabBars(),
          ],
        ),
      ),
    );
  }
}

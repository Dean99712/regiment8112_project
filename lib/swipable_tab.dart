import 'package:flutter/material.dart';
import 'package:regiment8112_project/tabs/tap_bar.dart';

class SwipeableTab extends StatelessWidget {
  const SwipeableTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TabBars()
          ],
        ),
      ),
    );
  }
}

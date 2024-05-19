import 'package:flutter/material.dart';

import '../tabs/images_tab.dart';
import '../tabs/news_tab.dart';
import '../tabs/updates_tab.dart';

class SwipeableTab extends StatefulWidget {
  const SwipeableTab(
      this.scrollController,
      {required this.tabs, required this.tabController, super.key});

  final ScrollController scrollController;
  final TabController tabController;
  final List<Widget> tabs;

  @override
  State<SwipeableTab> createState() => _SwipeableTabState();
}

class _SwipeableTabState extends State<SwipeableTab> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Center(
      widthFactor: double.infinity,
      heightFactor: double.infinity,
      child: Column(
        children: [
          TabBar(
              controller: widget.tabController,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              padding: const EdgeInsets.only(top: 20),
              unselectedLabelColor: theme.primary,
              dividerColor: Colors.transparent,
              indicatorColor: theme.secondary,
              labelColor: theme.secondary,
              tabs: widget.tabs),
          Expanded(
            child: TabBarView(controller: widget.tabController, children: const [
              NewsTab(),
              UpdatesTab(),
              ImagesTab(),
            ]),
          ),
        ],
      ),
    );
  }
}

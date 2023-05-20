import 'package:flutter/material.dart';
import 'package:regiment8112_project/tabs/tab.dart';
import 'package:regiment8112_project/tabs/tab/images_tab.dart';
import 'package:regiment8112_project/tabs/tab/news_tab.dart';
import 'package:regiment8112_project/tabs/tab/updates_tab.dart';

class SwipeableTab extends StatefulWidget {
  const SwipeableTab({Key? key}) : super(key: key);

  @override
  State<SwipeableTab> createState() => _SwipeableTabState();
}

class _SwipeableTabState extends State<SwipeableTab> {
  List<Widget> myTabs = const [
    MyTab(text: "חדשות"),
    MyTab(text: "עדכוני פלוגה"),
    MyTab(text: "תמונות")
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: myTabs.length,
        child: Center(
          widthFactor: double.infinity,
          heightFactor: double.infinity,
          child: Column(
            children: [
              // TabBars(),
              TabBar(
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  padding: const EdgeInsets.only(top: 20),
                  unselectedLabelColor: const Color.fromRGBO(86, 154, 82, 1),
                  indicatorColor: const Color.fromRGBO(251, 174, 27, 1),
                  labelColor: const Color.fromRGBO(251, 174, 27, 1),
                  tabs: myTabs),
              const Expanded(
                  child: TabBarView(children: [
                NewsTab(),
                UpdatesTab(),
                ImagesTab()
                // News Page
                // Updates Page
                // Images Page
              ])),
            ],
          ),
        ));
  }
}

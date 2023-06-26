import 'package:flutter/material.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/add_contact.dart';
import 'package:regiment8112_project/widgets/contacts.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';
import 'package:regiment8112_project/widgets/swipable_tab.dart';
import 'package:regiment8112_project/widgets/top_section.dart';

const topAlignment = Alignment.topLeft;
const bottomAlignment = Alignment.bottomRight;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var activeTab = '';
  final ScrollController scrollController = ScrollController();
  bool isFab = false;

  @override
  void initState() {
    activeTab = 'news';
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: activeTab != 'news'
            ? ScrollingFabAnimated(
                width: 175,
                icon: activeTab == 'news'
                    ? null
                    : const Icon(Icons.person_add, color: white, size: 30),
                text: CustomText(
                    fontSize: 16,
                    color: white,
                    text: activeTab != 'news' ? 'הוסף איש קשר' : null),
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddContact(),
                    ),
                  );
                },
                scrollController: scrollController,
                animateIcon: false,
                color: primaryColor,
                duration: const Duration(milliseconds: 150),
                elevation: 0.0,
                radius: 40.0,
          inverted: true,
              )
            : null,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: 0.12,
                  image: AssetImage("assets/images/Group 126.png"),
                  fit: BoxFit.cover),
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.1,
                colors: [Color.fromRGBO(60, 58, 59, 1), Color.fromRGBO(60, 58, 59, 1)],
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
                  child: activeTab == 'news'
                      ? SwipeableTab(scrollController)
                      : Contacts(scrollController),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

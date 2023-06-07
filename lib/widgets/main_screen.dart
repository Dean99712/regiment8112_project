import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/contacts.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';
import 'package:regiment8112_project/widgets/swipable_tab.dart';
import 'package:regiment8112_project/widgets/top_section.dart';

const topAlignment = Alignment.topLeft;
const bottomAlignment = Alignment.bottomRight;

class MainScreen extends StatefulWidget {
  const MainScreen(this.colors, {super.key});

  final List<Color> colors;

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
    scrollController.addListener(() {
      if (scrollController.offset < 50) {
        setState(() {
          isFab = true;
        });
      } else {
        setState(() {
          isFab = false;
        });
      }
    });
    super.initState();
  }

  Widget renderFab() {
    return FloatingActionButton(
      elevation: 0.0,
        backgroundColor: primaryColor,
        child: activeTab == "news"
            ? const Icon(Icons.add_a_photo)
            : const Icon(Icons.person, size: 35),
        onPressed: () {});
  }

  Widget renderExtendedFab() {
    return FloatingActionButton.extended(
      backgroundColor: primaryColor,
      elevation: 0.0,
      isExtended: true,
      icon: activeTab == "news"
          ? const Icon(Icons.add_a_photo)
          : const Icon(Icons.person, size: 35),
      onPressed: () {},
      label: activeTab == "news"
          ? const CustomText(
              fontSize: 16,
              color: white,
              text: "הוסף תמונות",
            )
          : const CustomText(
              fontSize: 16,
              color: white,
              text: "הוסף איש קשר",
            ),
    );
  }

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: isFab ? renderFab() : renderExtendedFab(),
        body: Container(
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
                    child: activeTab == 'news'
                        ? SwipeableTab(scrollController)
                        : Contacts(scrollController))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/next_summon.dart';
import 'package:regiment8112_project/widgets/search_bar.dart';
import 'custom_text.dart';

class TopSection extends StatefulWidget {
  TopSection(this.currentTab, this.updateActiveTab, {super.key});
  final String currentTab;

  Function(String value) updateActiveTab;

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {

  var activeTab = 'news';

  @override
  void initState() {
    super.initState();
  }

  void function(BuildContext context, String route, Widget widget) {
    Navigator.push(context,
        MaterialPageRoute(maintainState: true, builder: (context) => widget));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 95,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    activeTab = 'news';
                  });
                  widget.updateActiveTab(activeTab);
                },
                child: CustomText(
                    fontSize: 16,
                    color: activeTab == 'news' ? secondaryColor : primaryColor,
                    text: "עדכונים וחדשות"),
              ),
            ),
            Image.asset(
              'assets/svg/logo.png',
              width: 97,
              height: 97,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  activeTab = 'contactsList';
                });
                widget.updateActiveTab('contactsList');
              },
              child: CustomText(
                  fontSize: 16,
                  color: activeTab == 'contactsList'
                      ? secondaryColor
                      : primaryColor,
                  text: "רשימת קשר"),
            ),
          ],
        ),
        activeTab == 'news' ? const NextSummon() : const CustomSearchBar()
      ],
    );
  }
}

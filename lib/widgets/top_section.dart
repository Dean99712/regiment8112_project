import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regiment8112_project/providers/search_provider.dart';
import 'package:regiment8112_project/widgets/next_summon.dart';
import 'package:regiment8112_project/widgets/search_bar.dart';
import 'custom_text.dart';

class TopSection extends ConsumerStatefulWidget {
  const TopSection(this.currentTab, this.updateActiveTab, {super.key});

  final String currentTab;
  final Function(String value) updateActiveTab;

  @override
  ConsumerState<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends ConsumerState<TopSection> {
  var activeTab = 'news';
  final FocusNode focus = FocusNode();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var searchProv = ref.read(searchProvider.notifier);
    Color isContactList = activeTab == 'contactsList'
        ? colorScheme.secondary
        : colorScheme.primary;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 95,
              child: PlatformTextButton(
                material: (_, __) => MaterialTextButtonData(
                  onPressed: () {
                    setState(() {
                      searchProv.state = '';
                      activeTab = 'news';
                    });
                    widget.updateActiveTab(activeTab);
                  },
                  child: CustomText(
                    fontWeight: activeTab == 'news'
                        ? FontWeight.w600
                        : FontWeight.w400,
                      fontSize: 16,
                      color: activeTab == 'news'
                          ? colorScheme.secondary
                          : colorScheme.primary,
                      text: "עדכונים וחדשות"),
                ),
                cupertino: (_, __) => CupertinoTextButtonData(onPressed: () {
                  setState(() {
                    searchProv.state = '';
                    activeTab = 'news';
                  });
                  widget.updateActiveTab(activeTab);
                }),
                child: CustomText(
                    fontWeight: activeTab == 'news'
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 16,
                    color: activeTab == 'news'
                        ? colorScheme.secondary
                        : colorScheme.primary,
                    text: "עדכונים וחדשות"),
              ),
            ),
            Hero(
              tag: "logo image",
              child: Image.asset(
                'assets/svg/logo.png',
                width: 97,
                height: 97,
              ),
            ),
            PlatformTextButton(
              material: (_, __) => MaterialTextButtonData(
                onPressed: () {
                  setState(() {
                    activeTab = 'contactsList';
                  });
                  widget.updateActiveTab('contactsList');
                },
                child: CustomText(
                    fontWeight: activeTab != 'news'
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 16, color: isContactList, text: "רשימת קשר"),
                // )
              ),
              cupertino: (_, __) => CupertinoTextButtonData(
                onPressed: () {
                  setState(() {
                    activeTab = 'contactsList';
                  });
                  widget.updateActiveTab('contactsList');
                },
                child: CustomText(
                    fontWeight: activeTab != 'news'
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 16, color: isContactList, text: "רשימת קשר"),
              ),
            )
          ],
        ),
        activeTab == 'news'
            ? const NextSummon()
            : CustomSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  searchProv.updateQuery(value);
                },
              )
      ],
    );
  }
}

 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../providers/user_provider.dart';
import '../providers/validatorProvider.dart';
import '../services/firebase_storage_service.dart';
import '../services/news_service.dart';
import '../tabs/tab.dart';
import '../utils/colors.dart';
import '../utils/validators.dart';
import '../widgets/contacts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/swipable_tab.dart';
import '../widgets/top_section.dart';

const topAlignment = Alignment.topLeft;
const bottomAlignment = Alignment.bottomRight;

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> myTabs = const [
    MyTab(text: "חדשות"),
    MyTab(text: "עדכוני פלוגה"),
    MyTab(text: "תמונות")
  ];

  final NewsService _newsService = NewsService();
  late final TextEditingController _controller;
  final StorageService _storage = StorageService();
  var activeTab = '';
  final ScrollController scrollController = ScrollController();
  late final TabController _tabController;
  bool isFab = false;

  @override
  void initState() {
    ref.read(userProvider.notifier).authorizedAccess();
    _controller = TextEditingController();
    activeTab = 'news';
    _tabController = TabController(length: myTabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void openDialog(BuildContext context, String text, String example,
      void Function() function, GlobalKey<FormState> formState) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    final body = Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: isIos ? 0 : 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _controller.clear();
                    },
                    icon: Icon(isIos ? CupertinoIcons.xmark : Icons.close))
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 45.0, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: text,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: formState,
                            child: CustomTextField(
                                validator: (value) {
                                  return ref
                                      .read(validatorProvider.notifier)
                                      .validator(
                                          value!,
                                          "תיבה אינה יכולה להיות ריקה!",
                                          "טקסט אינו יכול להכיל ספרות באנגלית או מספרים",
                                          nameValidator);
                                },
                                maxLength: null,
                                controller: _controller,
                                text: example,
                                autoFocus: true),
                          ),
                          CustomButton(
                              width: 165, text: "הוסף", function: function)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
    isIos
        ? CupertinoScaffold.showCupertinoModalBottomSheet(
            expand: true,
            duration: const Duration(milliseconds: 350),
            context: context,
            builder: (context) => body)
        : showMaterialModalBottomSheet(
            enableDrag: true,
            barrierColor: Colors.black.withOpacity(0.7),
            context: context,
            builder: (context) => Container(
              child: body,
            ),
          );
  }

  @override
  Widget build(context) {

    bool isAdmin = ref.watch(userProvider);
    final formState = GlobalKey<FormState>();
    final tab = _tabController.index == 0
        ? 'news'
        : _tabController.index == 1
            ? "updates"
            : "images";
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: activeTab == 'news'
          ? isAdmin
              ? ScrollingFabAnimated(
                  curve: Curves.easeInOut,
                  width: 180,
                  icon: tab == 'news'
                      ? const Icon(Icons.newspaper_sharp, color: white, size: 30)
                      : tab == 'updates'
                          ? const Icon(Icons.add_alert, color: white, size: 30)
                          : const Icon(Icons.add_photo_alternate,
                              color: white, size: 30),
                  text: CustomText(
                    fontSize: 16,
                    color: white,
                    text: tab == 'news'
                        ? "הוסף חדשות"
                        : tab == 'updates'
                            ? "הוסף עדכונים"
                            : "הוסף אלבום",
                  ),
                  onPress: () {
                    switch (_tabController.index) {
                      case 0:
                        {
                          openDialog(context, "הוסף ידיעה חדשה",
                              'לדוגמא:"מצאנו את הטלפון של יחיאל"', () async {
                            if (formState.currentState!.validate()) {
                              Navigator.of(context).pop();
                              await _newsService.addNews(_controller.text);
                            }
                            _controller.clear();
                          }, formState);
                        }
                        break;
                      case 1:
                        {
                          openDialog(context, "הוסף עדכון חדש",
                              'לדוגמא:"יש אימון בחודש הבא"', () async {
                            if (formState.currentState!.validate()) {
                              Navigator.of(context).pop();
                              await _newsService.addUpdate(_controller.text);
                            }
                            _controller.clear();
                          }, formState);
                        }
                        break;
                      case 2:
                        {
                          openDialog(
                              context, "צור אלבום חדש", 'לדוגמא:"קו אביטל 23"',
                              () async {
                            if (formState.currentState!.validate()) {
                              Navigator.of(context).pop();
                              await _storage.createAlbum(context, _controller.text);
                            }
                            _controller.clear();
                          }, formState);
                        }
                    }
                  },
                  scrollController: scrollController,
                  animateIcon: false,
                  color: primaryColor,
                  duration: const Duration(milliseconds: 150),
                  elevation: 0.0,
                  radius: 40.0,
                  inverted: true,
                )
              : null
          : null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              opacity: isDark ? 0.12 : 0.30,
              image: const AssetImage("assets/images/Group 126.png"),
              fit: BoxFit.cover),
          color: colorScheme.background,
        ),
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
                    ? SwipeableTab(
                        scrollController,
                        tabController: _tabController,
                        tabs: myTabs,
                      )
                    : Contacts(scrollController),
              )
            ],
          ),
        ),
      ),
    );
  }
}
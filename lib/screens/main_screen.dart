import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:regiment8112_project/providers/user_provider.dart';
import 'package:regiment8112_project/providers/validatorProvider.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/services/news_service.dart';
import 'package:regiment8112_project/utils/validators.dart';
import 'package:regiment8112_project/widgets/contacts.dart';
import 'package:regiment8112_project/widgets/custom_button.dart';
import 'package:regiment8112_project/widgets/custom_text_field.dart';
import 'package:regiment8112_project/widgets/swipable_tab.dart';
import 'package:regiment8112_project/widgets/top_section.dart';
import '../tabs/tab.dart';
import '../utils/colors.dart';
import '../widgets/custom_text.dart';

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

  void openDialog(BuildContext context, String text, void Function() function,
      GlobalKey<FormState> formState) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    final body = Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
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
          Container(
            height: MediaQuery.of(context).size.height - 82,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 45.0, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: text,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                 SizedBox(
                   height: 450,
                   child: Column(
                     children: [
                       Form(
                         key: formState,
                         child: CustomTextField(
                             validator: (value) {
                               return ref.read(validatorProvider.notifier).validator(
                                   value!,
                                   "תיבה אינה יכולה להיות ריקה!",
                                   "טקסט אינו יכול להכיל ספרות באנגלית או מספרים",
                                   nameValidator);
                             },
                             maxLength: null,
                             controller: _controller,
                             text: "",
                             autoFocus: true),
                       ),
                       CustomButton(width: 165, text: "הוסף", function: function)
                     ],
                   ),
                 )
                ],
              ),
            ),
          )
        ],
      ),
    );
    isIos ?
    CupertinoScaffold.showCupertinoModalBottomSheet(
      expand: true,
      duration: Duration(milliseconds: 350),
      context: context,
      builder: (context) => body)
    : showMaterialModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.7),
      expand: false,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: body,
      ),
    );;
  }

  @override
  Widget build(context) {
    bool isAdmin = ref.watch(userProvider);
    final _formState = GlobalKey<FormState>();
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
                      ? Icon(Icons.newspaper_sharp, color: white, size: 30)
                      : tab == 'updates'
                          ? Icon(Icons.add_alert, color: white, size: 30)
                          : Icon(Icons.add_photo_alternate,
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
                          openDialog(context, "הוסף חדשות", () async {
                            if (_formState.currentState!.validate()) {
                              Navigator.of(context).pop();
                              await _newsService.addNews(_controller.text);
                            }
                            _controller.clear();
                          }, _formState);
                        }
                      case 1:
                        {
                          openDialog(context, "הוסף עדכון חדש", () async {
                            if (_formState.currentState!.validate()) {
                              Navigator.of(context).pop();
                              await _newsService.addUpdate(_controller.text);
                            }
                            _controller.clear();
                          }, _formState);
                        }
                      case 2:
                        {
                          openDialog(context, "צור אלבום חדש", () async {
                            if (_formState.currentState!.validate()) {
                              Navigator.of(context).pop();
                              await _storage.createAlbum(_controller.text);
                            }
                            _controller.clear();
                          }, _formState);
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
              opacity: isDark ? 0.12 : 1,
              image: AssetImage("assets/images/Group 126.png"),
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

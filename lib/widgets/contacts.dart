import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/user.dart';
import '../providers/filter_provider.dart';
import '../providers/search_provider.dart';
import '../services/user_service.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class Contacts extends ConsumerStatefulWidget {
  const Contacts(this.scrollController, {super.key});

  final ScrollController scrollController;

  @override
  ConsumerState<Contacts> createState() => _ContactsState();
}

class _ContactsState extends ConsumerState<Contacts> {
  final UserService _userService = UserService();

  late List<MyUser> users;

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  void getAllUsers() async {
    var collection = await _userService.getContacts();

    setState(() {
      users = collection;
    });
  }

  Future call(String phoneNumber, bool platform) async {
    const text = "מצטערים, המכשיר שברשותך אינו נתמך";
    final colorScheme = Theme.of(context).colorScheme;
    final phone = phoneNumber.substring(1);
    String url =
        platform == TargetPlatform.iOS ? 'tel://+972$phone' : 'tel:+972$phone';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      await showPlatformDialog(
        context: context,
        cupertino: CupertinoDialogData(
          builder: (context) => CupertinoAlertDialog(
              title: const Text(text),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("ביטול"),
                )
              ]),
        ),
        builder: (context) => AlertDialog(
          title: CustomText(
              fontSize: 16,
              color: colorScheme.onSurface,
              text: text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var query = ref.watch(searchProvider);
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    var isGrouped = ref.watch(isGroupedProvider);
    var size = MediaQuery.of(context).size;
    final userList = ref.watch(searchProvider.notifier).updateQuery(query);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/svg/boot.png'), opacity: 0.3),
        // opacity: isDark ? 0.5 : 0.75),
      ),
      child: FutureBuilder(
        future: userList,
        builder: (context, snapshot) {
          List<MyUser> users = snapshot.data ?? [];
          final usersJson = jsonEncode(users);
          final userList = jsonDecode(usersJson);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: PlatformCircularProgressIndicator(
                material: (_, __) => MaterialProgressIndicatorData(
                    color: secondaryColor, strokeWidth: 2),
                cupertino: (_, __) => CupertinoProgressIndicatorData(
                    color: primaryColor, radius: 15.0),
              ),
            );
          }
          return users.isEmpty
              ? Center(
                  child: CustomText(
                    text: "הרשימה ריקה",
                    color: colorScheme.onSurface,
                  ),
                )
              : isGrouped
                  ? Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.builder(
                          controller: widget.scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final oddColor = (index % 2 == 0)
                                ? greyShade600
                                : Colors.transparent;

                            return Container(
                              color: isDark
                                  ? oddColor
                                  : (index % 2 == 0)
                                      ? greyShade200
                                      : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 25),
                                child: SizedBox(
                                  height: size.height * 0.05,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width / 4,
                                        child: CustomText(
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: isDark
                                                ? greyShade100
                                                : colorScheme.onSurface,
                                            text: users[index].name),
                                      ),
                                      SizedBox(
                                        width: size.width / 4,
                                        child: CustomText(
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: isDark
                                                ? greyShade100
                                                : colorScheme.onSurface,
                                            text: users[index].lastName),
                                      ),
                                      SizedBox(
                                        width: size.width / 5,
                                        child: CustomText(
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: isDark
                                                ? greyShade100
                                                : colorScheme.onSurface,
                                            text: users[index].city),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (isIos) {
                                            call(users[index].phoneNumber,
                                                isIos);
                                          } else {
                                            call(users[index].phoneNumber,
                                                isIos);
                                          }
                                        },
                                        child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                                color: primaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: const Icon(
                                                size: 20,
                                                Icons.phone,
                                                color: white)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : GroupedListView<dynamic, String>(
                      useStickyGroupSeparators: true,
                      controller: widget.scrollController,
                      physics: const BouncingScrollPhysics(),
                      elements: userList,
                      groupBy: (element) => element['platoon'],
                      itemComparator: (item1, item2) =>
                          item1['name'].compareTo(item2['name']),
                      order: GroupedListOrder.ASC,
                      groupSeparatorBuilder: (value) => Container(
                          width: double.infinity,
                          color: isDark ? greyShade600 : greyShade200,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  color: colorScheme.onSurface,
                                  fontSize: 16,
                                  text: value,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          )),
                      itemBuilder: (context, element) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            textDirection: TextDirection.rtl,
                            children: [
                              SizedBox(
                                width: size.width / 4,
                                child: CustomText(
                                    textAlign: TextAlign.start,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? greyShade100
                                        : colorScheme.onSurface,
                                    text: element['name']),
                              ),
                              SizedBox(
                                width: size.width / 4,
                                child: CustomText(
                                    textAlign: TextAlign.start,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? greyShade100
                                        : colorScheme.onSurface,
                                    text: element['lastName']),
                              ),
                              SizedBox(
                                width: size.width / 5,
                                child: CustomText(
                                    textAlign: TextAlign.start,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? greyShade100
                                        : colorScheme.onSurface,
                                    text: element['city']),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (isIos) {
                                    call(element['phoneNumber'], isIos);
                                  } else {
                                    call(element['phoneNumber'], isIos);
                                  }
                                },
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: const Icon(
                                        size: 20, Icons.phone, color: white)),
                              )
                            ],
                          ),
                        );
                      });
        },
      ),
    );
  }
}

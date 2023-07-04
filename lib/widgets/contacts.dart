import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:regiment8112_project/models/user.dart';
import 'package:regiment8112_project/providers/filter_provider.dart';
import 'package:regiment8112_project/providers/search_provider.dart';
import 'package:regiment8112_project/services/user_service.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends ConsumerStatefulWidget {
  const Contacts(this.scrollController, {super.key});

  final ScrollController scrollController;

  @override
  ConsumerState<Contacts> createState() => _ContactsState();
}

class _ContactsState extends ConsumerState<Contacts> {
  final UserService _user = UserService();

  late Stream<List<MyUser>> users;

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  void getAllUsers() {
    var collection = _user.getContacts();

    setState(() {
      users = collection;
    });
  }

  Future call(String phoneNumber) async {
    final phone = phoneNumber.substring(1);
    final Uri url = Uri(scheme: 'tel', path: '+972$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: CustomText(
              fontSize: 16,
              color: white,
              text: "מצטערים, המכשיר שברשותך אינו נתמך"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var query = ref.watch(searchProvider);
    final userList = ref.watch(searchProvider.notifier).updateQuery(query);

    var isGrouped = ref.watch(isGroupedProvider);

    var size = MediaQuery.of(context).size;
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/svg/boot.png'), opacity: 0.4),
      ),
      child: StreamBuilder(
        stream: userList,
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
          return snapshot.data!.isEmpty
              ? const Center(
                child: CustomText(
                  text: "הרשימה ריקה",
                  color: white,
                ),
              )
              : isGrouped
                  ? Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: (index % 2 == 0)
                                  ? const Color.fromRGBO(74, 72, 73, 1)
                                  : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width / 8,
                                      child: CustomText(
                                          fontSize: 16,
                                          color: const Color.fromRGBO(
                                              215, 215, 215, 1.0),
                                          text: users[index].name),
                                    ),
                                    SizedBox(
                                      width: size.width / 4,
                                      child: CustomText(
                                          fontSize: 16,
                                          color: const Color.fromRGBO(
                                              215, 215, 215, 1.0),
                                          text: users[index].lastName),
                                    ),
                                    SizedBox(
                                      width: size.width / 4,
                                      child: CustomText(
                                          fontSize: 16,
                                          color: const Color.fromRGBO(
                                              215, 215, 215, 1.0),
                                          text: users[index].city),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (isIos) {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) =>
                                                caller(users[index].lastName),
                                          );
                                        } else {
                                          call(users[index].phoneNumber);
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
                          color: const Color.fromRGBO(74, 72, 73, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  color: white,
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
                                    fontSize: 16,
                                    color: const Color.fromRGBO(
                                        215, 215, 215, 1.0),
                                    text: element['name']),
                              ),
                              SizedBox(
                                width: size.width / 4,
                                child: CustomText(
                                    fontSize: 16,
                                    color: const Color.fromRGBO(
                                        215, 215, 215, 1.0),
                                    text: element['lastName']),
                              ),
                              SizedBox(
                                width: size.width / 5,
                                child: CustomText(
                                    fontSize: 16,
                                    color: const Color.fromRGBO(
                                        215, 215, 215, 1.0),
                                    text: element['city']),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (isIos) {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          caller(element['phoneNumber']),
                                    );
                                  } else {
                                    call(element['phoneNumber']);
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

  Widget caller(String phone) {
    return CupertinoActionSheet(
        cancelButton: CupertinoButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("ביטול"),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              call(phone);
            },
            child: Text('התקשר $phone'),
          )
        ]);
  }
}

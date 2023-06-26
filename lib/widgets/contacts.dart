import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:regiment8112_project/models/user.dart';
import 'package:regiment8112_project/services/user_service.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

class Contacts extends StatefulWidget {
  const Contacts(this.scrollController, {super.key});

  final ScrollController scrollController;

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final UserService _user = UserService();

  String groupByType = '';

  late Stream<List<MyUser>> users;

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  Stream<List<MyUser>> getAllUsers() {
    var collection = _user.getContacts().snapshots();
    var documents = collection.map((snapshot) =>
        snapshot.docs.map((doc) => MyUser.fromSnapshot(doc)).toList());

    setState(() {
      users = documents;
    });

    return documents;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/svg/boot.png'),
          opacity: 0.4
        ),
      ),
      child: StreamBuilder(
        stream: getAllUsers(),
        builder: (context, snapshot) {
          List<MyUser> users = snapshot.data!;
          final usersJson = jsonEncode(users);
          final userList = jsonDecode(usersJson);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GroupedListView<dynamic, String>(
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
                        width: size.width / 8,
                        child: CustomText(
                            fontSize: 16,
                            color: const Color.fromRGBO(215, 215, 215, 1.0),
                            text: element['name']),
                      ),
                      SizedBox(
                        width: size.width / 4,
                        child: CustomText(
                            fontSize: 16,
                            color: const Color.fromRGBO(215, 215, 215, 1.0),
                            text: element['lastName']),
                      ),
                      SizedBox(
                        width: size.width / 4,
                        child: CustomText(
                            fontSize: 16,
                            color: const Color.fromRGBO(215, 215, 215, 1.0),
                            text: element['city']),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var phoneNumber =
                              '+972${element['phoneNumber'].toString().substring(1)}';
                          // print(phoneNumber);
                          await FlutterPhoneDirectCaller.callNumber(
                              phoneNumber);
                        },
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
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

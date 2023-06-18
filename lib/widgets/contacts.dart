import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

import '../data/contacts.dart';

class Contacts extends StatelessWidget {
  const Contacts(this.scrollController, {super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {

    final contactsJson = jsonEncode(contacts);
    final contactsList = jsonDecode(contactsJson);

    var size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/svg/boot.png'),
        ),
      ),
      child: GroupedListView<dynamic, String>(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          elements: contactsList,
          groupBy: (element) => element['cls'],
          itemComparator: (item1, item2) =>
              item1['name'].compareTo(item2['name']),
          // stickyHeaderBackgroundColor: const Color.fromRGBO(74, 72, 73, 1),
          // useStickyGroupSeparators: true,
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
                      text: 'מחלקה  $value',
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              )),
          itemBuilder: (context, element) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
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
                      onTap: () async{
                        var phoneNumber = '+972${element['phoneNumber'].toString().substring(1)}';
                        // print(phoneNumber);
                        await FlutterPhoneDirectCaller.callNumber(phoneNumber);
                      },
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child:
                              const Icon(size: 20, Icons.phone, color: white)),
                    )
                  ],
                ),
              )),
    );
  }
}

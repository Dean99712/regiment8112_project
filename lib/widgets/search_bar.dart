import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/providers/search_provider.dart';
import 'package:regiment8112_project/utils/colors.dart';

import '../providers/filter_provider.dart';

class CustomSearchBar extends ConsumerWidget {
  const CustomSearchBar({required this.controller, this.onChanged, super.key});

  final SearchController controller;
  final void Function(String)? onChanged;

  Widget renderSearchBar(BuildContext context, WidgetRef ref) {
    var search = ref.watch(searchProvider);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: CupertinoSearchTextField(
            autofocus: true,
            onChanged: onChanged,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            backgroundColor: white.withOpacity(0.3),
            placeholder: ".חפש...",
          ),
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SearchBar(
          trailing: <Widget>[
            search.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.clear();
                      ref.read(searchProvider.notifier).state = '';
                    })
                : const SizedBox()
          ],
          onChanged: onChanged,
          backgroundColor: MaterialStateProperty.all(white.withOpacity(0.4)),
          leading: Icon(
            Icons.search,
            color: Colors.transparent.withOpacity(0.4),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.3,
          ),
          elevation: MaterialStateProperty.all(0),
          textStyle: MaterialStateProperty.all(GoogleFonts.heebo()),
          hintText: 'חפש...',
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isGrouped = ref.watch(isGroupedProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          renderSearchBar(context, ref),
          IconButton(
            color: primaryColor,
            enableFeedback: true,
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {
              ref.read(isGroupedProvider.notifier).state = !isGrouped;
            },
          )
        ],
      ),
    );
  }
}

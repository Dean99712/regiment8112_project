import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/utils/colors.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {

  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget renderSearchBar(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: CupertinoSearchTextField(
            controller: _searchController,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            backgroundColor: white,
            placeholder: "חפש...",
          ),
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SearchBar(
          backgroundColor: MaterialStateProperty.all(white.withOpacity(0.4)),
          leading: Icon(Icons.search, color: Colors.transparent.withOpacity(0.4),),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          renderSearchBar(context),
          IconButton(
            color: primaryColor,
            enableFeedback: true,
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/utils/colors.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          SearchBar(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.3,
            ),
            elevation: MaterialStateProperty.all(0),
            textStyle: MaterialStateProperty.all(GoogleFonts.heebo()),
            hintText: 'חפש...',
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
          ),
          IconButton(
            color: primaryColor,
            enableFeedback: true,
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

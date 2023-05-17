import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBars extends StatelessWidget {
  const TabBars({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      padding: const EdgeInsets.only(top: 20),
      unselectedLabelColor: const Color.fromRGBO(86, 154, 82, 1),
      indicatorColor: const Color.fromRGBO(251, 174, 27, 1),
      labelColor: const Color.fromRGBO(251, 174, 27, 1),
      tabs: [
        Tab(
          child: Text(
            "תמונות",
            style: GoogleFonts.heebo(),
          ),
        ),
        Tab(
            child: Text(
          "עדכוני פלוגה",
          style: GoogleFonts.heebo(textStyle: const TextStyle(wordSpacing: 2)),
        )),
        Tab(
          child: Text(
            "חדשות",
            style: GoogleFonts.heebo(),
          ),
        ),
      ],
    );
  }
}

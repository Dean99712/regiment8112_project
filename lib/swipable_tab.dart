import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SwipeableTab extends StatelessWidget {
  const SwipeableTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: [
            TabBar(
              labelStyle:  const TextStyle(
                fontWeight: FontWeight.bold
              ),
              padding: const EdgeInsets.only(top: 20),
              unselectedLabelColor: const Color.fromRGBO(86, 154, 82, 1),
              indicatorColor: const Color.fromRGBO(251, 174, 27, 1),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor:  const Color.fromRGBO(251, 174, 27, 1),
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
                  style: GoogleFonts.heebo(),
                )),
                Tab(
                  child: Text(
                    "עדכונים",
                    style: GoogleFonts.heebo(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

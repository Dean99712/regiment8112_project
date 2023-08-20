import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class NextSummon extends StatelessWidget {
  const NextSummon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 85,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  opacity: 0.20,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(0, 0, 0, 0.10), BlendMode.multiply),
                  image: AssetImage("assets/images/Group 126.png"),
                  fit: BoxFit.cover),
              color: isDark ? brownShade300 : secondaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "הזימון הבא",
                    style: GoogleFonts.heebo(color: colorScheme.onBackground, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "18.09 - 25.09",
                    style: GoogleFonts.rubikDirt(
                        color: colorScheme.onBackground, fontSize: 24),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -17,
          left: -10,
          child: SvgPicture.asset(
            'assets/svg/Artwork 3.svg',
            width: 60,
            height: 65,
          ),
        )
      ],
    );
  }
}

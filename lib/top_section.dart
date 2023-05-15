import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/custom_text.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key});

  void onPress() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: onPress,
              child: const CustomText("עדכונים וחדשות"),
            ),
            Image.asset(
              'assets/svg/logo.png',
              width: 97,
              height: 97,
            ),
            TextButton(onPressed: () {}, child: const CustomText("רשימת קשר")),
          ],
        ),
        Container(
          height: 85,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  opacity: 0.1,
                  image: AssetImage("assets/svg/Group 126.png"),
                  fit: BoxFit.cover
              ),
              color: const Color.fromRGBO(167, 93, 53, 1),
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
              SvgPicture.asset(
                'assets/svg/Artwork 3.svg',
                width: 60,
                height: 65,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "הזימון הבא",
                    style: GoogleFonts.heebo(color: Colors.white),
                  ),
                  Text(
                    "18.09 - 25.09",
                    style: GoogleFonts.rubikDirt(
                        color: Colors.white, fontSize: 24),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_text.dart';

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
            SizedBox(
              width: 95,
              child: TextButton(

                onPressed: onPress,
                child: const CustomText(
                  16,
                  Color.fromRGBO(251, 174, 27, 1),
                  "עדכונים וחדשות",
                ),
              ),
            ),
            Image.asset(
              'assets/svg/logo.png',
              width: 97,
              height: 97,
            ),
            TextButton(
              onPressed: () {},
              child: const CustomText(
                  16, Color.fromRGBO(86, 154, 82, 1), "רשימת קשר"),
            ),
          ],
        ),
        Stack(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(
                          "הזימון הבא",
                          style: GoogleFonts.heebo(color: Colors.white),
                        ),
                      Text(
                        "18.09 - 25.09",
                        style: GoogleFonts.rubikDirt(
                            color: Colors.white, fontSize: 24),
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
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/utils/colors.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {required this.text,
      required this.fontSize,
      this.color = primaryColor,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.center,
      super.key});

  final Color color;
  final String? text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text!,
      textDirection: TextDirection.rtl,
      style: GoogleFonts.heebo(
          color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {required this.fontSize,
      required this.color,
      this.text,
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

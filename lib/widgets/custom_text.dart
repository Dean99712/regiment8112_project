import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText(this.fontSize, this.color,this.text,{super.key });

  final Color color;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      style: GoogleFonts.heebo(color: color, fontSize: fontSize),
    );
  }
}

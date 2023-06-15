import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {required this.controller, required this.text, super.key});

  final TextEditingController controller;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        enableSuggestions: false,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        autofocus: true,
        decoration: InputDecoration(
          filled: true,
          label: Text(
            text,
            textDirection: TextDirection.ltr,
            style: GoogleFonts.heebo(color: primaryColor),
          ),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

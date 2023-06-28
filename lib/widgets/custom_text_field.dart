import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {required this.controller,
      required this.text,
      this.type = TextInputType.text,
      this.maxLength = 10,
      this.width = double.infinity,
      this.onChanged,
      super.key});

  final TextEditingController? controller;
  final String text;
  final TextInputType type;
  final int? maxLength;
  final double width;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: PlatformTextField(
            keyboardType: type,
            onChanged: onChanged,
            controller: controller,
            maxLength: maxLength,
            cupertino: (_, __) => CupertinoTextFieldData(
                  cursorColor: primaryColor,
                  decoration: BoxDecoration(
                      color: white.withOpacity(0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  textDirection: TextDirection.rtl,
                  placeholder: text,
                  placeholderStyle: GoogleFonts.heebo(color: primaryColor),
                ),
            material: (_, __) => MaterialTextFieldData(
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: text,
                      filled: true,
                      fillColor: white.withOpacity(0.3)),
                )),
      ),
    );
  }
}

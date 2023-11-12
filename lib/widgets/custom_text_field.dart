import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {required this.controller,
        required this.text,
        this.type = TextInputType.text,
        this.maxLength = 10,
        this.readOnly = false,
        this.width = double.infinity,
        this.textAlign,
        this.onChanged,
        this.prefix,
        this.textInputAction,
        this.autoFocus,
        this.validator,
        super.key});

  final TextEditingController? controller;
  final String text;
  final TextInputType type;
  final int? maxLength;
  final double width;
  final bool readOnly;
  final Widget? prefix;
  final bool? autoFocus;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: width,
      height: isIos ? null : size.width * 0.2,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: PlatformTextFormField(
          autofocus: autoFocus,
          validator: validator,
            keyboardType: type,
            onChanged: onChanged,
            controller: controller,
            maxLength: maxLength,
            readOnly: readOnly,
            cupertino: (_, __) => CupertinoTextFormFieldData(
              textInputAction: textInputAction,
              textAlign: textAlign,
              prefix: prefix,
              cursorColor: primaryColor,
              decoration: BoxDecoration(
                  color: isDark ? white.withOpacity(0.5) : greyShade100,
                  borderRadius:
                  const BorderRadius.all(Radius.circular(10))),
              textDirection: TextDirection.rtl,
              placeholder: text,
              placeholderStyle: GoogleFonts.heebo(color: primaryColor),
            ),
            material: (_, __) => MaterialTextFormFieldData(
              expands: false,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: colorScheme.error, width: 1.0),
                  ),
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
                  fillColor: isDark ? white.withOpacity(0.3) : greyShade10),
            )),
      ),
    );
  }
}

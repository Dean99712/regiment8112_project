import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.text, required this.function, super.key});

  final String text;
  final void Function() function;

  @override
  Widget build(BuildContext context) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return isIos
        ? CupertinoButton(
            color: primaryColor,
            onPressed: function,
            child: CustomText(
              fontSize: 16,
              color: white,
              text: text,
            ))
        : MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: primaryColor,
            onPressed: function,
            child: CustomText(fontSize: 16, color: white, text: text),
          );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/utils/ebutton_state.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {required this.text,
      required this.function,
      this.color = primaryColor,
      this.width = double.infinity,
      this.state,
      super.key});

  final String? text;
  final void Function() function;
  final Color color;
  final double width;
  final ButtonState? state;

  @override
  Widget build(BuildContext context) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final size = MediaQuery.of(context).size;
    return isIos
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: SizedBox(
              width: width,
              child: CupertinoButton(
                color: color,
                onPressed: function,
                child: CustomText(
                  fontSize: 16,
                  color: white,
                  text: text,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: SizedBox(
              width: width,
              height: size.height / 17,
              child: MaterialButton(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: color,
                onPressed: function,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: state == ButtonState.loading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: PlatformCircularProgressIndicator(
                            cupertino: (_, __) =>
                                CupertinoProgressIndicatorData(
                                    radius: 15, color: white, animating: true),
                            material: (_, __) => MaterialProgressIndicatorData(
                                color: white, strokeWidth: 2),
                          ),
                        )
                      : CustomText(fontSize: 16, color: white, text: text),
                ),
              ),
            ),
          );
  }
}

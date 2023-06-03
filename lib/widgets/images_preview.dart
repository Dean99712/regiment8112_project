import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

class ImagesPreview extends StatelessWidget {
  const ImagesPreview(this.text, {super.key});

  final String text;

  void function() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              CustomText(
                fontSize: 16,
                color: white,
                text: text,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
              ),
              const CustomText(
                fontSize: 16,
                color: white,
                text: "אפריל 2023",
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          width: 350,
          child: GridView.custom(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverQuiltedGridDelegate(
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                crossAxisCount: 3,
                pattern: const [
                  QuiltedGridTile(2, 2),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 1),
                ]),
            childrenDelegate: SliverChildBuilderDelegate((context, index) {
              return Image.asset(
                  "assets/images/IMG_0830.HEIC",
                  fit: BoxFit.fill,
              );
            }),
          ),
        ),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 25.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               const Icon(
                 FontAwesomeIcons.anglesLeft,
                 color: primaryColor,
               ),
               TextButton(
                 onPressed: function,
                 child: const CustomText(
                   fontSize: 16,
                   color: primaryColor,
                   text: "לכל התמונות",
                   fontWeight: FontWeight.w400,
                 ),
               ),
             ],
           ),
         )
      ],
    );
  }
}

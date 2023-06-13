import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intel;
import '../utils/colors.dart';
import 'custom_text.dart';

class ImagesPreview extends StatelessWidget {
  const ImagesPreview(this.switchScreen, this.text, {super.key});

  final void Function() switchScreen;

  final String text;

  // final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    var formatDate = initializeDateFormatting('he', '').then((_) {
      var date = DateTime.now();
      return intel.DateFormat('yMMMM', 'he').format(date);
    });

    return FutureBuilder<String>(
      future: formatDate,
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Expanded(
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
                      CustomText(
                        fontSize: 16,
                        color: white,
                        text: snapshot.data,
                        // text: "אפריל 2023",
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                width: 370,
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
                  childrenDelegate:
                      SliverChildBuilderDelegate((context, index) {
                    return Image.asset(
                      "assets/images/IMG_0830.HEIC",
                      fit: BoxFit.fitHeight,
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      FontAwesomeIcons.angleLeft,
                      color: primaryColor,
                    ),
                    TextButton(
                      onPressed: switchScreen,
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
          ),
        );
      },
    );
  }
}

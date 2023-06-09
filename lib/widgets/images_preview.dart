import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intel;
import '../services/firebase_storage_service.dart';
import '../tabs/tab/all_images_tab.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class ImagesPreview extends StatefulWidget {
  const ImagesPreview(this.text, {super.key});

  final String text;

  @override
  State<ImagesPreview> createState() => _ImagesPreviewState();
}

class _ImagesPreviewState extends State<ImagesPreview> {
  final StorageService _storageService = StorageService();
  // List<String> _dataList = [];

  void function(BuildContext context, Widget route) {
    Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => route,
        ));
  }

  // Future<void> fetchImagesData() async {
  //   List<String> dataList =
  //       await _storageService.getAllPhotos();
  //   setState(() {
  //     _dataList = dataList;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // fetchImagesData();
  }

  @override
  Widget build(BuildContext context) {
    // print('dataList : $_dataList');

    var date = DateTime.now();
    var formatDate = intel.DateFormat('yMMMM').format(date);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              CustomText(
                fontSize: 16,
                color: white,
                text: widget.text,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
              ),
              CustomText(
                fontSize: 16,
                color: white,
                text: formatDate,
                // text: "אפריל 2023",
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
              ),
            ],
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
            childrenDelegate: SliverChildBuilderDelegate((context, index) {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                FontAwesomeIcons.anglesLeft,
                color: primaryColor,
              ),
              TextButton(
                onPressed: () {
                  function(context, const ImagesTab());
                },
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

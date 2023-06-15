import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intel;
import 'package:regiment8112_project/widgets/all_images.dart';
import '../services/firebase_storage_service.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class ImagesPreview extends StatefulWidget {
  const ImagesPreview(this.function, this.text, {super.key});

  final String text;
  final Function function;

  @override
  State<ImagesPreview> createState() => _ImagesPreviewState();
}

// late CollectionReference<Map<String, dynamic>> _data;
late Query<Map<String, dynamic>> _photos;
StorageService _storageService = StorageService();

class _ImagesPreviewState extends State<ImagesPreview> {
  @override
  void initState() {
    _photos = _storageService.getAlbumByName(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var photos = _photos;
    var formatDate = initializeDateFormatting('he', '').then((_) {
      var date = DateTime.now();
      return intel.DateFormat('yMMMM', 'he').format(date);
    });

    return FutureBuilder<String>(
      future: formatDate,
      builder: (context, localData) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    fontSize: 16,
                    color: white,
                    text: localData.data,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    fontSize: 16,
                    color: white,
                    text: widget.text,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
              FirestoreQueryBuilder<Map<String, dynamic>>(
                query: photos,
                builder: (context, snapshot, child) {
                  print(snapshot.docs.length);
                  var docs = snapshot.docs;
                  if (snapshot.hasData) {
                    return Expanded(
                      child: GridView.builder(
                        itemCount: 3,
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
                        itemBuilder: (BuildContext context, int index) {
                          String photo = docs[index]["imageUrl"];

                          return CachedNetworkImage(
                            imageUrl: photo,
                            maxHeightDiskCache: 275,
                            fadeInDuration: const Duration(milliseconds: 150),
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PlatformCircularProgressIndicator(
                        material: (_, __) => MaterialProgressIndicatorData(
                          color: secondaryColor,
                        ),
                        cupertino: (_, __) => CupertinoProgressIndicatorData(
                          animating: true,
                        ),
                      )
                    ],
                  ));
                },
              ),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllImages(),
                        ));
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new,
                        color: primaryColor,
                        size: 16,
                      ),
                      CustomText(
                        fontSize: 16,
                        color: primaryColor,
                        text: "לכל התמונות",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

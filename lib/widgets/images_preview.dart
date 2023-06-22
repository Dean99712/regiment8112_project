import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' as intel;
import 'package:regiment8112_project/models/album.dart';
import 'package:regiment8112_project/widgets/all_images.dart';
import 'package:regiment8112_project/widgets/all_images2.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../services/firebase_storage_service.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class ImagesPreview extends StatefulWidget {
  const ImagesPreview({required this.text, required this.date, super.key});

  final String text;
  final Timestamp date;

  @override
  State<ImagesPreview> createState() => _ImagesPreviewState();
}

StorageService _storageService = StorageService();

List<Album> imagesList = [];

class _ImagesPreviewState extends State<ImagesPreview> {
  @override
  void initState() {
    getPhotosFromAlbum(widget.text);
    super.initState();
  }

  Future<Query<Map<String, dynamic>>> getPhotosFromAlbum(
      String childName) async {
    final limit = _storageService.getPhotos(childName).limit(3);

    final photos = await _storageService.getPhotos(childName).limit(3).get();

    final albums = photos.docs.map((doc) => Album.fromSnapshot(doc)).toList();

    setState(() {
      imagesList = albums;
    });
    return limit;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Query<Map<String, dynamic>>>(
      future: getPhotosFromAlbum(widget.text),
      builder: (context, snapshot) {
        var data = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              FirestoreQueryBuilder<Map<String, dynamic>>(
                query: data,
                pageSize: 3,
                builder: (context, snapshot, child) {
                  var docs = snapshot.docs;

                  if (snapshot.hasData) {
                    final date = DateTime.fromMillisecondsSinceEpoch(
                        widget.date.millisecondsSinceEpoch);
                    var formattedDate = intel.DateFormat('yMMMM').format(date);
                    return Wrap(
                      textDirection: TextDirection.rtl,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Wrap(
                            textDirection: TextDirection.rtl,
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: widget.text,
                                fontSize: 16,
                                color: white,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomText(
                                text: formattedDate,
                                fontSize: 16,
                                color: white,
                              ),
                              SizedBox(
                                height: 250,
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String photo = docs[index]["imageUrl"];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageGallery(
                                                      images: imagesList,
                                                      index: index,
                                                    )));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: photo,
                                        maxHeightDiskCache: 275,
                                        fadeInDuration:
                                            const Duration(milliseconds: 150),
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.isFetching) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 75.0),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 75.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PlatformCircularProgressIndicator(
                            material: (_, __) => MaterialProgressIndicatorData(
                              color: secondaryColor,
                            ),
                            cupertino: (_, __) =>
                                CupertinoProgressIndicatorData(
                              animating: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllImages(title: widget.text),
                        ));
                  },
                  child: const Row(
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

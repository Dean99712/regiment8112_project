import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' as intl;
import 'package:regiment8112_project/models/album.dart';
import 'package:regiment8112_project/screens/images_screen.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class ImagesPreview extends StatefulWidget {
  const ImagesPreview({required this.text, required this.date, super.key});

  final String text;
  final Timestamp date;

  @override
  State<ImagesPreview> createState() => _ImagesPreviewState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

late Stream<List<Album>> _imagesList;

class _ImagesPreviewState extends State<ImagesPreview> {
  int itemCount = 3;

  @override
  void initState() {
    getPhotosFromAlbum(widget.text);
    super.initState();
  }

  void getPhotosFromAlbum(String childName) {
    var collection = _firestore
        .collectionGroup("album")
        .where("title", isEqualTo: childName)
        .orderBy("createdAt", descending: true)
        .limit(3)
        .snapshots();

    var albums = collection.map((snapshot) =>
        snapshot.docs.map((doc) => Album.fromSnapshot(doc)).toList());

    setState(() {
      _imagesList = albums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Album>>(
        stream: _imagesList,
        builder: (context, snapshot) {
          var date = DateTime.fromMillisecondsSinceEpoch(
              widget.date.millisecondsSinceEpoch);
          var formattedDate = intl.DateFormat('yMMM').format(date);
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0)
                  .add(const EdgeInsets.only(bottom: 30.0)),
              child: Column(
                children: [
                  Wrap(
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
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: SizedBox(
                                height: 250,
                                child: GridView.builder(
                                  // itemCount: snapshot.data!.length == 3 ? 3 : 1,
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
                                    List<Album> imagesList = snapshot.data!;
                                    String photo = imagesList[index].imageUrl;
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
                                        maxHeightDiskCache: 500,
                                        fadeInDuration:
                                            const Duration(milliseconds: 150),
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImagesScreen(title: widget.text),
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
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 75.0),
              child: Center(
                child: PlatformCircularProgressIndicator(
                  material: (_, __) => MaterialProgressIndicatorData(
                    color: secondaryColor,
                  ),
                  cupertino: (_, __) => CupertinoProgressIndicatorData(
                      radius: 15.0, color: primaryColor),
                ),
              ),
            );
          }
          return Container();
        });
  }
}

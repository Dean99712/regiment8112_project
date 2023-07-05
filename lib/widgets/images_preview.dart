import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' as intl;
import 'package:regiment8112_project/models/album.dart';
import 'package:regiment8112_project/screens/images_screen.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class ImagesPreview extends ConsumerStatefulWidget {
  const ImagesPreview({required this.text, required this.date, super.key});

  final String text;
  final Timestamp date;

  @override
  ConsumerState<ImagesPreview> createState() => _ImagesPreviewState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

late Stream<List<Album>> _imagesList;

class _ImagesPreviewState extends ConsumerState<ImagesPreview> {
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
            List<Album> imagesList =
            snapshot.data!;
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
                              child: Container(
                                color: snapshot.data!.isEmpty
                                    ? Colors.black.withOpacity(0.2)
                                    : null,
                                height: snapshot.data!.length == 2 ? 175 : 220,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: snapshot.data!.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const CustomText(
                                                  text: "האלבום ריק,",
                                                  fontSize: 20,
                                                  color: white),
                                              CustomText(
                                                text:
                                                    " היכנס על מנת להוסיף תמונות",
                                                fontSize: 12,
                                                color: white.withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                        )
                                      : GridView.builder(
                                          itemCount: snapshot.data!.isEmpty
                                              ? 0
                                              : snapshot.data!.length == 2
                                                  ? 2
                                                  : 3,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverQuiltedGridDelegate(
                                                  mainAxisSpacing: 5,
                                                  crossAxisSpacing: 5,
                                                  crossAxisCount: snapshot.data!
                                                                  .length ==
                                                              1 &&
                                                          snapshot.data!.isEmpty
                                                      ? 1
                                                      : snapshot.data!.length ==
                                                              2
                                                          ? 2
                                                          : 3,
                                                  pattern: snapshot
                                                              .data!.length ==
                                                          1
                                                      ? const [
                                                          QuiltedGridTile(3, 3),
                                                        ]
                                                      : snapshot.data!.length ==
                                                              2
                                                          ? const [
                                                              QuiltedGridTile(
                                                                  1, 1),
                                                              QuiltedGridTile(
                                                                  1, 1),
                                                              // QuiltedGridTile(1, 1),
                                                            ]
                                                          : const [
                                                              QuiltedGridTile(
                                                                  2, 2),
                                                              QuiltedGridTile(
                                                                  1, 1),
                                                              QuiltedGridTile(
                                                                  1, 1),
                                                            ]),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String photo =
                                                imagesList[index].imageUrl;
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageGallery(
                                                              images:
                                                                  imagesList,
                                                              index: index,
                                                            )));
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl: photo,
                                                maxHeightDiskCache:
                                                    imagesList.length == 1
                                                        ? 1200
                                                        : 500,
                                                fadeInDuration: const Duration(
                                                    milliseconds: 150),
                                                fit: BoxFit.fill,
                                              ),
                                            );
                                          },
                                        ),
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

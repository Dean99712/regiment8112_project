import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' as intl;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:regiment8112_project/models/album.dart';
import 'package:regiment8112_project/screens/images_screen.dart';
import '../utils/colors.dart';
import 'custom_text.dart';
import 'image_slider_preview.dart';

class ImagesPreview extends ConsumerStatefulWidget {
  const ImagesPreview({required this.text, required this.date, super.key});

  final String text;
  final Timestamp date;

  @override
  ConsumerState<ImagesPreview> createState() => _ImagesPreviewState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

late Query _imagesList;

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
        .orderBy("createdAt", descending: true);
    
    setState(() {
      _imagesList = collection;
    });
  }

  @override
  Widget build(BuildContext context) {

    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FirestoreQueryBuilder(
        query: _imagesList,
        builder: (context, snapshot, child) {
          var date = DateTime.fromMillisecondsSinceEpoch(
              widget.date.millisecondsSinceEpoch);
          var formattedDate = intl.DateFormat('yMMM').format(date);
          if (snapshot.hasData) {
            List<Album> imagesList = snapshot.docs.map((e) => Album.fromQuerySnapshot(e)).toList();
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
                              color: colorScheme.onBackground,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text: formattedDate,
                              fontSize: 16,
                              color: colorScheme.onBackground,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                color: snapshot.docs.isEmpty
                                    ? isDark ? Colors.black.withOpacity(0.2) : greyShade400
                                    : null,
                                height: snapshot.docs.length == 2 ? size.height * 0.2 : size.height / 3.75,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: snapshot.docs.isEmpty
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
                                                    "היכנס על מנת להוסיף תמונות",
                                                fontSize: 12,
                                                color: white.withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                        )
                                      : GridView.builder(
                                          itemCount: snapshot.docs.isEmpty
                                              ? 0
                                              : snapshot.docs.length == 2
                                                  ? 2
                                                  : 3,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverQuiltedGridDelegate(
                                                  mainAxisSpacing: 5,
                                                  crossAxisSpacing: 5,
                                                  crossAxisCount: snapshot.docs
                                                                  .length ==
                                                              1 &&
                                                          snapshot.docs.isEmpty
                                                      ? 1
                                                      : snapshot.docs.length ==
                                                              2
                                                          ? 2
                                                          : 3,
                                                  pattern: snapshot
                                                              .docs.length ==
                                                          1
                                                      ? const [
                                                          QuiltedGridTile(3, 3),
                                                        ]
                                                      : snapshot.docs.length ==
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
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageSliderPreview(
                                                              images:
                                                                  imagesList,
                                                              index: index,
                                                            )));
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl: imagesList[index].imageUrl,
                                                maxHeightDiskCache:
                                                    imagesList.length == 1
                                                        ? 1200
                                                        : 500,
                                                fadeInDuration: const Duration(
                                                    milliseconds: 150),
                                                fit: BoxFit.fill,
                                                progressIndicatorBuilder: (context, url, progress) {
                                                  return BlurHash(
                                                    hash: imagesList[index].hash,
                                                    image: imagesList[index].imageUrl,
                                                  );
                                                },
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
                            isIos ? CupertinoPageRoute(builder: (context) => CupertinoScaffold(body: ImagesScreen(title: widget.text))) : MaterialPageRoute(
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
          if (snapshot.isFetching) {
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
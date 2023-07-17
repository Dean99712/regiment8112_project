import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../models/album.dart';

class AllImages extends ConsumerStatefulWidget {
  const AllImages(this.itemCount,
      {required this.title,
        required this.scrollOffset,
        required this.scrollController,
        super.key});

  final int? itemCount;
  final String title;
  final double? scrollOffset;
  final ScrollController scrollController;

  @override
  ConsumerState<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends ConsumerState<AllImages>
    with TickerProviderStateMixin {
  List<XFile> selectedImagesList = [];
  late Query _photosQuery;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    photosSnapshot(widget.title);
    super.initState();
  }

  Query<Map<String, dynamic>> photosSnapshot(String childName) {
    var photosQuery = _storageService.getPhotosByAlbum(childName);
    setState(() {
      _photosQuery = photosQuery;
    });
    return photosQuery;
  }

  Widget buildImage(Album image) {
    return Hero(
      transitionOnUserGestures: true,
      tag: image.imageUrl,
      child: HeroMode(
        enabled: false,
        child: CachedNetworkImage(
          maxHeightDiskCache: widget.itemCount == 1
              ? 1200
              : widget.itemCount == 3
              ? 350
              : 255,
          fit: BoxFit.cover,
          imageUrl: image.imageUrl,
          fadeInDuration: const Duration(milliseconds: 150),
          progressIndicatorBuilder: (context, url, progress) {
            return Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.progress,
                  color: primaryColor),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme
        .of(context)
        .platform == TargetPlatform.iOS;

    return FirestoreQueryBuilder(
      query: _photosQuery,
      pageSize: 27,
      builder: (context, snapshot, child) {
        if (snapshot.hasData) {
          var photos =
          snapshot.docs.map((e) => Album.fromQuerySnapshot(e)).toList();
          return GridView.builder(
            controller: isIOS ? null : widget.scrollController,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: widget.itemCount!),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              if (snapshot.hasMore && index + 1 != snapshot.docs.length) {
                snapshot.fetchMore();
              }
              var color = Theme
                  .of(context)
                  .colorScheme;
              return isIOS
                  ? CupertinoContextMenu(
                  actions: [
                    CupertinoContextMenuAction(
                        isDefaultAction: true,
                        trailingIcon: const IconData(0xf4ca,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage),
                        child: Text(
                          "שתף",
                          style: TextStyle(color: color.onBackground),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container());
                        }),
                    CupertinoContextMenuAction(
                      isDestructiveAction: true,
                      trailingIcon: const IconData(0xf4c4,
                          fontPackage: CupertinoIcons.iconFontPackage,
                          fontFamily: CupertinoIcons.iconFont),
                      child: const Text(
                        "מחק תמונה זו",
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) =>
                              CupertinoActionSheet(
                                message: const Text(
                                    "פעולה זו תמחוק את התמונה לצמיתות",
                                    style: TextStyle(fontSize: 10)),
                                cancelButton: CupertinoButton(
                                    child: const Text("ביטול"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                actions: [
                                  CupertinoActionSheetAction(
                                    isDestructiveAction: true,
                                    child: const Text("מחק תמונה זו"),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                        );
                      },
                    )
                  ],
                  child: Material(
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ImageGallery(
                                        images: photos, index: index),
                              ));
                        },
                        child: buildImage(photos[index])),
                  ))
                  : Material(
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                            Duration(milliseconds: 300),
                            reverseTransitionDuration:
                            Duration(milliseconds: 450),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {

                              final curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  reverseCurve: Interval(0, 1),
                                  curve: Interval(0, 1));

                              return FadeTransition(
                                opacity: curvedAnimation,
                                child: ImageGallery(
                                    images: photos,
                                    index: index,
                                    title: widget.title,
                                    scrollController:
                                    widget.scrollController),
                              );
                            },
                          ));
                    },
                    child: buildImage(photos[index])),
              );
            },
          );
        }
        if (snapshot.isFetching) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../models/album.dart';
import '../utils/colors.dart';

class AllImages extends ConsumerStatefulWidget {
  const AllImages(this.itemCount,
      {required this.title,
      required this.scrollOffset,
      required this.scrollController,
      super.key});

  final int? itemCount;
  final String title;
  final double? scrollOffset;
  final ScrollController? scrollController;

  @override
  ConsumerState<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends ConsumerState<AllImages>
    with TickerProviderStateMixin {
  DocumentSnapshot? lastDocument;
  int limit = 50;
  List<XFile> selectedImagesList = [];
  late Stream<List<Album>>? _photosStream;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    photosSnapshot(widget.title, limit);
  }

  Stream<List<Album>> photosSnapshot(String childName, int limit) {
    Stream<QuerySnapshot<Map<String, dynamic>>> photos;

    if (lastDocument == null) {
      photos = _storageService.getPhotosByAlbum(childName, limit).snapshots();
    } else
      photos = _storageService
          .getPhotosByAlbum(childName, limit)
          .startAfterDocument(lastDocument!)
          .snapshots();

    final albums = photos.map((snapshot) =>
        snapshot.docs.map((doc) => Album.fromSnapshot(doc)).toList());

    setState(() {
      _photosStream = albums;
    });
    return albums;
  }

  @override
  void dispose() {
    widget.scrollController!.dispose();
    super.dispose();
  }

  Widget buildImage(Album image) {
    return Hero(
      tag: image.imageUrl,
      child: CachedNetworkImage(
        maxHeightDiskCache: widget.itemCount == 1
            ? 1200
            : widget.itemCount == 3
                ? 750
                : 350,
        fit: BoxFit.cover,
        imageUrl: image.imageUrl,
        fadeInDuration: const Duration(milliseconds: 150),
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: primaryColor,
              backgroundColor: white.withOpacity(0.3),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return StreamBuilder(
      stream: _photosStream,
      builder: (context, snapshot) {
        List<Album> photos = snapshot.data ?? [];
        return GridView.builder(
          key: ValueKey<int>(widget.itemCount!),
          controller: isIOS ? null : widget.scrollController,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              crossAxisCount: widget.itemCount!),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            var color = Theme.of(context).colorScheme;
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
                              builder: (context) => CupertinoActionSheet(
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
                                  builder: (context) => ImageGallery(
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
                            MaterialPageRoute(
                              builder: (context) => ImageGallery(
                                  images: photos,
                                  index: index,
                                  title: widget.title,
                                  scrollController: widget.scrollController
                              ),
                            ),
                          );
                        },
                        child: buildImage(photos[index])),
                  );
          },
        );
      },
    );
  }
}

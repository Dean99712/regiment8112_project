import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../models/album.dart';
import '../utils/colors.dart';

class AllImages extends StatefulWidget {
  const AllImages(
      this.itemCount,
      {required this.title,
      required this.scrollOffset,
      required this.scrollController,
      super.key});

  final int itemCount;
  final String title;
  final double scrollOffset;
  final ScrollController scrollController;

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  List<XFile> selectedImagesList = [];
  late Stream<List<Album>> _photosStream;
  List<String> documentsList = [];

  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    widget.itemCount;
    photosSnapshot(widget.title);
  }

  Stream<List<Album>> photosSnapshot(String childName) {
    var photos = _storageService
        .getPhotos(childName)
        .orderBy("createdAt", descending: true)
        .limit(55)
        .snapshots();

    final albums = photos.map((snapshot) =>
        snapshot.docs.map((doc) => Album.fromSnapshot(doc)).toList());

    setState(() {
      _photosStream = albums;
      // documentsList = documents;
    });
    return albums;
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return StreamBuilder(
      stream: _photosStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var photos = snapshot.data!;
          return GridView.builder(
            controller: isIOS ? null : widget.scrollController,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: widget.itemCount),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return isIOS ? CupertinoContextMenu(
                actions: <Widget>[
                  CupertinoContextMenuAction(
                    isDestructiveAction: true,
                    trailingIcon: const IconData(0xf37f,
                        fontFamily: CupertinoIcons.iconFont,
                        fontPackage: CupertinoIcons.iconFontPackage),
                    child: const Text("Delete photo"),
                    onPressed: () {
                      // _firestore.collection("תיקייה").doc(documentsList[index]).delete();
                    },
                  ),
                ],
                child: Material(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageGallery(images: photos, index: index),
                        ),
                      );
                    },
                    child: Hero(
                      tag: photos[index].imageUrl,
                      child: CachedNetworkImage(
                        maxHeightDiskCache: widget.itemCount == 1 ? 1200 : 600,
                        fit: BoxFit.fill,
                        imageUrl: photos[index].imageUrl,
                        fadeInDuration: const Duration(milliseconds: 150),
                      ),
                    ),
                  ),
                ),
              ) : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageGallery(images: photos, index: index),
                    ),
                  );
                },
                child: Hero(
                  tag: photos[index].imageUrl,
                  child: CachedNetworkImage(
                    maxHeightDiskCache: widget.itemCount == 1 ? 1200 : 600,
                    fit: BoxFit.fill,
                    imageUrl: photos[index].imageUrl,
                    fadeInDuration: const Duration(milliseconds: 150),
                  ),
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: CustomText(
                fontSize: 16,
                color: Colors.black,
                text: "הראתה שגיאה, אנא נסו שוב מאוחר יותר"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: PlatformCircularProgressIndicator(
              material: (_, __) => MaterialProgressIndicatorData(
                color: secondaryColor,
              ),
              cupertino: (_, __) =>
                  CupertinoProgressIndicatorData(
                    radius: 15.0,
                      color: primaryColor,
                      animating: true),
            ),
          );
        }
        return const Center(
          child: Text("אין מידע להציג"),
        );
      },
    );
  }
}

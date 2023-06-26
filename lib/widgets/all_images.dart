import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  const AllImages(this.itemCount,
      {required this.title,
        required this.scrollOffset,
        required this.scrollController,
        required this.photos,
        super.key});

  final List<Album> photos;
  final int itemCount;
  final String title;
  final double scrollOffset;
  final ScrollController scrollController;

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<XFile> selectedImagesList = [];

  // late Stream<List<Album>> _photosStream;
  List<String> documentsList = [];

  final StorageService _storageService = StorageService();

  int limit = 55;

  @override
  void initState() {
    super.initState();
    // getDocuments();
    // photosSnapshot(widget.title, limit);
  }

  // Future getDocuments() async {
  //   _firestore
  //       .collectionGroup("album")
  //       .get()
  //       .then((snapshot) => snapshot.docs.forEach((element) {
  //             documentsList.add(element.reference.id);
  //           }));
  // }

  // Stream<List<Album>> photosSnapshot(String childName, int limit) {
  //   var photos = _storageService.getPhotosByAlbum(childName, limit).snapshots();
  //
  //   final albums = photos.map((snapshot) =>
  //       snapshot.docs.map((doc) => Album.fromSnapshot(doc)).toList());
  //
  //   setState(() {
  //     _photosStream = albums;
  //   });
  //   return albums;
  // }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme
        .of(context)
        .platform == TargetPlatform.iOS;

    return GridView.builder(
      controller: isIOS ? null : widget.scrollController,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          crossAxisCount: widget.itemCount),
      itemCount: widget.photos.length,
      itemBuilder: (context, index) {
        return isIOS
            ? CupertinoContextMenu(
          actions: <Widget>[
            CupertinoContextMenuAction(
              isDestructiveAction: true,
              trailingIcon: const IconData(0xf37f,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage),
              child: const Text("Delete photo"),
              onPressed: () {
                _firestore.collection('albums').where(
                    "albumName", isEqualTo: widget.title).get().then((
                    snapshot) =>
                    snapshot.docs.map((e) =>
                        e.reference.collection("album").doc(documentsList[index]).delete()));
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
                        ImageGallery(images: widget.photos, index: index),
                  ),
                );
              },
              child: Hero(
                tag: widget.photos[index].imageUrl,
                child: CachedNetworkImage(
                  maxHeightDiskCache:
                  widget.itemCount == 1 ? 1200 : 600,
                  fit: BoxFit.fill,
                  imageUrl: widget.photos[index].imageUrl,
                  fadeInDuration: const Duration(milliseconds: 150),
                ),
              ),
            ),
          ),
        )
            : GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ImageGallery(images: widget.photos, index: index),
              ),
            );
          },
          child: Hero(
            tag: widget.photos[index].imageUrl,
            child: CachedNetworkImage(
              maxHeightDiskCache:
              widget.itemCount == 1 ? 1200 : 600,
              fit: BoxFit.fill,
              imageUrl: widget.photos[index].imageUrl,
              fadeInDuration: const Duration(milliseconds: 150),
            ),
          ),
        );
      },
    );
    // return StreamBuilder(
    //   stream: _photosStream,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       List<Album> photos = snapshot.data!;
    //       return GridView.builder(
    //         controller: isIOS ? null : widget.scrollController,
    //         physics: const BouncingScrollPhysics(),
    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisSpacing: 2,
    //             mainAxisSpacing: 2,
    //             crossAxisCount: widget.itemCount),
    //         itemCount: photos.length,
    //         itemBuilder: (context, index) {
    //           return isIOS
    //               ? CupertinoContextMenu(
    //                   actions: <Widget>[
    //                     CupertinoContextMenuAction(
    //                       isDestructiveAction: true,
    //                       trailingIcon: const IconData(0xf37f,
    //                           fontFamily: CupertinoIcons.iconFont,
    //                           fontPackage: CupertinoIcons.iconFontPackage),
    //                       child: const Text("Delete photo"),
    //                       onPressed: () {
    //                         // _firestore.collection("תיקייה").doc(documentsList[index]).delete();
    //                       },
    //                     ),
    //                   ],
    //                   child: Material(
    //                     child: GestureDetector(
    //                       onTap: () {
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) =>
    //                                 ImageGallery(images: photos, index: index),
    //                           ),
    //                         );
    //                       },
    //                       child: Hero(
    //                         tag: photos[index].imageUrl,
    //                         child: CachedNetworkImage(
    //                           maxHeightDiskCache:
    //                               widget.itemCount == 1 ? 1200 : 600,
    //                           fit: BoxFit.fill,
    //                           imageUrl: photos[index].imageUrl,
    //                           fadeInDuration: const Duration(milliseconds: 150),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 )
    //               : GestureDetector(
    //                   onTap: () {
    //                     Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                         builder: (context) =>
    //                             ImageGallery(images: photos, index: index),
    //                       ),
    //                     );
    //                   },
    //                   child: Hero(
    //                     tag: photos[index].imageUrl,
    //                     child: CachedNetworkImage(
    //                       maxHeightDiskCache:
    //                           widget.itemCount == 1 ? 1200 : 600,
    //                       fit: BoxFit.fill,
    //                       imageUrl: photos[index].imageUrl,
    //                       fadeInDuration: const Duration(milliseconds: 150),
    //                     ),
    //                   ),
    //                 );
    //         },
    //       );
    //     }
    //     if (snapshot.hasError) {
    //       return const Center(
    //         child: CustomText(
    //             fontSize: 16,
    //             color: Colors.black,
    //             text: "הראתה שגיאה, אנא נסו שוב מאוחר יותר"),
    //       );
    //     }
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: PlatformCircularProgressIndicator(
    //           material: (_, __) => MaterialProgressIndicatorData(
    //             color: secondaryColor,
    //           ),
    //           cupertino: (_, __) => CupertinoProgressIndicatorData(
    //               radius: 15.0, color: primaryColor, animating: true),
    //         ),
    //       );
    //     }
    //     return const Center(
    //       child: Text("אין מידע להציג"),
    //     );
    //   },
    // );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../models/album.dart';
import '../utils/colors.dart';

class AllImages extends StatefulWidget {
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
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<XFile> selectedImagesList = [];
  late Stream<List<Album>>? _photosStream;
  List<String> documentsList = [];

  final StorageService _storageService = StorageService();

  int limit = 50;

  @override
  void initState() {
    super.initState();
    getDocuments(widget.title);
    photosSnapshot(widget.title, limit);
  }

  Future getDocuments(String chileName) async {
    await _firestore
        .collectionGroup("album")
        .orderBy("createdAt", descending: true)
        .where("title", isEqualTo: chileName)
        .get()
        // ignore: avoid_function_literals_in_foreach_calls
        .then((snapshot) => snapshot.docs.forEach((element) {
              documentsList.add(element.reference.id);
            }));
  }

  Stream<List<Album>> photosSnapshot(String childName, int limit) {
    var photos = _storageService.getPhotosByAlbum(childName, limit).snapshots();

    final albums = photos.map((snapshot) =>
        snapshot.docs.map((doc) => Album.fromSnapshot(doc)).toList());

    setState(() {
      _photosStream = albums;
    });
    return albums;
  }

  Future deleteDocuments(String childName, int index) async {
    var snapshot = await _firestore
        .collection("albums")
        .doc(childName)
        .collection("album")
        .orderBy("createdAt")
        .get();

    var docs = snapshot.docs.map((event) => event.reference);
    for (var doc in docs) {
      if (documentsList[index] == doc.id) {
        doc.delete();
        documentsList.removeWhere((element) => element.contains(doc.id));
      }
    }
  }

  Widget buildImage(Album image) {
    return Hero(
        tag: image.imageUrl,
        child: CachedNetworkImage(
          maxHeightDiskCache: widget.itemCount == 1
              ? 1200
              : widget.itemCount == 3
                  ? 600
                  : 250,
          fit: BoxFit.fill,
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return StreamBuilder(
      stream: _photosStream,
      builder: (context, snapshot) {
        // if (snapshot.hasData) {
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
                            child: Text("שתף", style: TextStyle(color: color.onBackground),),
                            onPressed: () {
                              Navigator.pop(context);
                              showModalBottomSheet(context: context, builder: (context) => Container());
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
                                      deleteDocuments(widget.title, index);
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
                                      images: photos, index: index),
                                ));
                          },
                          child: buildImage(photos[index])),
                    );
            },
          );
      },
    );
  }
}

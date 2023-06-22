import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../models/album.dart';
import '../services/images_manager.dart';
import '../utils/colors.dart';

class AllImages extends StatefulWidget {
  const AllImages({required this.title, super.key});

  final String title;

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  int _numOfAxisCount = 3;
  List<XFile> selectedImagesList = [];
  late Stream<List<Album>> _photosStream;
  List<String> documentsList = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final StorageService _storageService = StorageService();
  final ImagesManagerService _imagesService = ImagesManagerService();

  @override
  void initState() {
    super.initState();
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

  void selectedImages(String childName) async {
    ImagePicker imagePicker = ImagePicker();
    final images = await _imagesService.selectImages(imagePicker, childName);
    setState(() {
      selectedImagesList = images;
    });

    for (var item in selectedImagesList) {
      final ref = _storage.ref("images/albums/$childName/${item.name}");
      await ref.putFile(File(item.path));
      final imageUrl = await ref.getDownloadURL();
      _storageService.addPhotosToAlbum(childName, imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          elevation: 0.0,
          onPressed: () {
            selectedImages(widget.title);
          },
          child: const Icon(Icons.add_a_photo),
        ),
        body: Column(
          children: [
            PlatformAppBar(
              // title: CustomText(
              //   fontSize: 16,
              //   color: white,
              //   text: widget.title,
              //   fontWeight: FontWeight.w600,
              // ),
              cupertino: (_, __) => CupertinoNavigationBarData(
                trailing: const CustomText(
                  fontSize: 16,
                  color: primaryColor,
                  text: "סיים",
                ),
                transitionBetweenRoutes: true,
                title: const CustomText(
                  fontSize: 18,
                  color: primaryColor,
                  text: "כל התמונות",
                  fontWeight: FontWeight.w500,
                ),
              ),
              material: (_, __) => MaterialAppBarData(
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (_numOfAxisCount != 6) {
                          setState(() {
                            _numOfAxisCount += 1;
                          });
                        }
                      },
                      icon: const Icon(Icons.zoom_out),
                    ),
                    IconButton(
                        onPressed: () {
                          if (_numOfAxisCount != 1) {
                            setState(() {
                              _numOfAxisCount -= 1;
                            });
                          }
                        },
                        icon: const Icon(Icons.zoom_in)),
                  ],
                  backgroundColor: primaryColor,
                  title: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CustomText(
                      fontSize: 16,
                      color: white,
                      text: widget.title,
                    ),
                  )),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                // onTap: widget.switchScreen,
                child: Icon(
                  Icons.adaptive.arrow_back,
                  color: isIos ? primaryColor : white,
                  size: 18,
                ),
              ),
            ),

            // FirestoreQueryBuilder<Map<String, dynamic>>(
            //   query: _storageService.getPhotos("קו אביטל 23"),
            //   pageSize: 70,
            //   builder: (context, snapshot, child) {
            //     return GridView.builder(
            //         physics: const BouncingScrollPhysics(),
            //         gridDelegate:
            //             const SliverGridDelegateWithFixedCrossAxisCount(
            //                 crossAxisCount: 4),
            //         itemCount: snapshot.docs.length,
            //         itemBuilder: (context, index) {
            //           String photo = snapshot.docs[index]['imageUrl'];
            //
            //           if (snapshot.hasMore) {
            //             snapshot.fetchMore();
            //           }
            //           return GestureDetector(
            //               onTap: () {
            //                 // Navigator.push(context,
            //                 //   MaterialPageRoute(builder: (context) => ,);
            //               },
            //               child: photo.contains("jpg") ||
            //                       photo.contains("jpeg")
            //                   ? CachedNetworkImage(
            //                       maxHeightDiskCache: 250,
            //                       fit: BoxFit.fill,
            //                       imageUrl: photo,
            //                       fadeInDuration:
            //                           const Duration(milliseconds: 150),
            //                     )
            //                   : photo.contains("HEIC")
            //                       ? Container()
            //                       : Container());
            //         });
            //   },
            // ),
            StreamBuilder(
              stream: _photosStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var photos = snapshot.data!;
                  return Flexible(
                    flex: 1,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          crossAxisCount: _numOfAxisCount),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return InkWell(
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
                              maxHeightDiskCache:
                                  _numOfAxisCount == 1 ? 1200 : 600,
                              fit: BoxFit.fill,
                              imageUrl: photos[index].imageUrl,
                              fadeInDuration: const Duration(milliseconds: 150),
                            ),
                          ),
                        );
                        // return CupertinoContextMenu(
                        //   actions: <Widget>[
                        //     CupertinoContextMenuAction(
                        //       trailingIcon: const IconData(0xf37f,
                        //           fontFamily: CupertinoIcons.iconFont,
                        //           fontPackage:
                        //               CupertinoIcons.iconFontPackage),
                        //       child: const Text("Delete photo"),
                        //       onPressed: () {
                        //         // _firestore.collection("תיקייה").doc(documentsList[index]).delete();
                        //       },
                        //     )
                        //   ],
                      },
                    ),
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
                          CupertinoProgressIndicatorData(animating: true),
                    ),
                  );
                }
                return const Center(
                  child: Text("אין מידע להציג"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

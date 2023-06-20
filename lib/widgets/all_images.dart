import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/services/images_manager.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';
import 'package:regiment8112_project/widgets/image_slider.dart';
import '../models/album.dart';
import '../utils/colors.dart';

class AllImages extends StatefulWidget {
  const AllImages({required this.title, super.key});

  final String title;

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {

  List<XFile> _selectedImagesList = [];
  List<Album> imagesList = [];
  late Stream<List<Album>> _photosStream;

  final ImagesService _imagesService = ImagesService();
  final StorageService _storageService = StorageService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    getPhotosFromAlbum("קו אביטל 23");
    photosSnapshot("קו אביטל 23");
  }

  Future<List<Album>> getPhotosFromAlbum(String childName) async {
    var photos = await _storageService.getPhotos(childName).limit(70).orderBy("createdAt", descending: false).get();

    final albums = photos.docs.map((doc) => Album.fromSnapshot(doc)).toList();

    setState(() {
      imagesList = albums;
    });
    return albums;
  }

  Stream<List<Album>> photosSnapshot(String childName) {
    var photos = _storageService.getPhotos(childName).snapshots();

    final albums = photos.map((snapshot) =>
        snapshot.docs.map((doc) => Album.fromSnapshot(doc)).toList());

    setState(() {
      _photosStream = albums;
    });
    return albums;
  }

  void selectedImages(String childName) async {
    ImagePicker imagePicker = ImagePicker();
    final images = await _imagesService.selectImages(imagePicker, childName);
    setState(() {
      _selectedImagesList = images;
    });

    for (var item in _selectedImagesList) {
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
            selectedImages("קו אביטל 23");
          },
          child: const Icon(Icons.add_a_photo),
        ),
        body: Stack(
          children: [
            StreamBuilder(
              stream: _photosStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              crossAxisCount: 4),
                      itemCount: 50,
                      itemBuilder: (context, index) {
                        var photos = snapshot.data!;
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
                              maxHeightDiskCache: 150,
                              fit: BoxFit.fill,
                              imageUrl: photos[index].imageUrl,
                              fadeInDuration: const Duration(milliseconds: 150),
                            ),
                          ),
                        );
                      });
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
                return Center(
                  child: Container(
                    child: const Text("No results"),
                  ),
                );
              },
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
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: PlatformAppBar(
                cupertino: (_, __) => CupertinoNavigationBarData(
                  transitionBetweenRoutes: true,
                  title: const CustomText(
                    fontSize: 18,
                    color: primaryColor,
                    text: "כל התמונות",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                material: (_, __) => MaterialAppBarData(
                    backgroundColor: primaryColor,
                    title: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CustomText(
                        fontSize: 16,
                        color: white,
                        text: "חזרה",
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
            ),
          ],
        ),
      ),
    );
  }
}

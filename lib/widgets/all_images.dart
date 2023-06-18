import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/data/images.dart';
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
  List<Album> imagesList = [];
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    getPhotosFromAlbum("קו אביטל 23");
  }

  Future<List<Album>> getPhotosFromAlbum(String childName) async {
    var photos = await _storageService.getPhotos(childName).limit(70).get();

    final albums = photos.docs.map((doc) => Album.fromSnapshot(doc)).toList();

    setState(() {
      imagesList = albums;
    });
    return albums;
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
            // ImagePicker imagePicker = ImagePicker();
            // ImagesManagerService().selectImages(imagePicker, 'folder');
          },
          child: const Icon(Icons.add_a_photo),
        ),
        body: Stack(
          children: [
            GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2, mainAxisSpacing: 2, crossAxisCount: 4),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageGallery(images: imagesList, index: index),
                        ),
                      );
                    },
                    child: Hero(
                      tag: imagesList[index].imageUrl,
                      child: CachedNetworkImage(
                        maxHeightDiskCache: 250,
                        fit: BoxFit.fill,
                        imageUrl: imagesList[index].imageUrl,
                        fadeInDuration: const Duration(milliseconds: 150),
                      ),
                    ),
                  );
                }),

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
                      fontSize: 18,color: primaryColor, text: "כל התמונות", fontWeight: FontWeight.w500,),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/services/images_manager.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

import '../../utils/colors.dart';

class AllImagesTab extends StatefulWidget {
  const AllImagesTab(this.switchScreen, {super.key});

  final void Function() switchScreen;

  @override
  State<AllImagesTab> createState() => _AllImagesTabState();
}

class _AllImagesTabState extends State<AllImagesTab> {
  late CollectionReference<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = StorageService().getPhotos("קו אביטל 23");
  }

  @override
  Widget build(BuildContext context) {
    var limit = _data.limit(70);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          elevation: 0.0,
          onPressed: () {
            ImagePicker imagePicker = ImagePicker();
            ImagesManagerService().selectImages(imagePicker, 'folder');
          },
          child: const Icon(Icons.add_a_photo),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 100.0,
              child: Expanded(
                child: FirestoreQueryBuilder<Map<String, dynamic>>(
                  query: limit,
                  pageSize: 70,
                  builder: (context, snapshot, child) {
                    return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                        itemCount: snapshot.docs.length,
                        itemBuilder: (context, index) {
                          String photo = snapshot.docs[index]['photoId'];

                          if (snapshot.hasMore) {
                            snapshot.fetchMore();
                          }
                          return GestureDetector(
                              onLongPress: () {},
                              onTap: () {
                              },
                              child: photo.contains("jpg") ||
                                      photo.contains("jpeg")
                                  ? CachedNetworkImage(
                                      maxHeightDiskCache: 150,
                                      fit: BoxFit.fill,
                                      imageUrl: snapshot.docs[index]["photoId"],
                                      fadeInDuration:
                                          const Duration(milliseconds: 100),
                                    )
                                  : photo.contains("HEIC")
                                      ? Container()
                                      : Container());
                        });
                  },
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                toolbarHeight: 30.0,
                backgroundColor: const Color.fromRGBO(60, 58, 59, 0.5),
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  // onTap: widget.switchScreen,
                  child: const Icon(
                    Icons.arrow_back,
                    color: white,
                  ),
                ),
                title: const CustomText(
                  fontSize: 16,
                  color: white,
                  text: "חזרה",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

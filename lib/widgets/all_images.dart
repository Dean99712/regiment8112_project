import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/services/images_manager.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';
import '../utils/colors.dart';

class AllImages extends StatefulWidget {
  const AllImages({super.key});


  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  // late CollectionReference<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    // _data = StorageService().getPhotos("קו אביטל 23");
  }

  @override
  Widget build(BuildContext context) {
    // var limit = _data.limit(70);
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
            Expanded(
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                  itemCount: 150,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onLongPress: () {},
                        onTap: () {
                          // Navigator.push(context,
                          //   MaterialPageRoute(builder: (context) => ,);
                        },
                        child: CachedNetworkImage(
                          maxHeightDiskCache: 150,
                          fit: BoxFit.fill,
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/regiment8112-8abfe.appspot.com/o/images%2Falbums%2F%D7%A7%D7%95%20%D7%90%D7%91%D7%99%D7%98%D7%9C%2023%2F20230417_135827.jpg?alt=media&token=6efce6da-a939-4962-bd86-9f79a14e132a",
                          fadeInDuration: const Duration(milliseconds: 100),
                        ));
                  }),
              // child: FirestoreQueryBuilder<Map<String, dynamic>>(
              //   query: limit,
              //   pageSize: 70,
              //   builder: (context, snapshot, child) {
              //     return GridView.builder(
              //         physics: const BouncingScrollPhysics(),
              //         gridDelegate:
              //             const SliverGridDelegateWithFixedCrossAxisCount(
              //                 crossAxisCount: 4),
              //         itemCount: snapshot.docs.length,
              //         itemBuilder: (context, index) {
              //           String photo = snapshot.docs[index]['photoId'];
              //
              //           if (snapshot.hasMore) {
              //             snapshot.fetchMore();
              //           }
              //           return GestureDetector(
              //               onLongPress: () {},
              //               onTap: () {
              //                 // Navigator.push(context,
              //                 //   MaterialPageRoute(builder: (context) => ,);
              //               },
              //               child: photo.contains("jpg") ||
              //                       photo.contains("jpeg")
              //                   ? CachedNetworkImage(
              //                       maxHeightDiskCache: 150,
              //                       fit: BoxFit.fill,
              //                       imageUrl: snapshot.docs[index]["photoId"],
              //                       fadeInDuration:
              //                           const Duration(milliseconds: 100),
              //                     )
              //                   : photo.contains("HEIC")
              //                       ? Container()
              //                       : Container());
              //         });
              //   },
              // ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: PlatformAppBar(
                cupertino: (_, __) => CupertinoNavigationBarData(
                  transitionBetweenRoutes: true,
                  backgroundColor: const Color.fromRGBO(60, 58, 59, 0.5),
                  title: const CustomText(
                      fontSize: 16, color: white, text: "חזרה"),
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
                    color: white,
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

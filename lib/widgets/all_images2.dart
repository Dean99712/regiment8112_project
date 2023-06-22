import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/all_images.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

import '../services/firebase_storage_service.dart';
import '../services/images_manager.dart';

class AllImages2 extends StatefulWidget {
  const AllImages2({required this.title, super.key});

  final String title;

  @override
  State<AllImages2> createState() => _AllImages2State();
}

class _AllImages2State extends State<AllImages2> {
  List<XFile> selectedImagesList = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final StorageService _storageService = StorageService();
  final ImagesService _imagesService = ImagesService();

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
    return PlatformApp(
      debugShowCheckedModeBanner: false,
        cupertino: (_, __) => CupertinoAppData(
              home: CupertinoPageScaffold(
                child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                          CupertinoSliverNavigationBar(
                            largeTitle: Text(widget.title,
                                style: GoogleFonts.heebo(
                                    fontWeight: FontWeight.w600)),
                            trailing: CupertinoButton(
                              child: const Icon(CupertinoIcons.ellipsis_circle),
                              onPressed: () {},
                            ),
                            leading: CupertinoButton(
                              child: const Icon(
                                CupertinoIcons.plus,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                selectedImages(widget.title);
                              },
                            ),
                          )
                        ],
                    body: AllImages(title: widget.title,)),
              ),
            ),
        material: (_, __) => MaterialAppData(
                home: Scaffold(
              body: Container(),
            )));
  }
}

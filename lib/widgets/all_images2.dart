import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
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
  int _numOfAxisCount = 3;
  bool isExtended = false;
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

  late ScrollController _scrollController;
  double _scrollControllerOffset = 0.0;

  _scrollListener() {
    setState(() {
      _scrollControllerOffset = _scrollController.offset;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
        debugShowCheckedModeBanner: false,
        cupertino: (_, __) => CupertinoAppData(
              home: CupertinoPageScaffold(
                child: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    CupertinoSliverNavigationBar(
                      transitionBetweenRoutes: true,
                      stretch: true,
                      largeTitle: Text(
                        widget.title,
                        style: GoogleFonts.heebo(fontWeight: FontWeight.w600),
                      ),
                      trailing: CupertinoButton(
                        child: const Icon(
                          CupertinoIcons.ellipsis_circle,
                          color: primaryColor,
                        ),
                        onPressed: () {

                        },
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
                  body: AllImages(
                    _numOfAxisCount,
                    title: widget.title,
                    scrollOffset: _scrollControllerOffset,
                    scrollController: _scrollController,
                  ),
                ),
              ),
            ),
        material: (_, __) {
          var color = _scrollControllerOffset < 50 ? white : white;
          return MaterialAppData(
              home: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              actions: [
                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(enabled: _numOfAxisCount != 1 ? true : false, child: TextButton.icon(onPressed: () {
                        if(_numOfAxisCount != 1) {
                          setState(() {
                            _numOfAxisCount -= 1;
                          });
                        }
                      }, icon: const Icon(Icons.zoom_in), label: const Text("zoom in"))),
                      PopupMenuItem(child: TextButton.icon(onPressed: () {
                        if(_numOfAxisCount != 6) {
                          setState(() {
                            _numOfAxisCount += 1;
                          });
                        }
                      }, icon: const Icon(Icons.zoom_out), label: const Text("zoom out")))
                    ];
                  },
                  icon: const Icon(Icons.more_horiz),
                )
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: color,
                ),
              ),
              centerTitle: true,
              title: CustomText(
                  fontSize: 18,
                  color: color,
                  text: widget.title,
                  fontWeight: FontWeight.w600),
              backgroundColor: _scrollControllerOffset < 50
                  ? primaryColor
                  : Colors.transparent
                      .withOpacity((_scrollControllerOffset / 350).clamp(0, 1))
                      .withOpacity(0.1),
            ),
            extendBodyBehindAppBar: true,
            floatingActionButton: ScrollingFabAnimated(
              width: 175,
              icon: const Icon(Icons.add_a_photo_sharp, color: white),
              text: const CustomText(
                  fontSize: 16, color: white, text: "הוסף תמונות"),
              onPress: () {
                selectedImages(widget.title);
              },
              scrollController: _scrollController,
              animateIcon: false,
              color: primaryColor,
              duration: const Duration(milliseconds: 150),
              elevation: 0.0,
              inverted: true,
              radius: 40.0,
            ),
            body: AllImages(
              _numOfAxisCount,
              title: widget.title,
              scrollOffset: _scrollControllerOffset,
              scrollController: _scrollController,
            ),
          ));
        });
  }
}

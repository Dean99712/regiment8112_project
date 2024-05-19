import 'dart:io';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../providers/user_provider.dart';
import '../services/firebase_storage_service.dart';
import '../services/images_manager.dart';
import '../utils/colors.dart';
import '../widgets/all_images.dart';
import '../widgets/custom_text.dart';

class ImagesScreen extends ConsumerStatefulWidget {
  const ImagesScreen({required this.title, super.key});

  final String title;

  @override
  ConsumerState<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends ConsumerState<ImagesScreen> {
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

      var bytes = await item.readAsBytes();
      final hash = img.decodeImage(bytes);
      var blurHash = BlurHash.encode(hash!, numCompX: 1, numCompY: 1);
      _storageService.addPhotosToAlbum(childName, imageUrl, blurHash.hash);
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget pullDownButton(BuildContext context, void Function() function,
      void Function() function2) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PullDownButton(
        position: PullDownMenuPosition.automatic,
        itemBuilder: (context) => [
          PullDownMenuItem(
            onTap: function,
            title: 'הגדלה',
            icon: CupertinoIcons.zoom_in,
          ),
          PullDownMenuItem(
            title: 'הקטנה',
            onTap: function2,
            icon: CupertinoIcons.zoom_out,
          )
        ],
        animationBuilder: null,
        buttonBuilder:
            (BuildContext context, Future<void> Function() showMenu) {
          return CupertinoButton(
            onPressed: showMenu,
            child: const Icon(CupertinoIcons.ellipsis_circle),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = ref.watch(userProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      child: PlatformScaffold(
          cupertino: (_, __) => CupertinoPageScaffoldData(
                body: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    CupertinoSliverNavigationBar(
                      backgroundColor: colorScheme.surface.withOpacity(0.5),
                      padding: EdgeInsetsDirectional.zero,
                      automaticallyImplyTitle: true,
                      previousPageTitle: widget.title,
                      transitionBetweenRoutes: true,
                      stretch: true,
                      largeTitle: Text(
                        widget.title,
                        style: GoogleFonts.heebo(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      trailing: pullDownButton(context, () {
                        if (_numOfAxisCount != 1) {
                          setState(() {
                            _numOfAxisCount -= 1;
                          });
                        }
                      }, () {
                        if (_numOfAxisCount != 6) {
                          setState(() {
                            _numOfAxisCount += 1;
                          });
                        }
                      }),
                      leading: CupertinoButton(
                        child: isAdmin
                            ? const Icon(
                                CupertinoIcons.plus,
                                color: primaryColor,
                              )
                            : const Icon(
                                CupertinoIcons.back,
                                color: primaryColor,
                              ),
                        onPressed: () {
                          if (isAdmin) selectedImages(widget.title);
                          if (!isAdmin) Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                  body: AllImages(_numOfAxisCount,
                      title: widget.title,
                      scrollOffset: _scrollControllerOffset,
                      scrollController: _scrollController),
                ),
              ),
          material: (_, __) {
            var color = _scrollControllerOffset < 50 ? white : white;
            return MaterialScaffoldData(
              appBar: AppBar(
                elevation: 0.0,
                actions: [
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          enabled: _numOfAxisCount != 1 ? true : false,
                          child: TextButton.icon(
                            onPressed: () {
                              if (_numOfAxisCount != 1) {
                                setState(() {
                                  _numOfAxisCount -= 1;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.zoom_in,
                              color: secondaryColor,
                            ),
                            label: Text(
                                style: TextStyle(color: colorScheme.onSurface),
                                "הגדל"),
                          ),
                        ),
                        PopupMenuItem(
                          enabled: _numOfAxisCount != 6 ? true : false,
                          child: TextButton.icon(
                            onPressed: () {
                              if (_numOfAxisCount != 6) {
                                setState(() {
                                  _numOfAxisCount += 1;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.zoom_out,
                              color: secondaryColor,
                            ),
                            label: Text(
                                style: TextStyle(color: colorScheme.onSurface),
                                "הקטן"),
                          ),
                        )
                      ];
                    },
                    icon: Icon(Icons.more_horiz, color: color,),
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
              floatingActionButton: isAdmin
                  ? ScrollingFabAnimated(
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
                    )
                  : null,
              body: AllImages(
                _numOfAxisCount,
                title: widget.title,
                scrollOffset: _scrollControllerOffset,
                scrollController: _scrollController,
              ),
            );
          }),
    );
  }
}

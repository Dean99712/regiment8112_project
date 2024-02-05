import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:share_plus/share_plus.dart';
import '../models/album.dart';
import '../services/firebase_storage_service.dart';
import '../services/images_manager.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class ImageGallery extends StatefulWidget {
  ImageGallery(
      {required this.title,
      required this.images,
      required this.index,
      super.key,
      this.scrollController});

  final String title;
  late int index;
  final List<Album> images;
  final ScrollController? scrollController;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final ImagesService _imagesService = ImagesService();
  final StorageService _service = StorageService();

  void displayAlert(BuildContext context, String title, String text,
      void Function() function) {
    final theme = Theme.of(context).colorScheme;

    Future<void>.delayed(
      Duration.zero,
      () => showDialog(
        context: context,
        barrierColor: Colors.black26,
        builder: (context) => SizedBox(
          child: AlertDialog(
            backgroundColor: theme.background,
            title: Text(title,
                textAlign: TextAlign.right,
                style: TextStyle(color: theme.onBackground, fontSize: 16)),
            actions: [
              TextButton(
                  onPressed: function,
                  child: CustomText(
                    text: text,
                    color: theme.error,
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const CustomText(
                      text: "ביטול", color: CupertinoColors.activeBlue))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(initialPage: widget.index);
    String title = widget.title;
    List<Album> images = widget.images;
    int index = widget.index;

    return PlatformScaffold(
      cupertino: (_, __) => CupertinoPageScaffoldData(
        navigationBar: CupertinoNavigationBar(
          padding: EdgeInsetsDirectional.zero,
          trailing: pullDownButton(context, title, images, index),
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.3),
          leading: CupertinoButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              CupertinoIcons.chevron_back,
              color: white,
            ),
          ),
        ),
        body: ImageSlider(
          images: images,
          index: index,
        ),
      ),
      material: (_, __) => MaterialScaffoldData(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () async {
                          List<XFile> photo =
                              await _imagesService.shareImages(images[index]);
                          await Share.shareXFiles(photo,
                              text: photo[0].name, subject: "שתף תמונה");
                        },
                        child: const Text("שתף/ שתפי תמונה"),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          displayAlert(context, "אתה עומד למחוק את התמונה",
                              "מחק את התמונה", () async {
                            await _service.deleteDocument(
                                title, images[index].id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                          // Navigator.pop(context);
                        },
                        child: const Text("מחק/י תמונה זו"),
                      ),
                    ],
                icon: const Icon(Icons.more_horiz))
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: ImageSlider(
          images: images,
          index: index,
          controller: pageController,
          onPageChange: (index) {
            setState(() {
              index = index;
            });
          },
        ),
      ),
    );
  }
}

Widget pullDownButton(
    BuildContext context, String title, List<Album> images, int index) {
  final StorageService service = StorageService();
  final ImagesService imagesService = ImagesService();

  return PullDownButton(
    itemBuilder: (context) => [
      PullDownMenuItem(
        title: "שתף",
        onTap: () async {
          List<XFile> photo = await imagesService.shareImages(images[index]);
          await Share.shareXFiles(photo,
              text: photo[0].name, subject: "שתף תמונה");
        },
        icon: CupertinoIcons.share,
      ),
      PullDownMenuItem(
        onTap: () {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              message: const Text("פעולה זו תמחוק את התמונה לצמיתות"),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    await service.deleteDocument(
                        title, images[index].id);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  isDestructiveAction: true,
                  child: const Text("מחיקת התמונה"),
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "ביטול",
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            ),
          );
        },
        title: 'מחק תמונה זו',
        isDestructive: true,
        icon: CupertinoIcons.delete,
      ),
    ],
    animationBuilder: null,
    position: PullDownMenuPosition.automatic,
    buttonBuilder: (BuildContext context, Future<void> Function() showMenu) {
      return CupertinoButton(
          onPressed: showMenu,
          child: const Icon(CupertinoIcons.ellipsis_circle));
    },
  );
}

class ImageSlider extends StatefulWidget {
  const ImageSlider(
      {required this.images,
      required this.index,
      this.controller,
      this.onPageChange,
      super.key});

  final int index;
  final List<Album> images;
  final PageController? controller;
  final void Function(int)? onPageChange;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  TapDownDetails? tapDownDetails;
  late TransformationController transformationController;

  @override
  Widget build(BuildContext context) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return PhotoViewGallery.builder(
      onPageChanged: widget.onPageChange,
      itemCount: widget.images.length,
      builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
        child: Hero(
          transitionOnUserGestures: true,
          tag: widget.images[index].id,
          child: GestureDetector(
            onDoubleTap: () {
              const double scale = 3;
              final zoomed = Matrix4.identity()..scale(scale);
              final value = zoomed;
              transformationController.value = value;
            },
            child: InteractiveViewer(
              transformationController: transformationController,
              clipBehavior: Clip.none,
              scaleEnabled: true,
              child: CachedNetworkImage(
                maxHeightDiskCache: 1200,
                imageUrl: widget.images[index].imageUrl,
                fadeInDuration: const Duration(milliseconds: 150),
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(
                    child: PlatformCircularProgressIndicator(
                      material: (context, platform) =>
                          MaterialProgressIndicatorData(
                              color: primaryColor,
                              strokeWidth: 2,
                              backgroundColor: greyShade100.withOpacity(0.5)),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        minScale: PhotoViewComputedScale.contained,
      ),
      pageController:
          isIos ? PageController(initialPage: widget.index) : widget.controller,
      loadingBuilder: (context, event) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      enableRotation: false,
    );
  }

  @override
  void initState() {
    super.initState();
    transformationController = TransformationController();
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }
}

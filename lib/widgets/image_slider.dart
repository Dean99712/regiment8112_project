import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/utils/colors.dart';
import '../models/album.dart';
import 'custom_text.dart';

class ImageGallery extends StatefulWidget {
  ImageGallery(
      {this.title,
      required this.images,
      required this.index,
      super.key,
      this.scrollController});

  final String? title;
  late int index;
  final List<Album> images;
  final ScrollController? scrollController;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
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
                  child: CustomText(text: "ביטול", color: Colors.blueAccent))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // var scrollOffset = widget.index / widget.images.length / size.height;

    print(widget.images.length);
    final PageController pageController =
        PageController(initialPage: widget.index);
    return PlatformScaffold(
      cupertino: (_, __) => CupertinoPageScaffoldData(
        navigationBar: CupertinoNavigationBar(
          trailing: CupertinoContextMenu(
            actions: [
              CupertinoContextMenuAction(
                  child: CupertinoButton(
                      child: const Text("Press"), onPressed: () {}))
            ],
            child: Text(""),
          ),
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
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
          images: widget.images,
          index: widget.index,
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
                        onTap: () {
                          Future<void>.delayed(
                            Duration.zero,
                            () => showModalBottomSheet(
                                context: context,
                                barrierColor: Colors.black26,
                                builder: (context) => Container()),
                          );
                        },
                        child: const Text("שתף/ שתפי תמונה"),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          displayAlert(context, "אתה עומד למחוק את התמונה",
                              "מחק את התמונה", () async {
                            await _service.deleteDocument(
                                widget.title!, widget.images[widget.index].id);
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
          images: widget.images,
          index: widget.index,
          controller: pageController,
          onPageChange: (index) {
            setState(() {
              widget.index = index;
            });
          },
        ),
      ),
    );
  }
}

class ImageSlider extends StatelessWidget {
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
  Widget build(BuildContext context) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return PhotoViewGallery.builder(
      onPageChanged: onPageChange,
      itemCount: images.length,
      builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
        child: Hero(
          tag: images[index].imageUrl,
          child: CachedNetworkImage(
            maxHeightDiskCache: 1200,
            fit: BoxFit.fitWidth,
            imageUrl: images[index].imageUrl,
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
        minScale: PhotoViewComputedScale.contained,
      ),
      pageController: isIos ? PageController(initialPage: index) : controller,
      loadingBuilder: (context, event) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      enableRotation: true,
    );
  }
}

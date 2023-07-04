import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:regiment8112_project/utils/colors.dart';
import '../models/album.dart';
import '../providers/documents_provider.dart';

class ImageGallery extends ConsumerWidget {
  const ImageGallery(
      {this.title, required this.images, required this.index, super.key});

  final String? title;
  final int index;
  final List<Album> images;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController pageController =
        PageController(initialPage: index, keepPage: true);

    return PlatformScaffold(
      cupertino: (_, __) => CupertinoPageScaffoldData(
          navigationBar: CupertinoNavigationBar(
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
            images: images,
            index: index,
          )),
      material: (_, __) => MaterialScaffoldData(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            actions: [
              PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            showPlatformDialog(
                              context: context,
                              builder: (context) => const Text(
                                  "אתה עומד למחוק תמונה זו, האם אתה בטוח ?"),
                            );
                          },
                          child: const Text("שתף תמונה"),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            ref
                                .read(documentsProvider.notifier)
                                .deleteDocument(title!, index);
                            images.removeAt(index);
                            pageController.jumpToPage(index + 1);
                          },
                          child: const Text("מחק תמונה זו"),
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
          )),
    );
  }
}

class ImageSlider extends StatelessWidget {
  const ImageSlider(
      {required this.images, required this.index, this.controller, super.key});

  final int index;
  final List<Album> images;
  final PageController? controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Hero(
          tag: images[index].imageUrl,
          child: PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (context, index) =>
                PhotoViewGalleryPageOptions.customChild(
              child: CachedNetworkImage(
                imageUrl: images[index].imageUrl,
                maxHeightDiskCache: 1200,
                fadeInDuration: const Duration(milliseconds: 100),
                fit: BoxFit.fitWidth,
              ),
              minScale: PhotoViewComputedScale.contained,
            ),
            pageController: controller,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            enableRotation: true,
          ),
        ),
      ),
    );
  }
}

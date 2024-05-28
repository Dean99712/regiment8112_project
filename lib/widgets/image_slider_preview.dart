import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../models/album.dart';
import '../utils/colors.dart';

class ImageSliderPreview extends StatelessWidget {
  const ImageSliderPreview({required this.images,
    required this.index,
    this.controller,
    this.onPageChange,
    super.key});

  final int index;
  final List<Album> images;
  final PageController? controller;
  final void Function(int)? onPageChange;

  Widget renderBody(BuildContext context) {

    return PhotoViewGallery.builder(
      onPageChanged: onPageChange,
      itemCount: images.length,
      builder: (context, index) =>
          PhotoViewGalleryPageOptions.customChild(
            child: Hero(
              tag: images[index].imageUrl,
              child: CachedNetworkImage(
                maxHeightDiskCache: 1200,
                fit: BoxFit.fitWidth,
                imageUrl: images[index].imageUrl,
                fadeInDuration: const Duration(milliseconds: 150),
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(child: PlatformCircularProgressIndicator(
                    material: (context, platform) =>
                        MaterialProgressIndicatorData(
                            color: primaryColor,
                            strokeWidth: 2,
                            backgroundColor: greyShade100.withOpacity(0.5)
                        ),
                  ),);
                },
              ),
            ),
            minScale: PhotoViewComputedScale.contained,
          ),
      pageController: PageController(initialPage: index),
      loadingBuilder: (context, event) =>
      const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      enableRotation: true,
    );
  }

  @override
  Widget build(BuildContext context) {

    return PlatformScaffold(
      cupertino: (_, __) =>
          CupertinoPageScaffoldData(
            navigationBar: const CupertinoNavigationBar(
              automaticallyImplyLeading: true,
              backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
            ),
            body: renderBody(context),
          ),
      material: (_, __) =>
          MaterialScaffoldData(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                backgroundColor: Colors.transparent,
              ),
              body: renderBody(context)
          ),
    );
  }
}
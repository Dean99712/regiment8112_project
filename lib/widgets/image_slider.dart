import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({required this.imagesList, super.key});

  final List<String> imagesList;

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
        itemCount: imagesList.length,
        builder: (context, index) {
          final imageUrl = imagesList[index];

          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrl),
          );
        });
  }
}

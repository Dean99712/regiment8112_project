import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../models/album.dart';

class ImagesService {

  Future<List<XFile>> selectImages(
      ImagePicker imagePicker, String childName) async {
    List<XFile> imageFilesList = [];
    List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFilesList.addAll(selectedImages);
    }
    return imageFilesList;
  }

  Future<List<XFile>> shareImages(Album photo) async {
    var file = await DefaultCacheManager().getSingleFile(photo.imageUrl);
    XFile result = await XFile(file.path);
    return [result];
  }
}

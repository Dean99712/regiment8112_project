import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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


  Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath/${rng.nextInt(10000)}.png');
    final http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<List<XFile>> shareImages(Album photo) async {
    File file = await urlToFile(photo.imageUrl);
    XFile result = XFile(file.path);
    return [result];
  }
}

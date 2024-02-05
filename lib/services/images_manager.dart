import 'package:firebase_storage/firebase_storage.dart';
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
    final storage = FirebaseStorage.instance.ref();
    print(photo.imageUrl);
    storage.child(photo.imageUrl);

    //TODO
    // final storage = FirebaseStorage.instance.ref();
    // final Uint8List? imageData = await storage.getData(1024 * 1024);
    // print(imageData!);
    var file = XFile(photo.imageUrl);
    XFile result = XFile(file.path);
    return [result];
  }
}

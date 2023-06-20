import 'package:image_picker/image_picker.dart';

class ImagesManagerService {

  Future<List<XFile>> selectImages(
      ImagePicker imagePicker, String childName) async {
    List<XFile> imageFilesList = [];
    List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFilesList.addAll(selectedImages);
    }
    return imageFilesList;
  }
}

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImagesManagerService {

final FirebaseStorage _storage = FirebaseStorage.instance;


  void selectImages(ImagePicker imagePicker, String childName) async {
    List<XFile> imageFilesList = [];
    List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if(selectedImages.isNotEmpty) {
      imageFilesList.addAll(selectedImages);
      Reference ref = _storage.ref('/images/albums/$childName');
       for(var item in selectedImages) {
         ref.putFile(item as File);
         // ref.putFile(File(item));
        // ref.putFile(item);
      }
      // _storage.ref()
    }
  }
}
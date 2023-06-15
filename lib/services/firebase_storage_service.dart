import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getPhotosDownloadUrl(String childName) async {
    Reference ref = _storage.ref('/images/albums/$childName');
    final listResult = await ref.listAll();
    var itemList = [];

    for (var item in listResult.items) {
      String url = await item.getDownloadURL();
      itemList.add(url);
      final metaData = await item.getMetadata();
      if (metaData.contentType == 'application/octet-stream') {
        final customMetaData = SettableMetadata(contentType: "image/jpeg");
        item.updateMetadata(customMetaData);
      }
      // addPhotosByAlbumName(childName, url);
    }
    return itemList;
  }

  void addPhotosToAlbum(String childName, String url) async {
    var collection =
        _firestore.collection("albums")
            .doc()
            .collection(childName);

    return collection.doc().set({"albumName": childName, "imageUrl": url});
  }

  CollectionReference<Map<String, dynamic>> getPhotos(String childName) {
    return _firestore.collection(childName);
  }

  Query<Map<String, dynamic>> getAllPhotos() {
    return _firestore.collectionGroup('');
  }

  Query<Map<String, dynamic>> getAlbumByName(String childName) {
    return _firestore.collectionGroup(childName);
  }
}

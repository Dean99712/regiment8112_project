import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getPhotosDownloadUrl(String childName) async {
    Reference ref = _storage.ref('/images/albums/$childName');
    final listResult = await ref.listAll();
    var itemList = [];
    for (var item in listResult.items) {
      final url = await item.getDownloadURL();
      itemList.add(url);
      addPhotos(childName, url);
    }
    return itemList;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPhotos(String childName) async {
    return await _firestore.collection("photos").doc(childName).get();
  }

  Future addPhotos(String childName, String url) async {
    var collection = _firestore.collection("photos").doc(childName);
    await collection.update({
      "photoId": FieldValue.arrayUnion([url])
    });
  }
}

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
    for(var item in listResult.items) {
    final url = await item.getDownloadURL();
      itemList.add(url);
    }
    return itemList;
  }

  Future<Iterable> getPhotos() async {
    var collection = await _firestore
        .collection("photos")
        .get()
        .then((snapshot) => snapshot.docs.map((document) {
         return document.get("photoId");
            }));
    return collection;
  }

  Future addPhotos(String childName) async {
    var collection = await _firestore
        .collection("photos");

  }
}

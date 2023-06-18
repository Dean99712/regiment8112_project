import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:regiment8112_project/models/album.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
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
      addPhotosToAlbum(childName, url);
    }
    return itemList;
  }

  void addPhotosToAlbum(String childName, String url) async {
    var collection =
        _firestore.collection("albums").doc(childName).collection(childName);

    var album = Album(title: childName, imageUrl: url).toJson();

    return collection.doc().set(album);
  }

  Query<Map<String, dynamic>> getPhotos(String childName) {
    return _firestore.collectionGroup(childName);
  }

  void getAllAlbums(String childName) async {
    final parentCollection = _firestore.collection("albums").snapshots();
    parentCollection.forEach((element) {
      final docs = element.docs;
      docs.forEach((item) {
        print(item.reference.path);
      });
    });
  }
}

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
    var parentCollection = _firestore.collection("albums").doc(childName);

    final data = {"albumName": childName, "createdAt": Timestamp.now()};
    parentCollection.set(data);

    final collection = parentCollection.collection(childName);
    var album =
        Album(title: childName, imageUrl: url, createdAt: Timestamp.now())
            .toJson();

    return collection.doc().set(album);
  }

  Query<Map<String, dynamic>> getPhotos(String childName) {
    return _firestore.collectionGroup(childName);
  }

  CollectionReference<Map<String, dynamic>> getAllAlbums() {
    return _firestore.collection("albums");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollectionDocs(
      String childName) async {
    return await _firestore.collection(childName).get();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:regiment8112_project/models/album.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getPhotosDownloadUrl(String childName) async {
    Reference ref = _storage.ref('/images/albums/$childName');
    final listResult = await ref.listAll();
    var itemList = [];

    for (var item in listResult.items) {
      String url = await item.getDownloadURL();
      itemList.add(url);
      // final name = item.name;
      addPhotosToAlbum(childName, url);
    }
    return itemList;
  }

  Future deleteDocument(String childName, String id) async {
    await _firestore
        .collection("albums")
        .doc(childName)
        .collection("album")
        .doc(id)
        .delete();
  }

  Future addPhotosToAlbum(String childName, String url) async {
    var parentCollection = _firestore.collection("albums").doc(childName);

    if (!parentCollection.id.contains(childName)) {
      final data = {"albumName": childName, "createdAt": Timestamp.now()};
      parentCollection.set(data);
    }

    final collection = parentCollection.collection('album');

    final uuid = Uuid().v4().replaceAll("-", "").substring(0, 20);
    var album = Album(
            id: uuid,
            title: childName,
            imageUrl: url,
            createdAt: Timestamp.now())
        .toJson();

    await collection.doc(uuid).set(album);
  }

  Query<Map<String, dynamic>> getPhotosByAlbum(String childName) {
    return _firestore
        .collectionGroup('album')
        .where('title', isEqualTo: childName)
        .orderBy("createdAt", descending: true);
  }

  CollectionReference<Map<String, dynamic>> getAllAlbums() {
    return _firestore.collection("albums");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollectionDocs(
      String childName) async {
    return await _firestore.collection(childName).get();
  }
}

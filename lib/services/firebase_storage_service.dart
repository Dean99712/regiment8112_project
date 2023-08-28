import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
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
      var bytes = await item.getData();
      final hash = img.decodeImage(bytes!);
      var blurHash = await BlurHash.encode(hash!, numCompX: 2, numCompY: 2);
      itemList.add(url);
      addPhotosToAlbum(childName, url, blurHash.hash);
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

  Future addPhotosToAlbum(String childName, String url, String hash) async {
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
            hash: hash,
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

  Future createAlbum( BuildContext context, String childName) async {
    var collection = _firestore.collection("albums").doc(childName);
    final data = {"albumName": childName, "createdAt": Timestamp.now()};
    if(collection.collection("albums").where(childName) == childName) {
      var snackBar = SnackBar(content: Text("שם של אלבום זה כבר קיים, אנא בחר שם חדש"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      return await collection.set(data);
    }
  }
}


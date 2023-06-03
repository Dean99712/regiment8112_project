import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getPhotosDownloadUrl(String childName) async {
    Reference ref = _storage.ref('/images/albums/$childName');
    final listResult = await ref.listAll();
    var itemList = [];
    listResult.items.forEach((element) async {
      var data = await element.getData();
      createFileFromBytes(data!);
      itemList.add(data);
    });
    return itemList;
  }

  File createFileFromBytes(Uint8List bytes) {
    var file = File.fromRawPath(bytes);
    print(file);
   return file;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPhotos(
      String childName) async {
    return await _firestore.collection("photos").doc(childName).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPhotos() async {
    var collection = await _firestore.collection("photos").get();
    return collection;
  }

  Future addPhotos(String childName, String url) async {
    var collection = _firestore.collection("photos").doc(childName);
    await collection.update({
      "photoId": FieldValue.arrayUnion([url])
    });
  }
}

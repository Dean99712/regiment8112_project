import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({Key? key}) : super(key: key);

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  late CollectionReference<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = StorageService().getPhotos("קו אביטל 23");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: FirestoreListView<Map<String, dynamic>>(
              query: _data,
              pageSize: 50,
              itemBuilder: (context, snapshot) {
                var photo = snapshot.data()['photoId'];
                return GestureDetector(
                  onTap: () {
                    print(photo);
                  },
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data()['photoId'],
                    fit: BoxFit.fill,
                  ),
                );
              })),
    );
  }
}

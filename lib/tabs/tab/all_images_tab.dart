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
    var limit = _data.limit(70);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: FirestoreQueryBuilder<Map<String, dynamic>>(
        query: limit,
        pageSize: 5,
        builder: (context, snapshot, child) {
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                  snapshot.fetchMore();
                }
                return GestureDetector(
                  onTap: () {
                    print(snapshot.docs[index]['photoId']);
                  },
                    child: CachedNetworkImage(fit: BoxFit.fill, imageUrl: snapshot.docs[index]["photoId"]));
              });
        },
      )),
    );
  }
}

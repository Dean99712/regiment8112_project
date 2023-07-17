import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/widgets/images_preview.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({super.key});

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  final StorageService _storage = StorageService();

  @override
  void initState() {
    getDocuments();
    super.initState();
  }

  Query<Object?> getDocuments()  {
    return _storage.getAllAlbums().orderBy("createdAt", descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder(
      query: getDocuments(),
      builder: (context, snapshot, child) {
        if(snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                var list = snapshot.docs.map((e) => e).toList();
                return ImagesPreview(
                  date: list[index].get('createdAt'),
                  text: list[index].get('albumName'),
                );
              },
            );
          }
        if(snapshot.isFetchingMore && snapshot.isFetching) {
          return Center(child: CircularProgressIndicator(),);
        }
        return Container();
      },
    );
  }
}

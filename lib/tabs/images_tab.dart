import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firebase_storage_service.dart';
import '../widgets/images_preview.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({super.key});

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  final StorageService _storage = StorageService();
  late Query _query;

  @override
  void initState() {
    if (mounted) {
      getDocuments();
    }
    super.initState();
  }

  void getDocuments() {
    Query query =
        _storage.getAllAlbums().orderBy("createdAt", descending: true).limit(3);
    if (mounted) {
      setState(() {
        _query = query;
      });
    }
  }

  Future onRefresh() async {
    return getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder(
      query: _query,
      builder: (context, snapshot, child) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                return ImagesPreview(
                    text: snapshot.docs[index].get("albumName"),
                    date: snapshot.docs[index].get("createdAt"));
              },
            ),
          );
        }
        if (snapshot.isFetching || snapshot.isFetchingMore) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
      },
    );
  }
}

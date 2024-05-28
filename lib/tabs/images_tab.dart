import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FirestoreQueryBuilder(
      query: _query,
      builder: (context, snapshot, child) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                final id = snapshot.docs[index].get("id");
                return ImagesPreview(
                  key: ValueKey(id),
                    text: snapshot.docs[index].get("albumName"),
                    date: snapshot.docs[index].get("createdAt"));
              }
          );
        }
        if (snapshot.isFetching || snapshot.isFetchingMore) {
          return Center(
            child: PlatformCircularProgressIndicator(
              cupertino: (context, platform) => CupertinoProgressIndicatorData(
                color: colorScheme.primary
              ),
              material: (context, platform) => MaterialProgressIndicatorData(
                color: colorScheme.primary
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/widgets/images_preview.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab(this.tabController, {super.key});

  final TabController tabController;

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  final StorageService _storage = StorageService();
  var activeScreen = 'images-preview';

  @override
  void initState() {
    super.initState();
  }

  Future<Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getDocuments() async {
    var collection = await _storage.getAllAlbums().orderBy("createdAt", descending: true).get();
    final data = collection.docs.map((e) => e);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDocuments(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var list = snapshot.data!.map((e) => e.data()).toList();
              String albumName = list[index]['albumName'];
              Timestamp createdAt = list[index]["createdAt"];
              return ImagesPreview(
                date: createdAt,
                text: albumName,
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

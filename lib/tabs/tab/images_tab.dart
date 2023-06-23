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

  void switchScreen() {
    if (activeScreen == 'images-preview') {
      setState(() {
        widget.tabController.animateTo(2);
        activeScreen = 'all-images';
      });
    } else {
      setState(() {
        widget.tabController.animateTo(1);
        activeScreen = 'images-preview';
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getDocuments() async {
    var collection = await _storage.getAllAlbums().get();
    final data = collection.docs.map((e) => e);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDocuments(),
      builder: (context, snapshot) {
        var list = snapshot.data!.map((e) => e.data()).toList();
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            String albumName = list[index]['albumName'];
            Timestamp createdAt = list[index]["createdAt"];
            return ImagesPreview(
              date: createdAt,
              text: albumName,
            );
          },
        );
      },
    );
  }
}

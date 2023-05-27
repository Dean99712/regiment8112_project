import 'package:flutter/material.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({Key? key}) : super(key: key);

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  late Future<Iterable> _data;

  @override
  void initState() {
    super.initState();
    _data = StorageService().getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(child: Image(image: NetworkImage(snapshot.data.toString().replaceAll("(", "").replaceAll(")", ""))),);
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}

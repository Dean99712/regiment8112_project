import 'package:firebase_auth/firebase_auth.dart';
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

  void function() {
    StorageService().getPhotosDownloadUrl("קו אביטל 23");
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(onPressed: function, child: Text(_auth.currentUser!.uid)),
          FutureBuilder(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: Image(
                      image: NetworkImage(snapshot.data
                          .toString()
                          .replaceAll("(", "")
                          .replaceAll(")", "")),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}

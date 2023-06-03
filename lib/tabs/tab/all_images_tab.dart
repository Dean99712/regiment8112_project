import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({Key? key}) : super(key: key);

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _data;

  @override
  void initState() {
    super.initState();
    _data = StorageService().getPhotos("קו אביטל 23");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
            List<dynamic> data = snapshot.data!.get("photoId");
             MasonryGridView.builder(
                itemCount: data.length,
                gridDelegate:
                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4

                ),
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: data[index],
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill),
                        ),
                      );
                    },
                  );
                });
          }
          if(!snapshot.hasData || snapshot.data!.data()!.isEmpty) {
            return const CircularProgressIndicator();
          }
          return Container();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:regiment8112_project/widgets/images_preview.dart';

import '../../services/firebase_storage_service.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({Key? key}) : super(key: key);

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}


class _ImagesTabState extends State<ImagesTab> {
  late Future<List> _data;

  @override
  void initState() {
    super.initState();
    // _data = StorageService().getPhotosDownloadUrl("קו אביטל 23");

  }

  // void function() {
  //   StorageService().getAllPhotos();
  // }

  @override
  Widget build(BuildContext context) {

    // final controller =
    // function();

    return SizedBox(
      height: MediaQuery.of(context).size.width,

      // child: FutureBuilder(
      //   future: _data,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
            // final data = snapshot.data!.docs;
            child: const ImagesPreview("קו אביטל")
            // return GroupedListView<String, String>(elements: _data, groupBy: _data['group']);
          // } else {
          //   return const CircularProgressIndicator();
          // }
        // },
      // ),
    );
  }
}

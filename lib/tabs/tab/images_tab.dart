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
    _data = StorageService().getPhotosDownloadUrl("קו אביטל 23");
  }

  @override
  Widget build(BuildContext context) {
    return const ImagesPreview("קו אביטל");
  }
}

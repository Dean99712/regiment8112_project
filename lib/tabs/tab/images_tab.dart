import 'package:flutter/material.dart';
import 'package:regiment8112_project/widgets/all_images.dart';
import 'package:regiment8112_project/widgets/images_preview.dart';

import '../../services/firebase_storage_service.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab(this.tabController, {super.key});

  final TabController tabController;

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
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

  late Future<List> _data;

  @override
  void initState() {
    super.initState();
    _data = StorageService().getPhotosDownloadUrl("קו אביטל 23");
  }

  @override
  Widget build(BuildContext context) {
    return ImagesPreview(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllImages(
            () {
              return;
            },
          ),
        ),
      );
    }, "קו אביטל");
    // return activeScreen == 'images-preview'
    //     ? ImagesPreview(switchScreen, "קו אביטל")
    //     : AllImagesTab(switchScreen);
  }
}

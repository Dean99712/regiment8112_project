import 'package:flutter/material.dart';
import 'package:regiment8112_project/services/firebase_storage_service.dart';
import 'package:regiment8112_project/widgets/all_images.dart';
import 'package:regiment8112_project/widgets/images_preview.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab(this.tabController, {super.key});

  final TabController tabController;

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {

  // final StorageService _storageService = StorageService();

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
    // printData("folder");
  }

  // Future<List> printData(String childName) async {
  //   // return await _storageService.get(childName);
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ImagesPreview(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AllImages(title: "קו אביטל 23"),
          ),
        );
      }, "קו אביטל 23"),
    );
  }
}

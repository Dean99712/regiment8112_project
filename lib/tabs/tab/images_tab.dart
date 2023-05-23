import 'package:flutter/material.dart';
import 'package:regiment8112_project/services/google_authentication.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({Key? key}) : super(key: key);

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         MaterialButton(
            onPressed: GoogleAuthentication().listOfPhotos, child: const Text("Press me")),
        Image.network(
            height: 150,
            width: 150,
            "https://phantom-marca.unidadeditorial.es/398a931cd2cfabea69c75746e9785c87/resize/1320/f/jpg/assets/multimedia/imagenes/2022/12/22/16717250934792.jpg")
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String title;
  final String imageUrl;

  Album({required this.title, required this.imageUrl});

  Album.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : title = snapshot['title'],
        imageUrl = snapshot['imageUrl'];

  // factory Album.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   // List<String> imageUrls = List.from(data['imageUrl']);
  //   return Album(
  //     title: data['title'],
  //     imageUrl: data['imageUrl'],
  //   );
  // }
  Map<String, dynamic> toJson() => {
        'title': title,
        'imageUrl': imageUrl,
      };
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String title;
  final String imageUrl;
  final Timestamp createdAt;

  Album({required this.title, required this.imageUrl, required this.createdAt});

  Album.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : title = snapshot['title'],
        imageUrl = snapshot['imageUrl'],
        createdAt = snapshot['createdAt'];

  // factory Album.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   // List<String> imageUrls = List.from(data['imageUrl']);
  //   return Album(
  //     title: data['title'],
  //     imageUrl: data['imageUrl'],
  //   );
  // }
  Map<String, dynamic> toJson() =>
      {'title': title, 'imageUrl': imageUrl, 'createdAt': createdAt};
}

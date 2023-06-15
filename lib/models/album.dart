import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String name;
  final List<String> imageUrl;

  Album({required this.name, required this.imageUrl});

  factory Album.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // List<String> imageUrls = List.from(data['imageUrl']);
    return Album(
      name: data['name'],
      imageUrl: data['imageUrl'],
    );
  }
}
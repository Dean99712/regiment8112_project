import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String id;
  final String title;
  final String imageUrl;
  final Timestamp createdAt;

  Album({required this.id, required this.title, required this.imageUrl, required this.createdAt});

  Album.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot['id'],
        title = snapshot['title'],
        imageUrl = snapshot['imageUrl'],
        createdAt = snapshot['createdAt'];

  Album.fromQuerySnapshot(QueryDocumentSnapshot<Object?> snapshot)
      : id = snapshot['id'],
        title = snapshot['title'],
        imageUrl = snapshot['imageUrl'],
        createdAt = snapshot['createdAt'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'imageUrl': imageUrl, 'createdAt': createdAt};
}

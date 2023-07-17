import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String id;
  final String title;
  final String imageUrl;
  final String hash;
  final Timestamp createdAt;

  Album(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.hash,
      required this.createdAt});

  Album.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot['id'],
        title = snapshot['title'],
        imageUrl = snapshot['imageUrl'],
        hash = snapshot['hash'],
        createdAt = snapshot['createdAt'];

  Album.fromQuerySnapshot(QueryDocumentSnapshot<Object?> snapshot)
      : id = snapshot['id'],
        title = snapshot['title'],
        imageUrl = snapshot['imageUrl'],
        hash = snapshot['hash'],
        createdAt = snapshot['createdAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'hash': hash,
        'createdAt': createdAt
      };
}

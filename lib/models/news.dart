import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  News(this.news, this.createdAt, this.id);

  final String id;
  final String news;
  final Timestamp createdAt;

  News.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        news = snapshot['news'],
        createdAt = snapshot['created_at'];
}

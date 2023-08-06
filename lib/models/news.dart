import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  News(this.news, this.createdAt);

  final String news;
  final Timestamp createdAt;

  News.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : news = snapshot['news'],
        createdAt = snapshot['created_at'];
}

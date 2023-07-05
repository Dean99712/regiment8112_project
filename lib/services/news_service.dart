import 'package:cloud_firestore/cloud_firestore.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllNews() async {
    return await _firestore
        .collection("news")
        .orderBy("created_at", descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUpdates() async {
    return await _firestore
        .collection("updates")
        .orderBy("created_at", descending: true)
        .get();
  }
}

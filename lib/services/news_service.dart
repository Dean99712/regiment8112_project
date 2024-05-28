import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regiment8112/models/news.dart';
import 'package:uuid/uuid.dart';

import '../models/updates.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllNews() async {
    return await _firestore
        .collection("news")
        .orderBy("created_at", descending: true)
        .get();
  }

  Stream<List<News>> streamNews() {
    return _firestore
        .collection('news')
        .orderBy("created_at", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => News.fromSnapshot(doc)).toList();
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUpdates() async {
    return await _firestore
        .collection("updates")
        .orderBy("created_at", descending: true)
        .get();
  }

  Stream<List<Updates>> streamUpdates() {
    return _firestore
        .collection('updates')
        .orderBy("created_at", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Updates.fromSnapshot(doc)).toList();
    });
  }

  Future addUpdate(String text) async {
    var collection = _firestore.collection("updates");
    final uuid = const Uuid().v4().replaceAll("-", "").substring(0, 20);
    final data = {"id": uuid, "update": text, "created_at": Timestamp.now()};
    return await collection.doc(uuid).set(data);
  }

  Future addNews(String text) async {
    var collection = _firestore.collection("news");
    final uuid = const Uuid().v4().replaceAll("-", "").substring(0, 20);
    final data = {"id": uuid, "news": text, "created_at": Timestamp.now()};
    return await collection.doc(uuid).set(data);
  }

  Future removeNews(String id) async {
    await FirebaseFirestore.instance.collection("news").doc(id).delete();
  }

  Future removeUpdate(String id) async {
    var collection = _firestore.collection("updates");
    return await collection.doc(id).delete();
  }

  Future editeNews(String id, String text) async {
    var collection = _firestore.collection("news");
    final data = {"news": text};
    return await collection.doc(id).update(data);
  }

  Future editUpdate(String id, String text) async {
    var collection = _firestore.collection("updates");
    final data = {"update": text};
    return await collection.doc(id).update(data);
  }

  Future getUpdateById(String id) async {
    var collection = _firestore.collection("updates");
    return await collection.doc(id).get();
  }

  Future getNewsById(String id) async {
    var collection = _firestore.collection("news");
    return await collection.doc(id).get();
  }
}



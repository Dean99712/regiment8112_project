import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regiment8112_project/models/user.dart';

String query = '';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SearchNotifier extends StateNotifier<String> {
  SearchNotifier() : super(query);

  Stream<List<MyUser>> updateQuery(String query) {
    var value = state = query;
    var collection = _firestore
        .collection("users")
        .where("name", isLessThan: '${value}ת')
        .where("name", isGreaterThanOrEqualTo: value)
        // .where('phoneNumber', isLessThan: '${value}ת')
        // .where('phoneNumber', isGreaterThanOrEqualTo: value)
        .snapshots();

    return collection
        .map((event) => event.docs.map((e) => MyUser.fromSnapshot(e)).toList());
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, String>((ref) {
  return SearchNotifier();
});

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regiment8112_project/models/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SearchNotifier extends StateNotifier<String> {
  SearchNotifier() : super('');

  Future updateQuery(String query) async {
    var value = state = query;
    var nameCollection = await _firestore
        .collection("users")
        .orderBy("name")
        .where("name", isLessThan: '${value}ת')
        .where("name", isGreaterThanOrEqualTo: value)
        .get();

    var phoneCollection = await _firestore
        .collection("users")
        .where('phoneNumber', isLessThan: '${value}ת')
        .where('phoneNumber', isGreaterThanOrEqualTo: value)
        .get();

    var lastNameCollection = await _firestore
        .collection("users")
        .where("lastName", isLessThan: '${value}ת')
        .where("lastName", isGreaterThanOrEqualTo: '$value')
        .get();

    var citiesCollection = await _firestore
        .collection("users")
        .where("city", isLessThan: '${value}ת')
        .where("city", isGreaterThanOrEqualTo: '$value')
        .get();

    if (nameCollection.docs.isNotEmpty) {
      return nameCollection.docs.map((doc) => MyUser.fromSnapshot(doc)).toList();
    } else if (phoneCollection.docs.isNotEmpty) {
      return phoneCollection.docs.map((doc) => MyUser.fromSnapshot(doc)).toList();
    } else if(lastNameCollection.docs.isNotEmpty){
      return lastNameCollection.docs.map((doc) => MyUser.fromSnapshot(doc)).toList();
    } else {
      return citiesCollection.docs.map((doc) => MyUser.fromSnapshot(doc)).toList();
    }
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, String>((ref) {
  return SearchNotifier();
});

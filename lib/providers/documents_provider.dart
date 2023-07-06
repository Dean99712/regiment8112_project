import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<String> documents = [];

class DocumentsNotifier extends StateNotifier<List<String>> {
  DocumentsNotifier() : super(documents);

  Future getDocuments(String chileName) async {
    var collection = await _firestore
        .collectionGroup("album")
        .orderBy("createdAt", descending: true)
        .where("title", isEqualTo: chileName)
        .get();

    var documents = collection.docs.map((doc) => doc.reference.id).toList();
    state = documents;
  }

  Future deleteDocument(String childName, int index) async {
    var snapshot = await _firestore
        .collection("albums")
        .doc(childName)
        .collection("album")
        .orderBy("createdAt")
        .get();

    var docs = snapshot.docs.map((event) => event.reference);
    for (var doc in docs) {
      if(await state[index] == doc.id) {
        await doc.delete();
        state.removeWhere((element) => element == doc.id);
        state = [...state];
      }
    }
    for(var item in state) {
      print(item);
    }
  }
}

final documentsProvider =
    StateNotifierProvider<DocumentsNotifier, List<String>>((ref) {
  return DocumentsNotifier();
});

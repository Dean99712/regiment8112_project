import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<String> documents = [];
class DocumentsNotifier extends StateNotifier<List<String>> {
  DocumentsNotifier() : super(documents);

  Future getDocuments(String chileName) async {
    await _firestore
        .collectionGroup("album")
        .orderBy("createdAt", descending: true)
        .where("title", isEqualTo: chileName)
        .get()
    // ignore: avoid_function_literals_in_foreach_calls
        .then((snapshot) => snapshot.docs.forEach((element) {
          final id = element.reference.id;
          state = [...state, id];
    }));
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
      if (state[index] == doc.id) {
        doc.delete();
        state.removeWhere((element) => element.contains(doc.id));
        state = [...state];
      }
    }
  }

}
final documentsProvider = StateNotifierProvider<DocumentsNotifier,List<String>>((ref) {
  return DocumentsNotifier();
});


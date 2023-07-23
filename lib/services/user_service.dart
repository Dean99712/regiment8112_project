import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:regiment8112_project/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addContact(String name, String lastName, String phoneNumber,
      String platoon, String city) async {

    String uid = _auth.currentUser!.uid;

    var collection = _firestore.collection("users");
    final data =
        MyUser(uid, name, lastName, phoneNumber, platoon, city, Role.user.name)
            .toJson();

    await collection.doc(uid).set(data);
  }

  Future<List<MyUser>> getContacts() async {
    final collection = await _firestore.collection("users").get();

    return collection.docs.map((doc) => MyUser.fromSnapshot(doc)).toList();
  }
}

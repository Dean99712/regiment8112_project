import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regiment8112_project/models/user.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addContact(String name, String lastName, String phoneNumber,
      String platoon, String city) async {

    String? userId = const Uuid().v1().substring(0, 8);

    var collection = _firestore.collection("users");
    final data = MyUser(
            userId, name, lastName, phoneNumber, platoon, city, Role.user.name)
        .toJson();

    await collection.add(data);
  }

  Stream<List<MyUser>> getContacts() {
    final collection = _firestore.collection("users").snapshots();

    var documents = collection.map((snapshot) =>
        snapshot.docs.map((doc) => MyUser.fromSnapshot(doc)).toList());
    return documents;
  }
}


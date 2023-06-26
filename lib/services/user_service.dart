import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:regiment8112_project/models/user.dart';

class UserService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addContact(String name, String lastName, String phoneNumber, String platoon, String city) async{
    String? userId;
    if(_auth.currentUser != null) {
      userId = _auth.currentUser!.uid;
    }
    var collection = _firestore.collection("users");
    final data = MyUser(userId!, name, lastName, phoneNumber,platoon,city,  Role.user.name).toJson();
    await collection.add(data);
  }
  
  CollectionReference<Map<String, dynamic>> getContacts() {
    return _firestore.collection("users");
  }
}
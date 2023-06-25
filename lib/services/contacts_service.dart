import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regiment8112_project/models/people.dart';

class ContactService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addContact(String name, String lastName, String phoneNumber, String platoon, String city) async{
    var collection = _firestore.collection("contacts");
    final data = People(name, lastName, phoneNumber, city, platoon).toJson();
    await collection.add(data);
  }
}
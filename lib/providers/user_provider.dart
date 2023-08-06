import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var _uid = _auth.currentUser!.uid;
bool isAdmin = false;

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UserNotifier extends StateNotifier<bool> {
  UserNotifier() : super(isAdmin);

  Future<bool> getUser() async {
    DocumentSnapshot user = await _firestore.collection("users").doc(_uid).get();
    if(user.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> authorizedAccess() async {
    final collection = await _firestore.collection("users").where("id", isEqualTo: _uid).get();
    if(collection.docs[0].exists) {
      if(collection.docs[0].data()["role"] == "admin") {
        state = true;
        return true;
      }else {
        state = false;
        return false;
      }
    }
    return false;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, bool>((ref) {
  return UserNotifier();
});

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var _uid = _auth.currentUser!.uid;

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UserNotifier extends StateNotifier<String> {
  UserNotifier() : super(_uid);

  Future<bool> getUser() async {
    DocumentSnapshot user = await _firestore.collection("users").doc(state).get();
    if(user.exists) {
      return true;
    } else {
      return false;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, String>((ref) {
  return UserNotifier();
});

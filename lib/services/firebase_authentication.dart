import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regiment8112_project/providers/user_provider.dart';
import 'package:regiment8112_project/screens/main_screen.dart';
import 'package:regiment8112_project/widgets/add_contact.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyOtp(BuildContext context, String otp,
      String verificationCode, WidgetRef ref) async {
    try {
      PhoneAuthCredential credentials = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: otp);
      await _auth.signInWithCredential(credentials);

      ref.watch(userProvider.notifier).getUser().then((value) {
        if(value == true) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => const AddContact()), (
                  route) => false);
        }
      });

    } on FirebaseAuthException catch (e) {
      print(e.message);
      print("ERROR");
    }
  }
}

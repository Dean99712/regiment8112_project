import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    try {
      PhoneAuthCredential credentials = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: otp);
      await _auth.signInWithCredential(credentials);
      if(otp.isNotEmpty) {
        ref.watch(userProvider.notifier).getUser().then((value) {
          if (value == true) {
            Navigator.pushReplacement(
                context,
                isIos
                    ? CupertinoPageRoute(
                    fullscreenDialog: false,
                    builder: (context) =>
                        CupertinoScaffold(body: const MainScreen()))
                    : MaterialWithModalsPageRoute(
                    builder: (context) => const MainScreen()));
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialWithModalsPageRoute(
                    builder: (context) =>
                        CupertinoScaffold(body: const AddContact())),
                    (route) => false);
          }
        });
      } else {
        final snackBar = SnackBar(content: Text("סתם בדיקה"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}

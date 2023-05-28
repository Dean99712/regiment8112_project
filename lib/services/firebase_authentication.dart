import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async{
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e);
    }
  }

  void authenticateUser() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+972537307253',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    await _auth.verifyPhoneNumber(
      phoneNumber: '+972537307253',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException error) {},
      codeSent: (String verificationId, int? forceResendingToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}

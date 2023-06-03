import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationCode = '';

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> verifyOtp(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationCode, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  Future<void> authenticateUser(String phoneNumber) async {
    var phoneNum = phoneNumber.substring(1);
    print('phone number : $phoneNum');
    await _auth.verifyPhoneNumber(
      phoneNumber: '+972$phoneNum',
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('Error, invalid code');
        }
      },
      codeSent: (verificationId, int? resendToken) {
        verificationId = verificationCode;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationCode;
      },
    );
  }
}

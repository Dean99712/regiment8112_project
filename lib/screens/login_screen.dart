import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/screens/main_screen.dart';
import 'package:regiment8112_project/screens/otp_screen.dart';
import 'package:regiment8112_project/widgets/custom_button.dart';
import 'package:regiment8112_project/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final controller = TextEditingController();

class _LoginPageState extends State<LoginPage> {

  String smsCode = '';
  String verificationCode = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phone = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> authenticateUser(String phoneNumber) async {
    var phone = phoneNumber.substring(1);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+972$phone',
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('Error, invalid code');
        }
      },
      codeSent: (verificationId, int? resendToken) {
        verificationCode = verificationId;
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(verificationId:verificationCode, smsCode: smsCode,)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationCode;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.all(60),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: 0.12,
                  image: AssetImage("assets/images/Group 126.png"),
                  fit: BoxFit.cover),
              gradient: RadialGradient(radius: 0.91, colors: [
                Color.fromRGBO(121, 121, 121, 1),
                Color.fromRGBO(60, 58, 59, 1),
              ])),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/svg/logo.png", height: 210, width: 210),
                Text(
                  'חרמ"ש מסייעת',
                  style: GoogleFonts.rubikDirt(
                      fontSize: 32,
                      color: const Color.fromRGBO(86, 154, 82, 1)),
                ),
                Text(
                  "8112",
                  style: GoogleFonts.rubikDirt(
                      fontSize: 90,
                      color: const Color.fromRGBO(86, 154, 82, 1)),
                ),
                CustomTextField(type: TextInputType.phone, controller: null, text: "מספר טלפון", onChanged: (value) {
                  phone = value;
                }),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomButton(
                      text: "לקבלת קוד חד פעמי",
                      function: () async {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen(),));
                        // authenticateUser(phone);
                      }),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 24),
                  child: SizedBox(
                    height: 70,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "לא מצליחים להתחבר?",
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.heebo(
                                color: const Color.fromRGBO(190, 190, 190, 1),
                                fontSize: 12),
                          ),
                          Text(
                            "תפנו לעזרה בקבוצת הוואטסאפ",
                            style: GoogleFonts.heebo(
                                color: const Color.fromRGBO(190, 190, 190, 1),
                                fontSize: 12),
                          ),
                          const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Color.fromRGBO(190, 190, 190, 1),
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

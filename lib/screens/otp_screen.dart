import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/screens/main_screen.dart';
import 'package:regiment8112_project/services/firebase_authentication.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_button.dart';
import 'package:regiment8112_project/widgets/custom_text_field.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {required this.smsCode, required this.verificationId, super.key});

  final String smsCode;
  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String smsCode = '';
  String verificationId = '';

  @override
  void initState() {
    verificationId = widget.verificationId;
    super.initState();
  }

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                greyShade700,
              ])),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/svg/logo.png", height: 210, width: 210),
                Text(
                  'לאימות הקוד',
                  style:
                      GoogleFonts.rubikDirt(fontSize: 32, color: primaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CustomTextField(
                      maxLength: 6,
                      controller: null,
                      text: "מספר טלפון",
                      onChanged: (value) {
                        smsCode = value;
                      }),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomButton(
                      text: "כניסה",
                      color: secondaryColor,
                      function: () async {
                        try {
                          await _authService
                              .verifyOtp(smsCode, verificationId)
                              .whenComplete(() => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
                                  (route) => false));
                        } catch (e) {
                          print('$e wrong otp');
                        }
                      },
                    )),
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
    );
  }
}

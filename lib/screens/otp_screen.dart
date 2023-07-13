import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:regiment8112_project/services/firebase_authentication.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen(
      {required this.smsCode,
      required this.verificationId,
      required this.phoneNumber,
      super.key});

  final String smsCode;
  final String verificationId;
  final String phoneNumber;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String smsCode = '';
  String verificationId = '';

  @override
  void initState() {
    verificationId = widget.verificationId;
    super.initState();
  }

  final AuthService _authService = AuthService();

  Future verifyOtp(BuildContext context, String smsCode) async {
    _authService.verifyOtp(
      context,
      smsCode,
      verificationId,
      ref
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final phone = widget.phoneNumber.substring(6);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: isDark ? 0.12 : 0.5,
                  image: AssetImage("assets/images/Group 126.png"),
                  fit: BoxFit.cover),
              gradient: RadialGradient(
                  radius: 1,
                  colors: isDark
                      ? [
                          greyShade400,
                          greyShade700,
                        ]
                      : [white, greyShade400])),
          child: Padding(
            padding: const EdgeInsets.only(top: 75.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/svg/logo.png", height: 210, width: 210),
                  Text(
                    'כניסה עם קוד חד פעמי ב-SMS',
                    style: GoogleFonts.rubikDirt(
                        fontSize: 24, color: primaryColor),
                  ),
                  CustomText(
                    text: 'שלחנו לך קוד לנייד שמסתיים ב-$phone',
                    color: primaryColor,
                    fontSize: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              defaultPinTheme: PinTheme(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: greyShade100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  textStyle: TextStyle(fontSize: 18)),
                              onChanged: (value) {
                                smsCode = value;
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  smsCode = value;
                                });
                              },
                              length: 6,
                              autofocus: true,
                            ),
                          ),
                        ),
                        CustomButton(
                          text: "כניסה",
                          color: secondaryColor,
                          function: () {
                            verifyOtp(context, smsCode);
                          },
                          width:
                              size.width < 380 ? size.width : size.width / 1.5,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    child: SizedBox(
                      height: 70,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "לא הקוד שקיבלת?",
                              color: isDark
                                  ? greyShade200
                                  : colorScheme.onBackground,
                              fontSize: 12,
                            ),
                            Text(
                              "תפנו לעזרה בקבוצת הוואטסאפ",
                              style: GoogleFonts.heebo(
                                  color: isDark
                                      ? greyShade200
                                      : colorScheme.onBackground,
                                  fontSize: 12),
                            ),
                            Icon(
                              FontAwesomeIcons.whatsapp,
                              color: isDark
                                  ? greyShade200
                                  : colorScheme.onBackground,
                            )
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
/*    return Scaffold(
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
    );*/
  }
}

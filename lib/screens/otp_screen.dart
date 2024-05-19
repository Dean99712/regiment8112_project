import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:regiment8112/utils/focus_scope_handler.dart';
import '../services/firebase_authentication.dart';
import '../utils/colors.dart';
import '../utils/ebutton_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen(
      {required this.smsCode,
      required this.verificationId,
      required this.phoneNumber,
      // required this.resendToken,
      super.key});

  final String smsCode;
  final String verificationId;
  final String phoneNumber;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  ButtonState state = ButtonState.init;
  String smsCode = '';
  String verificationId = '';
  FocusNode focus = FocusNode();

  @override
  void initState() {
    verificationId = widget.verificationId;
    super.initState();
  }

  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  void resendCode() async {
    var phone = widget.phoneNumber.substring(1,);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+972$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        setState(() => state = ButtonState.init);
        throw FirebaseAuthException(
            code: 'Message : ${e.message!} $verificationId $smsCode');
      },
      codeAutoRetrievalTimeout: (String verificationCode) {
        verificationId = verificationCode;
      }, codeSent: (String verificationId, int? forceResendingToken) {  },
    );
  }

  void onError() {
    var colorScheme = Theme.of(context).colorScheme;
    setState(() => state = ButtonState.init);
    if (smsCode.isEmpty) {
      final snackBar = SnackBar(
        content: CustomText(
          text: "קוד אינו יכול להישאר ריק!",
          fontWeight: FontWeight.w400,
          fontSize: 14,
          textAlign: TextAlign.right,
          color: colorScheme.surface,
        ),
        backgroundColor: colorScheme.onSurface,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (!verificationId.contains(smsCode)) {
      final snackBar = SnackBar(
        content: CustomText(
          text: "קוד שגוי, אנא נסה שנית",
          fontWeight: FontWeight.w400,
          fontSize: 14,
          textAlign: TextAlign.right,
          color: colorScheme.surface,
        ),
        backgroundColor: colorScheme.onSurface,
        action: SnackBarAction(label: "דחה", onPressed: () {}),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
      FocusScope.of(context).requestFocus(focus);
  }

  Future verifyOtp(BuildContext context, String smsCode) async {
    _authService.verifyOtp(context, smsCode, verificationId, onError, ref);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String value, String emptyText, String text) {
    const snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // void startTimer() {
  //   const onSec = Duration(seconds: 1);
  //   Timer timer = Timer.periodic(onSec, (timer) {});
  //   print("Resend Token ${widget.resendToken}");
  // }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final phone = widget.phoneNumber.substring(6);
    FocusScopeNode focusScope = FocusScope.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () => handleFocusScopeNode(context, focusScope),
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: isDark ? 0.12 : 0.5,
                    image: const AssetImage("assets/images/Group 126.png"),
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
                    Hero(
                        tag: "logo",
                        child: Image.asset("assets/svg/logo.png",
                            height: 210, width: 210)),
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
                                focusNode: focus,
                                androidSmsAutofillMethod:
                                    AndroidSmsAutofillMethod.smsRetrieverApi,
                                keyboardType: TextInputType.number,
                                errorPinTheme: PinTheme(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorScheme.error),
                                    color: isDark ? greyShade400 : greyShade100,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  textStyle: const TextStyle(
                                      fontSize: 18, color: greyShade700),
                                ),
                                defaultPinTheme: const PinTheme(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: greyShade100,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    textStyle: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                                onChanged: (value) async {
                                  smsCode = value;
                                  if(smsCode.length == 6) {
                                    setState(() => state = ButtonState.loading);
                                    await verifyOtp(context, smsCode);
                                  }
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
                            state: state,
                            text: "כניסה",
                            color: secondaryColor,
                            function: () async {
                              setState(() => state = ButtonState.loading);
                              await verifyOtp(context, smsCode);
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
                        height: 91,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CustomText(
                                    text: "לא הקוד שקיבלת?",
                                    color: isDark
                                        ? greyShade200
                                        : colorScheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    child: CustomText(
                                      text: "שלחו לי SMS נוסף",
                                      color: isDark
                                          ? greyShade200
                                          : colorScheme.onSurface,
                                      fontSize: 12,
                                    ),
                                    onTap: () {
                                      print(verificationId);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "תפנו לעזרה בקבוצת הוואטסאפ",
                                style: GoogleFonts.heebo(
                                    color: isDark
                                        ? greyShade200
                                        : colorScheme.onSurface,
                                    fontSize: 12),
                              ),
                              Icon(
                                FontAwesomeIcons.whatsapp,
                                color: isDark
                                    ? greyShade200
                                    : colorScheme.onSurface,
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
      ),
    );
  }
}

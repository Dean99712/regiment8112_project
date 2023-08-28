import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/providers/validatorProvider.dart';
import 'package:regiment8112_project/screens/otp_screen.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/utils/ebutton_state.dart';
import 'package:regiment8112_project/utils/validators.dart';
import 'package:regiment8112_project/widgets/custom_button.dart';
import 'package:regiment8112_project/widgets/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

final controller = TextEditingController();

class _LoginPageState extends ConsumerState<LoginPage> {
  ButtonState state = ButtonState.init;
  String smsCode = '';
  String verificationCode = '';
  int? _resendToken;
  String phone = '';
  final _formState = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> authenticateUser(String phoneNumber) async {
    var phone = phoneNumber.substring(1);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+972$phone',
      timeout: Duration(seconds: 60),
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
          setState(() => state = ButtonState.init);
        throw FirebaseAuthException(
            code: 'Message : ${e.message!} $verificationCode $smsCode');
      },
      codeSent: (verificationId, int? resendToken) {
          verificationCode = verificationId;
         _resendToken = resendToken;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
                verificationId: verificationId,
                smsCode: smsCode,
                phoneNumber: phoneNumber,
                resendToken: _resendToken!),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationCode;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final validateProvider = ref.watch(validatorProvider.notifier);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/svg/logo.png", height: 210, width: 210),
              Text(
                'חרמ"ש מסייעת',
                style: GoogleFonts.rubikDirt(fontSize: 32, color: primaryColor),
              ),
              Text(
                "8112",
                style: GoogleFonts.rubikDirt(fontSize: 90, color: primaryColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formState,
                      child: CustomTextField(
                          type: TextInputType.phone,
                          controller: null,
                          text: "מספר טלפון",
                          validator: (value) {
                            return validateProvider.validator(
                                value!,
                                "מספר טלפון אינו יכול להיות ריק",
                                "מספר טלפון אינו תקין",
                                phoneValidator);
                          },
                          onChanged: (value) {
                            phone = value;
                          }),
                    ),
                    CustomButton(
                      state: state,
                      text: "לקבלת קוד חד פעמי",
                      function: () async {
                        if (_formState.currentState!.validate()) {
                          setState(() => state = ButtonState.loading);
                          await authenticateUser(phone);
                        }
                      },
                      width: size.width < 380 ? size.width : size.width / 1.5,
                    ),
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
                        Text(
                          "לא מצליחים להתחבר?",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.heebo(
                              color: isDark
                                  ? greyShade200
                                  : colorScheme.onBackground,
                              fontSize: 12),
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
                          color:
                              isDark ? greyShade200 : colorScheme.onBackground,
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

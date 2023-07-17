import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:regiment8112_project/services/firebase_authentication.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_button.dart';
import '../providers/validatorProvider.dart';
import '../utils/ebutton_state.dart';
import '../utils/validators.dart';
import '../widgets/custom_text.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({required this.smsCode,
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

  ButtonState state = ButtonState.init;

  String smsCode = '';
  String verificationId = '';

  @override
  void initState() {
    verificationId = widget.verificationId;
    super.initState();
  }

  final AuthService _authService = AuthService();

  Future verifyOtp(BuildContext context, String smsCode) async {
    _authService.verifyOtp(context, smsCode, verificationId, ref);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    final size = MediaQuery
        .of(context)
        .size;
    final phone = widget.phoneNumber.substring(6);
    final validateProvider = ref.watch(validatorProvider.notifier);

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
                              validator: (value) {
                               return validateProvider.validator(value!, "navu mavu asf", "navu mavu asf", smsValidator);
                              },
                              androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
                              keyboardType: TextInputType.number,
                              errorPinTheme: PinTheme(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: colorScheme.error),
                                    color: isDark ? greyShade400 : greyShade100,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      color: colorScheme.onBackground)),
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
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage(this.start, {Key? key}) : super(key: key);

  final void Function() start;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.all(60),
          width: w,
          height: h,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: 0.12,
                  image: AssetImage("assets/images/Group 126.png"),
                  fit: BoxFit.cover),
              gradient: RadialGradient(radius: 0.9, colors: [
                Color.fromRGBO(121, 121, 121, 1),
                Color.fromRGBO(60, 58, 59, 1),
              ])),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/svg/logo.png", height: 210, width: 210),
              Text(
                'חרמ"ש מסייעת',
                style: GoogleFonts.rubikDirt(
                    fontSize: 32, color: const Color.fromRGBO(86, 154, 82, 1)),
              ),
              Text(
                "8112",
                style: GoogleFonts.rubikDirt(
                    fontSize: 90, color: const Color.fromRGBO(86, 154, 82, 1)),
              ),
              const Directionality(
                textDirection: TextDirection.rtl,
                child:  TextField(
                  enableSuggestions: false,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    label: Text("מספר טלפון", textDirection: TextDirection.ltr),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              MaterialButton(
                  color: const Color.fromRGBO(86, 154, 82, 1),
                  onPressed: start,
                  child: Text(
                    "לקבלת קוד חד פעמי",
                    style: GoogleFonts.heebo(color: Colors.white),
                  )),
              Container(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

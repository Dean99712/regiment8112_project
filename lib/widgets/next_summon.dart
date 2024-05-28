import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';

class NextSummon extends StatefulWidget {
  const NextSummon({super.key});

  @override
  State<NextSummon> createState() => _NextSummonState();
}

class _NextSummonState extends State<NextSummon> {
  Future<List<String>>? recruitDatesFuture;
  final firestore = FirebaseFirestore.instance;

  Future<List<String>> getRecruitDates() async {
    List<String> formattedDates = [];

    await FirebaseFirestore.instance
        .collection("recruit date")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var dates = element.get('תאריכי זימון') as List<dynamic>;
        dates.forEach((timestamp) {
          DateTime dateTime = (timestamp as Timestamp).toDate();
          String formattedDate = DateFormat('dd.MM').format(dateTime);
          formattedDates.add(formattedDate);
        });
      });
    });

    return formattedDates;
  }

  @override
  void initState() {
    recruitDatesFuture = getRecruitDates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 85,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  opacity: 0.20,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(0, 0, 0, 0.10), BlendMode.multiply),
                  image: AssetImage("assets/images/Group 126.png"),
                  fit: BoxFit.cover),
              color: isDark ? brownShade300 : secondaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "הזימון הבא",
                    style: GoogleFonts.heebo(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600),
                  ),
                  FutureBuilder(
                    future: recruitDatesFuture,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: isIos ? CupertinoActivityIndicator(color: colorScheme.onSurface) : const CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('אין תאריך זימון קרוב', style: GoogleFonts.rubikDirt(fontSize: 20)));
                      } else {
                        List<String> recruitDates = snapshot.data!;
                        return Text(
                          recruitDates.join(' - '),
                          style: GoogleFonts.rubikDirt(
                              color: colorScheme.onSurface, fontSize: 24),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -17,
          left: -10,
          child: SvgPicture.asset(
            'assets/svg/Artwork 3.svg',
            width: 60,
            height: 65,
          ),
        )
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/data/plattons.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

int _selectedValue = 1;

class _AddContactState extends State<AddContact> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    final size = MediaQuery.of(context).size;
    return PlatformApp(
        material: (_, __) => MaterialAppData(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Container(
                  height: size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        opacity: 0.12,
                        image: AssetImage("assets/images/Group 126.png"),
                        fit: BoxFit.cover),
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.1,
                      colors: [
                        Color.fromRGBO(60, 58, 59, 1),
                        Color.fromRGBO(60, 58, 59, 1)
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 50.0),
                    child: SingleChildScrollView(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/svg/logo.png',
                                  width: 97,
                                  height: 97,
                                )
                              ],
                            ),
                            Text("הוסף איש קשר",
                                style: GoogleFonts.rubikDirt(
                                    fontSize: 32, color: primaryColor)),
                            SizedBox(
                              height: size.height / 1.6,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextField(
                                    style: const TextStyle(color: white),
                                    controller: controller,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'שם פרטי',
                                        disabledBorder: InputBorder.none,
                                        filled: true,
                                        fillColor: white),
                                  ),
                                  TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'שם משפחה',
                                        filled: true,
                                        fillColor: white),
                                  ),
                                  TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'עיר מגורים',
                                        filled: true,
                                        fillColor: white),
                                  ),
                                  TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        labelText: 'מחלקה',
                                        fillColor: white),
                                  ),
                                  TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        labelText: 'מספר טלפון',
                                        fillColor: white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 52,
                              width: size.width / 2.2,
                              child: ElevatedButton.icon(
                                label: const CustomText(
                                  fontSize: 16,
                                  color: white,
                                  text: "הוסף",
                                ),
                                icon: const Icon(Icons.add_outlined),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        primaryColor)),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        cupertino: (_, __) => CupertinoAppData(
              home: PlatformScaffold(
                cupertino: (_, __) => CupertinoPageScaffoldData(
                  body: Center(
                    child: Container(
                      color: backgroundColor,
                      child: CupertinoFormSection(children: [
                        CupertinoTextField(
                          textDirection: TextDirection.rtl,
                          placeholder: "שם פרטי",
                          placeholderStyle:
                              GoogleFonts.heebo(color: primaryColor),
                        ),
                        CupertinoTextField(
                          textDirection: TextDirection.rtl,
                          placeholder: "שם משפחה",
                          placeholderStyle:
                              GoogleFonts.heebo(color: primaryColor),
                        ),
                        CupertinoTextField(
                          textDirection: TextDirection.rtl,
                          placeholder: "עיר מגורים",
                          placeholderStyle:
                              GoogleFonts.heebo(color: primaryColor),
                        ),
                        CupertinoTextField(
                          textDirection: TextDirection.rtl,
                          placeholder: "מספר טלפון",
                          placeholderStyle:
                              GoogleFonts.heebo(color: primaryColor),
                        ),
                        CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                              initialItem: _selectedValue),
                          looping: false,
                          itemExtent: 30,
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedValue = value;
                            });
                          },
                          children: [
                            for (String name in platoon) Center(child: Text(name)),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ));
  }
}

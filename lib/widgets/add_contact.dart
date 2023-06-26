import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/data/plattons.dart';
import 'package:regiment8112_project/services/user_service.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';
import 'package:regiment8112_project/widgets/custom_text_field.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

final UserService _service = UserService();

int _selectedValue = 1;

class _AddContactState extends State<AddContact> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
  }

  void createUser() {
    _service.addContact(_nameController.text, _lastNameController.text,
        _phoneController.text, _cityController.text, platoon[_selectedValue]);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                              height: size.height / 2.5,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomTextField(controller: _nameController, text: "שם פרטי", maxLength: null, width: 170,),
                                      CustomTextField(controller: _lastNameController, text: "שם משפחה", maxLength: null,width: 175,),
                                    ],
                                  ),
                                  CustomTextField(controller: _cityController, text: "עיר מגורים", maxLength: null,),
                                  CustomTextField(controller: _phoneController, text: "מספר טלפון"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 52,
                              width: size.width / 2.2,
                              child: ElevatedButton.icon(
                                label: const CustomText(
                                  fontSize: 16,
                                  text: "הוסף",
                                  color: white,
                                ),
                                icon: const Icon(Icons.add_outlined),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        primaryColor)),
                                onPressed: () {
                                  createUser();
                                },
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
                          textInputAction: TextInputAction.next,
                          controller: _nameController,
                          textDirection: TextDirection.rtl,
                          placeholder: "שם פרטי",
                          placeholderStyle:
                              GoogleFonts.heebo(color: primaryColor),
                        ),
                        CupertinoTextField(
                          controller: _lastNameController,
                          textDirection: TextDirection.rtl,
                          placeholder: "שם משפחה",
                          placeholderStyle:
                              GoogleFonts.heebo(color: primaryColor),
                        ),
                        CupertinoTextField(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: primaryColor
                            )
                          ),
                          textDirection: TextDirection.rtl,
                          controller: _cityController,
                          placeholder: "עיר מגורים",
                          placeholderStyle:
                              GoogleFonts.heebo(color: primaryColor),
                        ),
                        CupertinoTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
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
                              platoon[value];
                              _selectedValue = value;
                            });
                          },
                          children: [
                            for (String name in platoon)
                              Center(child: Text(name)),
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

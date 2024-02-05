import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../data/plattons.dart';
import '../providers/user_provider.dart';
import '../providers/validatorProvider.dart';
import '../screens/main_screen.dart';
import '../services/user_service.dart';
import '../utils/colors.dart';
import '../utils/validators.dart';
import 'custom_text.dart';
import 'custom_text_field.dart';

class AddContact extends ConsumerStatefulWidget {
  const AddContact({super.key});

  @override
  ConsumerState<AddContact> createState() => _AddContactState();
}

final UserService _service = UserService();

class _AddContactState extends ConsumerState<AddContact> {
  String? _selectedVal = 'מחלקה 1';
  int _selectedValue = -1;
  bool isError = false;

  final _formField = GlobalKey<FormState>();
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

  void createUserCupertino(TargetPlatform platform) {
    if (_formField.currentState!.validate()) {
      ref.watch(userProvider.notifier).getUser().then((value) {
        if (value == true) {
        } else {
          _service.addContact(
              _nameController.text.trim(),
              _lastNameController.text.trim(),
              _phoneController.text.trim(),
              _cityController.text.trim(),
              platoon[_selectedValue]);
          Navigator.pushReplacement(
              context,
              platform == TargetPlatform.iOS
                  ? CupertinoPageRoute(
                      builder: (context) =>
                          const CupertinoScaffold(body: MainScreen()))
                  : MaterialWithModalsPageRoute(
                      builder: (context) => const MainScreen()));
        }
      });
    }
  }

  void createUserMaterial(TargetPlatform platform) {
    if (_formField.currentState!.validate()) {
      ref.watch(userProvider.notifier).getUser().then((value) {
        if (value == true) {
        } else {
          _service.addContact(
              _nameController.text.trim(),
              _lastNameController.text.trim(),
              _phoneController.text.trim(),
              _cityController.text.trim(),
              _selectedVal!);
          Navigator.pushReplacement(context,
              platform == TargetPlatform.iOS
                  ? CupertinoPageRoute(
                  builder: (context) =>
                      const CupertinoScaffold(body: MainScreen()))
                  : MaterialWithModalsPageRoute(
                  builder: (context) => const MainScreen()));
        }
      });
    }
  }

  Widget container(List<Widget> child) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final platform = Theme.of(context).platform;

    return Material(
      child: Form(
        key: _formField,
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  opacity: 0.12,
                  image: AssetImage("assets/images/Group 126.png"),
                  fit: BoxFit.cover),
              color: colorScheme.background),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
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
                    Text("הירשם על מנת להמשיך",
                        style: GoogleFonts.rubikDirt(
                            fontSize: 32, color: colorScheme.primary)),
                    const CustomText(
                        text:
                            "בצע רישום חד פעמי ולאחר מכן תוכל להמשיך לאפליקציה",
                        fontSize: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: child,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SizedBox(
                        height: 56,
                        width: size.width / 2,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.adaptive.arrow_back, color: colorScheme.background,),
                            label: CustomText(
                              fontSize: 16,
                              text: "המשך לאפליקציה",
                              color: colorScheme.background,
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    isDark ? primaryColor : secondaryColor)),
                            onPressed: () {
                              if (Theme.of(context).platform ==
                                  TargetPlatform.iOS) {
                                createUserCupertino(platform);
                              } else {
                                createUserMaterial(platform);
                              }
                            },
                          ),
                        ),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var validateProvider = ref.watch(validatorProvider.notifier);

    return PlatformScaffold(
      material: (_, __) => MaterialScaffoldData(
          body: container([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              controller: _nameController,
              text: "שם פרטי",
              maxLength: null,
              width: size.width * 0.42,
              textInputAction: TextInputAction.next,
              validator: (value) {
                return validateProvider.validator(
                    value!,
                    "שם אינו יכול להיות ריק!",
                    "השם שהוזן אינו תקין!",
                    nameValidator);
              },
            ),
            CustomTextField(
                controller: _lastNameController,
                text: "שם משפחה",
                maxLength: null,
                width: size.width * 0.42,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return validateProvider.validator(
                      value!,
                      "שם משפחה אינו יכול להיות ריק!",
                      "שם המשפחה שהוזן אינו תקין!",
                      nameValidator);
                }),
          ],
        ),
        CustomTextField(
          controller: _cityController,
          text: "עיר מגורים",
          maxLength: null,
          textInputAction: TextInputAction.next,
        ),
        CustomTextField(
          controller: _phoneController,
          text: "מספר טלפון",
          textInputAction: TextInputAction.done,
          type: TextInputType.phone,
          validator: (value) {
            return validateProvider.validator(value!, "אנא מלא מספר טלפון",
                "נא הקש מספר טלפון תקין!", phoneValidator);
          },
        ),
        SizedBox(
          width: double.infinity,
          child: pickerMaterial(),
        )
      ])),
      cupertino: (_, __) => CupertinoPageScaffoldData(
        body: container(
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return validateProvider.validator(
                          value!,
                          "שם אינו יכול להיות ריק!",
                          "שם שהוזן אינו תקין!",
                          nameValidator);
                    },
                    controller: _nameController,
                    text: "שם פרטי",
                    width: size.width / 2.4),
                CustomTextField(
                    validator: (value) {
                      return validateProvider.validator(
                          value!,
                          "שם משפחה אינו יכול להיות ריק!",
                          "שם המשפחה שהוזן אינו תקין!",
                          nameValidator);
                    },
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    text: "שם משפחה",
                    width: size.width / 2.4),
              ],
            ),
            CustomTextField(
              controller: _phoneController,
              textInputAction: TextInputAction.next,
              text: "מספר טלפון",
              type: TextInputType.phone,
              validator: (value) {
                return validateProvider.validator(value!, "אנא מלא מספר טלפון",
                    "נא הקש מספר טלפון תקין!", phoneValidator);
              },
            ),
            CustomTextField(controller: _cityController, text: "עיר מגורים"),
            CustomTextField(
              controller: null,
              textInputAction: TextInputAction.next,
              text:
                  _selectedValue == -1 ? 'בחר מחלקה' : platoon[_selectedValue],
              readOnly: true,
              prefix: GestureDetector(
                child: const Icon(
                  CupertinoIcons.chevron_down,
                  color: primaryColor,
                ),
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => Container(child: pickerCupertino()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pickerMaterial() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<String>(
        value: _selectedVal,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelText: "בחר מחלקה",
            filled: true,
            fillColor: isDark ? white.withOpacity(0.1) : greyShade100),
        hint: const CustomText(text: "בחר מחלקה", fontSize: 16),
        alignment: Alignment.center,
        items: platoon
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: CustomText(text: item, fontSize: 16),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedVal = value;
          });
        });
  }

  Widget pickerCupertino() {
    return CupertinoActionSheet(
      cancelButton: CupertinoButton(
        child: const Text("ביטול"),
        onPressed: () {
          setState(() {
            _selectedValue = -1;
          });
          Navigator.pop(context);
        },
      ),
      actions: [
        SizedBox(
          height: 300,
          child: CupertinoPicker(
            magnification: 1.2,
            scrollController:
                FixedExtentScrollController(initialItem: _selectedValue),
            looping: true,
            itemExtent: 50,
            onSelectedItemChanged: (int value) {
              setState(() {
                platoon[value];
                _selectedValue = value;
              });
            },
            children: [
              for (String name in platoon) Center(child: Text(name)),
            ],
          ),
        )
      ],
    );
  }
}

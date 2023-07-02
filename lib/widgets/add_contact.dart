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

class _AddContactState extends State<AddContact> {
  String? _selectedVal = 'מחלקה 1';
  int _selectedValue = -1;

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

  void createUserCupertino() {
    _service.addContact(
        _nameController.text.trim(),
        _lastNameController.text.trim(),
        _phoneController.text.trim(),
        _cityController.text.trim(),
        platoon[_selectedValue]);
    Navigator.pop(context);
  }

  void createUserMaterial() {
    _service.addContact(
        _nameController.text.trim(),
        _lastNameController.text.trim(),
        _phoneController.text.trim(),
        _cityController.text.trim(),
        _selectedVal!);
    Navigator.pop(context);
  }

  Widget container(List<Widget> child) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              opacity: 0.22,
              image: AssetImage("assets/images/Group 126.png"),
              fit: BoxFit.cover),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.1,
            colors: [backgroundColor, backgroundColor],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
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
                          fontSize: 36, color: primaryColor)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: size.height / 2.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: child,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
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
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor)),
                        onPressed: () {
                          if (Theme.of(context).platform == TargetPlatform.iOS) {
                            createUserCupertino();
                          } else {
                            createUserMaterial();
                          }
                        },
                      ),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              width: 170,
              textInputAction: TextInputAction.next,
            ),
            CustomTextField(
              controller: _lastNameController,
              text: "שם משפחה",
              maxLength: null,
              width: 175,
              textInputAction: TextInputAction.next,
            ),
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
        ),
        SizedBox(
          width: double.infinity,
          child: pickerMaterial(),
        )
      ])),
      cupertino: (_, __) => CupertinoPageScaffoldData(
          body: container([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(controller: _nameController, text: "שם פרטי", width: size.width / 2.4),
            CustomTextField(controller: _lastNameController, text: "שם משפחה", width: size.width / 2.4),
          ],
        ),
        CustomTextField(
          controller: _phoneController,
          text: "מספר טלפון",
          type: TextInputType.phone,
        ),
        CustomTextField(controller: _cityController, text: "עיר מגורים"),
        CustomTextField(
          controller: null,
          text: _selectedValue == -1 ? 'בחר מחלקה' : platoon[_selectedValue],
          readOnly: true,
          prefix: CupertinoButton(
            child: const Icon(CupertinoIcons.chevron_down, color: primaryColor,),
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => pickerCupertino(),
              );
            },
          ),
        ),
      ])),
    );
  }

  Widget pickerMaterial() {
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
            fillColor: white.withOpacity(0.1)),
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

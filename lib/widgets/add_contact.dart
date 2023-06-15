import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/custom_text.dart';

class AddContact extends StatelessWidget {
  const AddContact({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    final size = MediaQuery.of(context).size;

    return PlatformApp(
      material: (_, __) => MaterialAppData(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            height: double.infinity,
            color: backgroundColor,
            child: SingleChildScrollView(
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
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SizedBox(
                      height: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextField(
                            style: const TextStyle(color: white),
                            controller: controller,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'בן אנוש',
                                fillColor: white),
                          ),
                          TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'בן אנוש',
                                fillColor: white),
                          ),
                          TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'בן אנוש',
                                fillColor: white),
                          ),
                          TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'בן אנוש',
                                fillColor: white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 2,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primaryColor)
                      ),
                        onPressed: () {},
                        child: const CustomText(
                          fontSize: 16,
                          color: white,
                          text: "הוסף איש קשר",
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      cupertino: (_, __) => CupertinoAppData(home: Container()),
    );
  }
}

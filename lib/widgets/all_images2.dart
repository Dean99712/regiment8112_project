import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AllImages2 extends StatefulWidget {
  const AllImages2({required this.title, super.key});

  final String title;

  @override
  State<AllImages2> createState() => _AllImages2State();
}

class _AllImages2State extends State<AllImages2> {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      cupertino: (_, __) => CupertinoAppData(
        home: CupertinoPageScaffold(
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    CupertinoSliverNavigationBar(
                      largeTitle: Text(widget.title),
                      leading: CupertinoButton(
                        child: const Icon(
                            CupertinoIcons.person_crop_circle_badge_plus),
                        onPressed: () {},
                      ),
                    )
                  ],
              body: Container()),
        ),
      ),
      material: (_, __) => MaterialAppData(
        home: Scaffold(
          body: Container(),
        )
      )
    );
  }
}

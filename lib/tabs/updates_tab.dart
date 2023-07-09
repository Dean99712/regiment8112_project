import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:regiment8112_project/models/updates.dart';
import 'package:regiment8112_project/services/news_service.dart';
import '../utils/colors.dart';
import '../widgets/bubble.dart';

class UpdatesTab extends StatefulWidget {
  const UpdatesTab({Key? key}) : super(key: key);

  @override
  State<UpdatesTab> createState() => _UpdatesTabState();
}

class _UpdatesTabState extends State<UpdatesTab> {

  bool isLoading = false;
  final NewsService _service = NewsService();
  late List<Updates> _updates;

  @override
  void initState() {
    getUpdates();
    super.initState();
  }

  Future getUpdates() async {
    setState(() {
      isLoading = true;
    });
    var collection = await _service.getAllUpdates();
    final updates =
    collection.docs.map((e) => Updates.fromSnapshot(e)).toList();
    setState(() {
      isLoading = false;
      _updates = updates;
    });
  }

  @override
  Widget build(BuildContext context) {
     return Stack(
      children: [
        Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: !isLoading
                  ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _updates.length,
                itemBuilder: (context, index) {
                  var timestamp =
                      _updates[index].createdAt.millisecondsSinceEpoch;
                  final date =
                  DateTime.fromMillisecondsSinceEpoch(timestamp);
                  final localDate = intl.DateFormat('yMd', 'en-US').format(date);
                  final update = _updates[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: Bubble(
                      date: localDate,
                      text: update.update,
                    ),
                  );
                },
              )
                  : Center(
                child: PlatformCircularProgressIndicator(
                  cupertino: (_, __) =>
                      CupertinoProgressIndicatorData(
                          radius: 15.0,
                          color: primaryColor
                      ),
                  material: (_, __) =>
                      MaterialProgressIndicatorData(
                          color: secondaryColor
                      ),
                ),
              ),
            )
          ],
        ),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: SizedBox(
            height: 34,
            // width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColorDark,
                        backgroundColorDark.withOpacity(0),
                      ])),
            ),
          ),
        ),
      ],
    );
  }
}

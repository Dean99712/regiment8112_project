import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:regiment8112_project/models/updates.dart';
import 'package:regiment8112_project/services/news_service.dart';
import '../widgets/bubble.dart';

class UpdatesTab extends StatefulWidget {
  const UpdatesTab({Key? key}) : super(key: key);

  @override
  State<UpdatesTab> createState() => _UpdatesTabState();
}

class _UpdatesTabState extends State<UpdatesTab> {
  final NewsService _service = NewsService();
  late List<Updates> _updates;

  @override
  void initState() {
    getUpdates();
    super.initState();
  }

  Future getUpdates() async {
    var collection = await _service.getAllUpdates();
    final updates =
        collection.docs.map((e) => Updates.fromSnapshot(e)).toList();
    setState(() {
      _updates = updates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _updates.length,
                itemBuilder: (context, index) {
                  var timestamp =
                      _updates[index].createdAt.millisecondsSinceEpoch;
                  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                  final localDate =
                      intl.DateFormat('yMd', 'en-US').format(date);
                  final update = _updates[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Bubble(
                      date: localDate,
                      text: update.update,
                    ),
                  );
                },
              ),
            )
          ],
        ),
        SizedBox(
          height: 34,
          // width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(60, 58, 59, 1),
                  Color.fromRGBO(60, 58, 59, 0),
                ])),
          ),
        ),
      ],
    );
  }
}

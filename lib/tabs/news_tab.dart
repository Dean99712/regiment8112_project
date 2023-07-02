import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:regiment8112_project/utils/colors.dart';
import 'package:regiment8112_project/widgets/bubble.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  final NewsService _service = NewsService();
  List<News> newsList = [];

  bool isLoading = false;

  @override
  void initState() {
    getNewsFromDatabase();
    super.initState();
  }

  Future getNewsFromDatabase() async {
    setState(() {
      isLoading = true;
    });
    var collection = await _service.getAllNews();
    var documents =
        collection.docs.map((doc) => News.fromSnapshot(doc)).toList();

    setState(() {
      isLoading = false;
      newsList = documents;
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
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        var timestamp =
                            newsList[index].createdAt.millisecondsSinceEpoch;
                        final date =
                            DateTime.fromMillisecondsSinceEpoch(timestamp);
                        final newDate = intl.DateFormat('yMd', 'en-US').format(date);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Bubble(
                            date: newDate,
                            text: newsList[index].news,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: PlatformCircularProgressIndicator(
                        cupertino: (_, __ ) => CupertinoProgressIndicatorData(
                          radius: 15.0,
                          color: primaryColor
                        ),
                        material: (_, __) => MaterialProgressIndicatorData(
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
        ),
      ],
    );
  }
}

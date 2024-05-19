import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart' as intl;
import '../models/news.dart';
import '../services/news_service.dart';
import '../utils/colors.dart';
import '../widgets/bubble.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  final NewsService _service = NewsService();

  bool isLoading = false;

  Future onRefresh() async {
    return await _service.getAllNews();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: !isLoading
                  ? RefreshIndicator(
                      onRefresh: onRefresh,
                      child: StreamBuilder<List<News>>(
                        stream: _service.streamNews(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<News>> snapshot) {
                          List<News> newsList = snapshot.data ?? [];
                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const BouncingScrollPhysics(),
                            itemCount: newsList.length,
                            itemBuilder: (context, index) {
                              var timestamp = newsList[index]
                                  .createdAt
                                  .millisecondsSinceEpoch;
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                  timestamp);
                              final localDate =
                              intl.DateFormat('yMd', 'es-ES').format(date);
                              final news = newsList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Bubble(
                                  date: localDate,
                                  text: news.news,
                                  deleteFunction: () async {
                                    await _service.removeNews(news.id);
                                  },
                                  editFunction: () async {
                                    await _service.editeNews(news.id, 'new text');
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ))
                  : Center(
                      child: PlatformCircularProgressIndicator(
                        cupertino: (_, __) => CupertinoProgressIndicatorData(
                            radius: 15.0, color: primaryColor),
                        material: (_, __) => MaterialProgressIndicatorData(
                            color: secondaryColor),
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
            height: 35,
            // width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: theme.brightness == Brightness.dark
                      ? [
                          theme.colorScheme.surface,
                          theme.colorScheme.surface.withOpacity(0)
                        ]
                      : [greyShade5, greyShade5.withOpacity(0)],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

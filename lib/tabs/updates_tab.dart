import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart' as intl;
import '../models/updates.dart';
import '../services/news_service.dart';
import '../utils/colors.dart';
import '../widgets/bubble.dart';

class UpdatesTab extends StatefulWidget {
  const UpdatesTab({super.key});

  @override
  State<UpdatesTab> createState() => _UpdatesTabState();
}

class _UpdatesTabState extends State<UpdatesTab> {
  bool isLoading = false;
  final NewsService _service = NewsService();

  Future onRefresh() async {
    return await _service.getAllUpdates();
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
                      onRefresh: () {
                        return onRefresh();
                      },
                      child: StreamBuilder<List<Updates>>(
                        stream: _service.streamUpdates(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          List<Updates> updates = snapshot.data ?? [];

                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const BouncingScrollPhysics(),
                            itemCount: updates.length,
                            itemBuilder: (context, index) {
                              var timestamp = updates[index]
                                  .createdAt
                                  .millisecondsSinceEpoch;
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                  timestamp);
                              final localDate =
                                  intl.DateFormat('yMd', 'es-ES').format(date);
                              final update = updates[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Bubble(
                                  date: localDate,
                                  text: update.update,
                                  deleteFunction: () async{
                                    await _service.removeUpdate(update.id);
                                  },
                                  editFunction: () async {
                                    await _service.editUpdate(update.id, 'new text');
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
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
              )),
            ),
          ),
        ),
      ],
    );
  }
}

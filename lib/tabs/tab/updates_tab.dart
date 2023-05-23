import 'package:flutter/material.dart';
import 'package:regiment8112_project/models/updates.dart';

import '../../widgets/bubble.dart';
import '../../data/updates.dart';

class UpdatesTab extends StatelessWidget {
  const UpdatesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Updates> currentQuestion = updates;

    return Stack(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: currentQuestion.length,
            itemBuilder: (context, index) {
              var currentItem = currentQuestion[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Bubble(
                  date: DateTime(
                          currentItem.dateTime.year,
                          currentItem.dateTime.month,
                          currentItem.dateTime.day)
                      .toString().replaceAll('00:00:00.000', ''),
                  text: currentItem.updates,
                ),
              );
            },
          ),
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

import 'package:flutter/material.dart';
import 'package:regiment8112_project/models/updates.dart';

import '../../bubble.dart';
import '../../data/updates.dart';

class UpdatesTab extends StatelessWidget {
  const UpdatesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Updates> currentQuestion = updates;

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Bubble(
                    date: '04/05/2023',
                    text: currentQuestion[index].updates,
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
      ),
    );
  }
}

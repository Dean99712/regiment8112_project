import 'package:flutter/material.dart';
import 'package:regiment8112_project/widgets/bubble.dart';
import '../../data/news.dart';
import '../../models/news.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<News> data = news;

    return Stack(
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Bubble(
                    date: '04/05/2023',
                    text: data[index].news,
                  ),
                );
              },
            ),
          )],
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

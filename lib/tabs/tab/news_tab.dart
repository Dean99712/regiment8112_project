import 'package:flutter/material.dart';
import '../../custom_text.dart';
import '../../data/news.dart';
import '../../models/news.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {

    News currentQuestion = news[0];

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 34,
            width: 390,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(12, Color.fromRGBO(190, 190, 190, 1), "04/05/2025"),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(121, 121, 121, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: CustomText(16, Colors.white ,currentQuestion.news),
              )
            ],
          )
        ],
      ),
    );
  }
}

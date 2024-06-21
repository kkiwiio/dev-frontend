import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_heck/naver_map/quiz_result.dart';

class QuizScore extends StatefulWidget {
  final int rewardPoints;
  final VoidCallback onPointsUpdated;
  const QuizScore(
      {super.key, required this.rewardPoints, required this.onPointsUpdated});
  @override
  _QuizScoreState createState() => _QuizScoreState();
}

class _QuizScoreState extends State<QuizScore> {
  int rewardPoints = 0;
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void loadRewardPoints(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rewardPoints = prefs.getInt('QrewardPoints') ?? 0;
    });
  }

  void QsaveRewardPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rewardPoints', points);
    setState(() {
      rewardPoints = points;
    });
    widget.onPointsUpdated();
  }

  void Qsubmitscore(BuildContext context, String userAnswer,
      String correctAnswer, String explanation) async {
    bool isCorrect = userAnswer == correctAnswer;

    if (isCorrect) {
      showQuizSuccessDialog(context, rewardPoints + 1);
      QsaveRewardPoints(rewardPoints + 1);
    } else {
      showQuizFailureDialog(context);
    }
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

class Quiz {
  final Map<String, List<Map<String, dynamic>>> quizMap = {
    '상': [
      {
        '질문': '월당관은 이재정 석좌교수의 장인의 유산으로 지어졌습니다. 그 분의 호는 무엇일까요?',
        '정답': '월당',
        '선택지': ['인지', '현덕', '월당', '율곡'],
        '해설': '월당관은 이재정 석좌교수의 장인분의 유산으로 지어졌습니다. 그래서 건물 이름도 그분의 호를 따 지었습니다.'
      }
    ],
    '중': [
      {
        '질문': '월당관에는 ??을 할 수 있는 곳이 있다',
        '정답': 'A/S',
        '선택지': ['A/S', '게임', '졸업', '학점 수정'],
        '해설': '월당관에는 A/S실이 있습니다.'
      }
    ],
    '하': [
      {
        '질문': '월당관 OO에서 공부를 많이 한다.',
        '정답': '열람실',
        '선택지': ['강의실', '3403', '열람실', '프젝실'],
        '해설': '월당관에는 열람실이 있습니다. 시험기간에 쓰기 좋아요.'
      }
    ],
  };

  void showRandomQuiz(BuildContext context) {
    final random = Random();
    String difficulty;

    if (random.nextDouble() < 0.33) {
      difficulty = '상';
    } else if (random.nextDouble() < 0.66) {
      difficulty = '중';
    } else {
      difficulty = '하';
    }

    final randomQuiz = quizMap[difficulty]![random.nextInt(quizMap[difficulty]!.length)];

    _showQuizDialog(context, difficulty, randomQuiz['질문'], randomQuiz['정답'], randomQuiz['선택지'], randomQuiz['해설']);
  }

  void _showQuizDialog(BuildContext context, String difficulty, String question, String answer, List<String> options, String explanation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('퀴즈 ($difficulty)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(question),
              SizedBox(height: 16),
              ...options.map((option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: answer,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  _checkAnswer(context, value!, answer, explanation);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _checkAnswer(BuildContext context, String userAnswer, String correctAnswer, String explanation) {
    bool isCorrect = userAnswer == correctAnswer;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? '정답' : '오답'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isCorrect ? '정답입니다!' : '오답입니다. 정답은 "$correctAnswer" 입니다.'),
              SizedBox(height: 16),
              Text('해설: $explanation'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int rewardPoints = 0;
  int questionIndex = 0; // 현재 퀴즈 인덱스
  int correctAnswers = 0; // 정답 개수
  final List<Map<String, dynamic>> quizList = [
    {
      'difficulty': '상',
      '질문': '월당관은 이재정 석좌교수의 장인의 유산을 기부받아 지어졌습니다. 그 분의 호는 무엇일까요?',
      '정답': '월당',
      '선택지': ['월당', '현덕', '인지', '삼봉'],
      '해설': '이 건물은 기부하신 분의 호를 따 월당관으로 명명되었습니다.'
    },
    {
      'difficulty': '중',
      '질문': '월당관에는 ??을 할 수 있는 곳이 있다',
      '정답': 'A/S',
      '선택지': ['학점 수정', '게임', '졸업', 'A/S'],
      '해설': '정답은 A/S입니다. 월당관에는 A/S실이 있어요.'
    },
    {
      'difficulty': '하',
      '질문': '월당관 OO에서 공부를 많이 한다.',
      '정답': '열람실',
      '선택지': ['프로젝트실', '3302', '열람실', '3301'],
      '해설': '월당관에는 열람실이 있습니다. 시험기간에 많은 학생들이 애용하는 곳이에요.'
    },
  ];

  @override
  void initState() {
    super.initState();
    loadRewardPoints();
  }

  Future<void> loadRewardPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rewardPoints = prefs.getInt('rewardPoints') ?? 0;
    });
  }

  Future<void> saveRewardPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rewardPoints', points);
    setState(() {
      rewardPoints = points;
    });
  }

  void _showNextQuiz(BuildContext context) {
    if (questionIndex < quizList.length) {
      final quiz = quizList[questionIndex];
      _showQuizDialog(
        context,
        quiz['difficulty'],
        quiz['질문'],
        quiz['정답'],
        quiz['선택지'],
        quiz['해설'],
      );
    } else {
      _showQuizResult(context);
    }
  }

  void _showQuizDialog(BuildContext context, String difficulty, String question,
      String answer, List<String> options, String explanation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('퀴즈 ($difficulty)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(question),
              const SizedBox(height: 16),
              ...options.map((option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: null,
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

  void _checkAnswer(BuildContext context, String userAnswer,
      String correctAnswer, String explanation) async {
    bool isCorrect = userAnswer == correctAnswer;

    if (isCorrect) {
      correctAnswers++;
      saveRewardPoints(rewardPoints + 1);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? '정답' : '오답'),
          content: Text(isCorrect ? '정답입니다!\n\n해설: $explanation' : '오답입니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  questionIndex++;
                });
                _showNextQuiz(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showQuizResult(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('퀴즈 결과'),
          content: Text(
              '퀴즈가 끝났습니다.\n맞힌 개수: $correctAnswers\n리워드 포인트: $rewardPoints'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showNextQuiz(context);
          },
          child: const Text('퀴즈 시작하기'),
        ),
      ),
    );
  }
}

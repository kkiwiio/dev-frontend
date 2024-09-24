import 'package:flutter/material.dart';
import '../naver_map/naver_map.dart';

void showQuizSuccessDialog(BuildContext context, int rewardPoints) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('미션 성공'),
        content: const Text('미션을 성공적으로 완료했습니다!'),
        actions: [
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
              navigateToNaverMapScreen(context);
            },
          ),
        ],
      );
    },
  );
}

void navigateToNaverMapScreen(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const NaverMapApp()),
  );
}

void showQuizFailureDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('미션 실패'),
        content: const Text('미션에 실패했습니다. 다시 시도해 주세요.'),
        actions: [
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

import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
    clientId: '7vff5ieoeb',
    onAuthFailed: (error) {
      print('Auth failed: $error');
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // const 제거됨
      localizationsDelegates: const [
        // 개별 리스트에는 const 추가
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // 개별 리스트에는 const 추가
        Locale('en', ''), // 영어
        Locale('ko', ''), // 한국어
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale?.languageCode == 'ko') {
          return const Locale('ko');
        }
        return const Locale('en');
      },
      debugShowCheckedModeBanner: false,
      title: 'skhu adventure',
      home: const OnboardingPage(),
    );
  }
}

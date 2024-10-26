import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
    clientId: ,
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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
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

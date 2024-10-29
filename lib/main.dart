import 'package:flutter/material.dart';
import 'initial_screen.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'services/ImageTransform_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 네이버 맵 SDK 초기화를 더 명시적으로 처리
  try {
    await NaverMapSdk.instance.initialize(
      clientId: '7vff5ieoeb',
      onAuthFailed: (error) {
        print('Naver Map Auth failed: $error');
      },
    );
    print('Naver Map initialized successfully');
  } catch (e) {
    print('Error initializing Naver Map: $e');
  }

  final imageService = ImageTransformationService();
  imageService.initialize();
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
        Locale('en', ''),
        Locale('ko', ''),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale?.languageCode == 'ko') {
          return const Locale('ko');
        }
        return const Locale('en');
      },
      debugShowCheckedModeBanner: false,
      title: 'skhu adventure',
      home: const InitialScreen(),
    );
  }
}

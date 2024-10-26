import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.transformingImage,
              style: const TextStyle(
                fontFamily: 'GmarketSansTTFMedium',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

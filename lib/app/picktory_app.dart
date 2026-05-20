import 'package:flutter/material.dart';
import 'package:picktory/core/navigation/app_router.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';

class PicktoryApp extends StatelessWidget {
  const PicktoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Picktory',
      debugShowCheckedModeBanner: false,
      theme: OnboardingTheme.themeData(),
      routerConfig: AppRouter.create(),
    );
  }
}

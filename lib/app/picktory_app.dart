import 'package:flutter/material.dart';
import 'package:picktory/core/navigation/app_router.dart';

class PicktoryApp extends StatelessWidget {
  const PicktoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Picktory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.create(),
    );
  }
}

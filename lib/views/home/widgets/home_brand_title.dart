import 'package:flutter/material.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeBrandTitle extends StatelessWidget {
  const HomeBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'PICTORY',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: HomeTheme.primaryPurple,
        letterSpacing: 1.2,
        height: 1,
      ),
    );
  }
}

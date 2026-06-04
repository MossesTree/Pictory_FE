import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomePickSectionTitle extends StatelessWidget {
  const HomePickSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PicktorySpacing.md,
        PicktorySpacing.lg,
        PicktorySpacing.md,
        PicktorySpacing.sm,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: HomeTheme.sectionTitle,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

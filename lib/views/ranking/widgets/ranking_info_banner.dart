import 'package:flutter/material.dart';
import 'package:picktory/views/ranking/ranking_theme.dart';

class RankingInfoBanner extends StatelessWidget {
  const RankingInfoBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RankingTheme.primaryLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: RankingTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

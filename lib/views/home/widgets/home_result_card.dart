import 'package:flutter/material.dart';
import 'package:picktory/models/mission_result.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeResultCard extends StatelessWidget {
  const HomeResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  final MissionResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HomeTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: HomeTheme.surfaceLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: HomeTheme.yellow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '결과공개',
                  style: TextStyle(
                    color: HomeTheme.yellow,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.programLabel,
                style: const TextStyle(
                  color: HomeTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                result.resultLabel,
                style: TextStyle(
                  color: result.isCorrect
                      ? HomeTheme.correct
                      : HomeTheme.wrong,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${result.participantCount}명 참여',
                style: const TextStyle(
                  color: HomeTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

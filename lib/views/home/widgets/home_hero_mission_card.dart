import 'package:flutter/material.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

class HomeHeroMissionCard extends StatelessWidget {
  const HomeHeroMissionCard({
    super.key,
    required this.mission,
    required this.onParticipate,
  });

  final Mission mission;
  final VoidCallback onParticipate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HomeTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HomeTheme.surfaceLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (mission.isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '마감 임박',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                const Spacer(),
                Text(
                  '${mission.pointCost}P',
                  style: const TextStyle(color: HomeTheme.yellow),
                ),
              ],
            ),
            const Spacer(),
            Text(
              mission.programLabel,
              style: const TextStyle(color: HomeTheme.textSecondary),
            ),
            Text(
              mission.title,
              style: const TextStyle(
                color: HomeTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${mission.remainingLabel} · ${mission.participantCount}명',
              style: const TextStyle(color: HomeTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            MissionYellowButton(
              label: '참여하기',
              onPressed: onParticipate,
            ),
          ],
        ),
      ),
    );
  }
}

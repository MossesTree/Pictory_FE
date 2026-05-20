import 'package:flutter/material.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';

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
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
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
                _PointBadge(points: mission.pointCost),
              ],
            ),
            const Spacer(),
            Text(
              mission.programLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              mission.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${mission.remainingLabel} · ${mission.participantCount}명',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 120,
                child: WireframeButton(
                  label: '참여하기',
                  onPressed: onParticipate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointBadge extends StatelessWidget {
  const _PointBadge({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$points포인트'),
    );
  }
}

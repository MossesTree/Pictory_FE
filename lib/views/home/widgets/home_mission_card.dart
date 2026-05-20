import 'package:flutter/material.dart';
import 'package:picktory/models/mission.dart';

class HomeMissionCard extends StatelessWidget {
  const HomeMissionCard({
    super.key,
    required this.mission,
    required this.onTap,
    required this.onChoiceTap,
  });

  final Mission mission;
  final VoidCallback onTap;
  final void Function(String choice) onChoiceTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      mission.programLabel,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Text('${mission.pointCost}포인트'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mission.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${mission.remainingLabel} · ${mission.participantCount}명',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (mission.choices.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...mission.choices.map(
                  (choice) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OutlinedButton(
                      onPressed: () => onChoiceTap(choice),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(choice),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

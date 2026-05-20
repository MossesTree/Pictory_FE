import 'package:flutter/material.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeMissionCard extends StatelessWidget {
  const HomeMissionCard({
    super.key,
    required this.mission,
    required this.onTap,
    required this.onChoiceTap,
  });

  final Mission mission;
  final VoidCallback onTap;
  final void Function(String choiceId) onChoiceTap;

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
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: HomeTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.live_tv_outlined,
                      color: HomeTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${mission.programLabel} - ${mission.title}',
                          style: const TextStyle(
                            color: HomeTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${mission.remainingLabel} · ${mission.participantCount}명',
                          style: const TextStyle(
                            color: HomeTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (mission.choices.length >= 2) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ChoiceButton(
                        label: mission.choices[0].label,
                        onPressed: () => onChoiceTap(mission.choices[0].id),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ChoiceButton(
                        label: mission.choices[1].label,
                        onPressed: () => onChoiceTap(mission.choices[1].id),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: HomeTheme.textPrimary,
        side: const BorderSide(color: HomeTheme.surfaceLight),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
